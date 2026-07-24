import { useState, useEffect, useMemo } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api/api';
import DetailEncaissementModal from '../components/DetailEncaissementModal';
import SelecteurClient from '../components/SelecteurClient';
import { genererDonneesTicketDepuisEncaissement, genererPdfTicket, imprimerTicket } from '../utils/ticket';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

const TAUX_TVA = [6, 12, 21];

// Bordure de quadrillage commune à toutes les cellules du tableau
const BORDURE = '1px solid #e5e5e0';

export default function Encaissements() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const dateInitiale = searchParams.get('date') || todayKey();

  const [dateUnique, setDateUnique] = useState(dateInitiale);
  const [encaissements, setEncaissements] = useState([]);
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [detailOuvert, setDetailOuvert] = useState(null);
  const [idsServicesLies, setIdsServicesLies] = useState(new Set());
  // Confirmation de suppression en deux taps (remplace window.confirm, qui
  // ne fonctionne pas sur Safari iPad dans certains contextes tactiles).
  const [confirmDelete, setConfirmDelete] = useState(null);

  const load = () => {
    setLoading(true);
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateUnique, date_fin: dateUnique } }),
      api.get('/clients/'),
      api.get('/service-personnel/', { params: { date_debut: dateUnique, date_fin: dateUnique } }),
    ])
      .then(([encRes, clientsRes, servicesRes]) => {
        setEncaissements(encRes.data);
        setClients(clientsRes.data);
        const ids = new Set(servicesRes.data.map(s => s.encaissement_id).filter(id => id != null));
        setIdsServicesLies(ids);
      })
      .catch(() => setError('Impossible de charger les encaissements'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateUnique]);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const errMsg = (e, fallback) => {
    const detail = e.response?.data?.detail;
    if (!detail) return fallback;
    if (typeof detail === 'string') return detail;
    if (Array.isArray(detail)) return detail.map(d => d.msg || JSON.stringify(d)).join(' · ');
    return fallback;
  };

  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  const repartitionTva = useMemo(() => {
    const totaux = { 6: 0, 12: 0, 21: 0, autre: 0 };
    recettes.forEach(enc => {
      (enc.lignes || []).forEach(ligne => {
        const montant = Number(ligne.prix_vente) * Number(ligne.quantite);
        const taux = Math.round(Number(ligne.tva));
        if (totaux[taux] !== undefined) {
          totaux[taux] += montant;
        } else {
          totaux.autre += montant;
        }
      });
    });
    return totaux;
  }, [recettes]);

  const totalJour = recettes.reduce((s, e) => s + Number(e.montant_total || 0), 0);
  const totalCash = recettes.reduce((s, e) => s + Number(e.montant_cash || 0), 0);
  const totalCarte = recettes.reduce((s, e) => s + Number(e.montant_carte || 0), 0);
  const totalCashAnalyse = recettes.reduce((s, e) => s + Number(e.cash_analyse || 0), 0);

  const majLocal = (encId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => e.id === encId ? { ...e, [champ]: valeur } : e));
  };

  const saveEncaissement = async (enc) => {
    try {
      await api.patch('/encaissements/' + enc.id, {
        table_nom: enc.table_nom,
        montant_carte: Number(enc.montant_carte),
        montant_cash: Number(enc.montant_cash),
        montant_total: Number(enc.montant_total),
        serveur: enc.serveur,
        remarque: enc.remarque,
        depenses: !!enc.depenses,
        emporte: !!enc.emporte,
        nb_personnes: Number(enc.nb_personnes) || 1,
      });
      showMsg('success', 'Encaissement mis à jour');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  const toggleBool = async (enc, champ) => {
    const nouvelleValeur = !enc[champ];
    majLocal(enc.id, champ, nouvelleValeur);
    try {
      await api.patch('/encaissements/' + enc.id, { [champ]: nouvelleValeur });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  const changerClient = async (enc, nouveauClientId) => {
    majLocal(enc.id, 'client_id', nouveauClientId);
    try {
      await api.patch('/encaissements/' + enc.id, { client_id: nouveauClientId });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors du changement de client'));
      load();
    }
  };

  const changerNbPersonnes = async (enc, valeur) => {
    const n = Number(valeur);
    if (!Number.isFinite(n) || n < 1) return;
    if (n === Number(enc.nb_personnes)) return;
    majLocal(enc.id, 'nb_personnes', n);
    try {
      await api.patch('/encaissements/' + enc.id, { nb_personnes: n });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour du nombre de personnes'));
      load();
    }
  };

  // Suppression en deux taps : premier tap → le bouton passe en mode "Sûr ?",
  // deuxième tap dans les 4 secondes → suppression effective. Évite
  // window.confirm() qui ne fonctionne pas toujours sur Safari iPad.
  const deleteEncaissement = async (encId) => {
    if (confirmDelete !== encId) {
      setConfirmDelete(encId);
      setTimeout(() => setConfirmDelete(prev => prev === encId ? null : prev), 4000);
      return;
    }
    setConfirmDelete(null);
    try {
      await api.delete('/encaissements/' + encId);
      showMsg('success', 'Encaissement supprimé');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  // 🖨️ Impression directe (HTML + @page) — fonctionne sur imprimante thermique
  // sans le problème de papier blanc causé par le PDF interprété en A4.
  const reimprimerTicket = (enc) => {
    if (enc.depenses) return;
    const data = genererDonneesTicketDepuisEncaissement(enc);
    imprimerTicket(data);
  };

  // 📄 Ouvre le ticket en PDF dans un nouvel onglet (pour voir / sauvegarder)
  const telechargerPdfTicket = (enc) => {
    if (enc.depenses) return;
    const data = genererDonneesTicketDepuisEncaissement(enc);
    genererPdfTicket(data);
  };

  const ouvrirDetailOuService = async (enc) => {
    if (enc.depenses) {
      try {
        const res = await api.get('/service-personnel/by-encaissement/' + enc.id);
        const service = res.data;
        navigate('/personnel?date=' + service.date_service + '&service=' + service.id);
        return;
      } catch (e) {
        // Pas de service personnel lié : on continue vers le détail générique.
      }
    }
    setDetailOuvert(enc.id);
  };

  const estServiceMigrable = (enc) => {
    if (!enc.depenses || !enc.lignes || !enc.lignes[0]) return false;
    const nomArticle = (enc.lignes[0].article_nom || '').trim().toLowerCase();
    return nomArticle.startsWith('service ');
  };

  const estDejaCorrige = (enc) => idsServicesLies.has(enc.id);

  const migrerVersPersonnel = async (enc) => {
    try {
      const res = await api.post('/service-personnel/depuis-encaissement/' + enc.id);
      navigate('/personnel?date=' + res.data.date_service + '&service=' + res.data.id);
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la migration'));
    }
  };

  const encaissementsTries = [...encaissements].sort((a, b) => new Date(a.date_encaissement) - new Date(b.date_encaissement));

  const thCell = (extra = {}) => ({ padding: '5px 6px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '3px 6px', border: BORDURE, ...extra });

  return (
    <div>
      <div className="content">
        <style>{`
          .cell-input:focus {
            outline: none;
            border: 1px solid #bbb !important;
            background: #fff !important;
          }
        `}</style>

        {msg && (
          <div style={{
            padding: '10px 16px', borderRadius: 8, marginBottom: 16, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
            border: '1px solid ' + (msg.type === 'success' ? '#86efac' : '#fca5a5')
          }}>
            {msg.text}
          </div>
        )}

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

{/* Navigation + pastilles TVA sur une seule barre */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 16, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
          <button
            className="btn"
            style={{ background: '#b91c1c', color: 'white', borderColor: '#b91c1c', fontWeight: 600 }}
            onClick={() => navigate('/caddy/14')}
          >
            + Dépense
          </button>

          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginLeft: 8 }}>
            {TAUX_TVA.map(taux => (
              <div key={taux} style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '4px 10px', minWidth: 70 }}>
                <div style={{ fontSize: 10, color: '#888' }}>TVA {taux}%</div>
                <div style={{ fontSize: 13, fontWeight: 700 }}>{repartitionTva[taux].toFixed(2)} €</div>
              </div>
            ))}
            <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '4px 10px', minWidth: 70 }}>
              <div style={{ fontSize: 10, color: '#888' }}>Cash</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: '#16a34a' }}>{totalCash.toFixed(2)} €</div>
            </div>
            <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '4px 10px', minWidth: 70 }}>
              <div style={{ fontSize: 10, color: '#888' }}>Carte</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: '#2563eb' }}>{totalCarte.toFixed(2)} €</div>
            </div>
            <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '4px 10px', minWidth: 70 }}>
              <div style={{ fontSize: 10, color: '#888' }}>Cash analysé</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: '#b45309' }}>{totalCashAnalyse.toFixed(2)} €</div>
            </div>
            <div style={{ background: '#111', borderRadius: 8, padding: '4px 10px', minWidth: 70 }}>
              <div style={{ fontSize: 10, color: '#aaa' }}>Total</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: 'white' }}>{totalJour.toFixed(2)} €</div>
            </div>
          </div>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : encaissementsTries.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun encaissement ce jour</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}></th>
                  <th style={thCell()}></th>
                  <th style={thCell({ textAlign: 'center' })}>Ticket</th>
                  <th style={thCell()}>Réf</th>
                  <th style={thCell()}>Heure</th>
                  <th style={thCell()}>Ticket</th>
                  <th style={thCell()}>Réservation</th>
                  <th style={thCell()}>Client</th>
                  <th style={thCell({ textAlign: 'right' })}>Nb pers.</th>
                  <th style={thCell({ textAlign: 'center' })}>Emp.</th>
                  <th style={thCell({ textAlign: 'center' })}>Dép.</th>
                  <th style={thCell({ textAlign: 'center' })}>Cash</th>
                  <th style={thCell({ textAlign: 'center' })}>Carte</th>
                  <th style={thCell({ textAlign: 'center' })}>Total</th>
                  <th style={thCell({ textAlign: 'right' })}>Cash analysé</th>
                </tr>
              </thead>
              <tbody>
                {encaissementsTries.map(enc => (
                  <tr key={enc.id} style={estDejaCorrige(enc) ? { background: '#f0fdf4' } : undefined}>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ minWidth: 36, minHeight: 36, padding: 0, fontSize: 11, cursor: 'pointer' }}
                        title="Voir / corriger le détail"
                        onClick={() => ouvrirDetailOuService(enc)}
                      >⋯</button>
                    </td>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{
                          minWidth: 36, minHeight: 36, padding: '0 6px', fontSize: 11, cursor: 'pointer',
                          color: confirmDelete === enc.id ? 'white' : '#dc2626',
                          background: confirmDelete === enc.id ? '#dc2626' : 'transparent',
                          borderColor: '#fca5a5',
                          fontWeight: confirmDelete === enc.id ? 700 : 400,
                        }}
                        onClick={() => deleteEncaissement(enc.id)}
                      >{confirmDelete === enc.id ? 'Sûr ?' : '✕'}</button>
                    </td>
                    <td style={tdCell({ textAlign: 'center', whiteSpace: 'nowrap' })}>
                      {!enc.depenses ? (
                        <>
                          <button
                            className="btn"
                            style={{ minWidth: 32, minHeight: 32, padding: 0, fontSize: 11, marginRight: 3, cursor: 'pointer' }}
                            title="Réimprimer le ticket"
                            onClick={() => reimprimerTicket(enc)}
                          >🖨️</button>
                          <button
                            className="btn"
                            style={{ minWidth: 32, minHeight: 32, padding: 0, fontSize: 11, cursor: 'pointer' }}
                            title="Ticket en PDF"
                            onClick={() => telechargerPdfTicket(enc)}
                          >📄</button>
                        </>
                      ) : estServiceMigrable(enc) ? (
                        estDejaCorrige(enc) ? (
                          <button
                            className="btn"
                            style={{ minWidth: 32, minHeight: 32, padding: 0, fontSize: 11, color: '#16a34a', borderColor: '#86efac', cursor: 'pointer' }}
                            title="Déjà repris dans Personnel — cliquer pour ouvrir sa fiche"
                            onClick={() => ouvrirDetailOuService(enc)}
                          >✔</button>
                        ) : (
                          <button
                            className="btn"
                            style={{ minWidth: 32, minHeight: 32, padding: 0, fontSize: 11, color: '#b45309', borderColor: '#fde68a', cursor: 'pointer' }}
                            title="Migrer (temporaire) vers le module Personnel"
                            onClick={() => migrerVersPersonnel(enc)}
                          >🔧</button>
                        )
                      ) : null}
                    </td>
                    <td style={tdCell({ color: '#aaa', width: 44 })}>{enc.id}</td>
                    <td style={tdCell({ whiteSpace: 'nowrap', color: '#666', width: 54 })}>
                      {new Date(enc.date_encaissement).toLocaleTimeString('fr-BE', { hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={tdCell({ padding: '2px 4px', width: 64 })}>
                      {enc.depenses ? (
                        <span style={{ fontSize: 12, color: '#b91c1c', fontWeight: 600, paddingLeft: 4 }}>
                          {enc.lignes && enc.lignes[0] ? enc.lignes[0].article_nom : '—'}
                        </span>
                      ) : (
                        <input
                          className="cell-input" style={{ ...inputStyle, width: '100%' }}
                          value={enc.table_nom || ''}
                          onChange={(e) => majLocal(enc.id, 'table_nom', e.target.value)}
                          onBlur={() => saveEncaissement(enc)}
                        />
                      )}
                    </td>
                    <td style={tdCell({ color: '#666', maxWidth: 100, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' })}>
                      {enc.nom_reservation_archive || '—'}
                    </td>
                    <td style={tdCell({ padding: '2px 4px' })}>
                      <SelecteurClient
                        clients={clients}
                        clientId={enc.client_id ?? null}
                        onChange={(id) => changerClient(enc, id)}
                        compact
                        style={{ width: '100%' }}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 4px' })}>
                      <input
                        type="number" min="1"
                        className="cell-input" style={{ ...inputStyle, width: 50, textAlign: 'right' }}
                        defaultValue={enc.nb_personnes ?? 1}
                        onBlur={(e) => changerNbPersonnes(enc, e.target.value)}
                        onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                      />
                    </td>
                    <td style={tdCell({ textAlign: 'center' })}>
                      <input type="checkbox" checked={!!enc.emporte} onChange={() => toggleBool(enc, 'emporte')} style={{ width: 14, height: 14, cursor: 'pointer' }} />
                    </td>
                    <td style={tdCell({ textAlign: 'center' })}>
                      <input type="checkbox" checked={!!enc.depenses} onChange={() => toggleBool(enc, 'depenses')} style={{ width: 14, height: 14, cursor: 'pointer' }} />
                    </td>
                    <td style={tdCell({ padding: '2px 4px', width: 72 })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_cash}
                        onChange={(e) => majLocal(enc.id, 'montant_cash', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 4px', width: 72 })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_carte}
                        onChange={(e) => majLocal(enc.id, 'montant_carte', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 4px', width: 76 })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right', fontWeight: 700 }}
                        value={enc.montant_total}
                        onChange={(e) => majLocal(enc.id, 'montant_total', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ textAlign: 'right', fontWeight: 600, color: Number(enc.cash_analyse) > 0 ? '#16a34a' : '#888' })}>
                      {Number(enc.cash_analyse || 0).toFixed(2)} €
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {detailOuvert && (
        <DetailEncaissementModal
          encaissementId={detailOuvert}
          onClose={() => setDetailOuvert(null)}
          onChanged={load}
        />
      )}
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '2px 4px',
  borderRadius: 5,
  border: '1px solid transparent',
  background: 'transparent',
  fontSize: 12,
  boxSizing: 'border-box',
};
