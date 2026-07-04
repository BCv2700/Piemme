import { useState, useEffect, useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import api from '../api/api';
import DetailEncaissementModal from '../components/DetailEncaissementModal';
import TicketImprimable from '../components/TicketImprimable';
import { genererDonneesTicketDepuisEncaissement, genererPdfTicket } from '../utils/ticket';

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
  // Lit la date transmise par le Plan de salle (NavBar) au montage du composant.
  // S'il n'y en a pas (accès direct à /encaissements), on retombe sur aujourd'hui.
  const dateInitiale = searchParams.get('date') || todayKey();

  const [dateUnique, setDateUnique] = useState(dateInitiale);
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [detailOuvert, setDetailOuvert] = useState(null); // id de l'encaissement affiché dans la modale, ou null
  const [ticketAImprimer, setTicketAImprimer] = useState(null); // données du ticket en cours de réimpression papier

  const load = () => {
    setLoading(true);
    api.get('/encaissements/', { params: { date_debut: dateUnique, date_fin: dateUnique } })
      .then(r => setEncaissements(r.data))
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

  // Tous les totaux ci-dessous ne portent que sur les vraies recettes : les
  // encaissements de type dépense (depenses=true, montants négatifs) sont
  // exclus, pour ne pas polluer Cash/Carte/TVA avec des sorties de caisse.
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Répartition par taux de TVA, calculée à partir des lignes des seules recettes du jour
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

  const deleteEncaissement = async (encId) => {
    if (!window.confirm('Supprimer cet encaissement et toutes ses lignes ? Action irréversible.')) return;
    try {
      await api.delete('/encaissements/' + encId);
      showMsg('success', 'Encaissement supprimé');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  // Réimpression papier d'un ticket déjà enregistré : on construit les
  // données du ticket depuis l'encaissement existant (pas de recréation en
  // base), on les pousse dans TicketImprimable, puis on déclenche l'impression.
  const reimprimerTicket = (enc) => {
    if (enc.depenses) return; // pas de ticket client pour une dépense
    const data = genererDonneesTicketDepuisEncaissement(enc);
    setTicketAImprimer(data);
    setTimeout(() => window.print(), 200);
  };

  const telechargerPdfTicket = (enc) => {
    if (enc.depenses) return;
    const data = genererDonneesTicketDepuisEncaissement(enc);
    genererPdfTicket(data);
  };

  const encaissementsTries = [...encaissements].sort((a, b) => new Date(a.date_encaissement) - new Date(b.date_encaissement));

  // Styles de cellules avec quadrillage
  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, ...extra });

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

        {/* Navigation jour par jour */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
          <div style={{ marginLeft: 'auto', display: 'flex', gap: 18, alignItems: 'baseline' }}>
            <span style={{ fontSize: 13, color: '#888' }}>
              Cash analysé : <strong style={{ fontSize: 14, color: '#b45309' }}>{totalCashAnalyse.toFixed(2)} €</strong>
            </span>
            <span style={{ fontSize: 14, fontWeight: 700 }}>{totalJour.toFixed(2)} €</span>
          </div>
        </div>

        {/* Répartition par TVA et paiement */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          {TAUX_TVA.map(taux => (
            <div key={taux} style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
              <div style={{ fontSize: 11, color: '#888' }}>TVA {taux}%</div>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{repartitionTva[taux].toFixed(2)} €</div>
            </div>
          ))}
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Cash</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#16a34a' }}>{totalCash.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Carte</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#2563eb' }}>{totalCarte.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Cash analysé</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#b45309' }}>{totalCashAnalyse.toFixed(2)} €</div>
          </div>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : encaissementsTries.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun encaissement ce jour</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden' }}>
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
                  <th style={thCell({ textAlign: 'center' })}>Emporté</th>
                  <th style={thCell({ textAlign: 'center' })}>Dépenses</th>
                  <th style={thCell({ textAlign: 'center' })}>Cash</th>
                  <th style={thCell({ textAlign: 'center' })}>Carte</th>
                  <th style={thCell({ textAlign: 'center' })}>Total</th>
                  <th style={thCell({ textAlign: 'right' })}>Cash analysé</th>
                </tr>
              </thead>
              <tbody>
                {encaissementsTries.map(enc => (
                  <tr key={enc.id}>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ width: 22, height: 22, padding: 0, fontSize: 11 }}
                        title="Voir / corriger le détail"
                        onClick={() => setDetailOuvert(enc.id)}
                      >⋯</button>
                    </td>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                        onClick={() => deleteEncaissement(enc.id)}
                      >✕</button>
                    </td>
                    <td style={tdCell({ textAlign: 'center', whiteSpace: 'nowrap' })}>
                      {!enc.depenses && (
                        <>
                          <button
                            className="btn"
                            style={{ width: 22, height: 22, padding: 0, fontSize: 11, marginRight: 4 }}
                            title="Réimprimer le ticket"
                            onClick={() => reimprimerTicket(enc)}
                          >🖨️</button>
                          <button
                            className="btn"
                            style={{ width: 22, height: 22, padding: 0, fontSize: 11 }}
                            title="Ticket en PDF"
                            onClick={() => telechargerPdfTicket(enc)}
                          >📄</button>
                        </>
                      )}
                    </td>
                    <td style={tdCell({ color: '#aaa' })}>{enc.id}</td>
                    <td style={tdCell({ whiteSpace: 'nowrap', color: '#666' })}>
                      {new Date(enc.date_encaissement).toLocaleTimeString('fr-BE', { hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
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
                    <td style={tdCell({ color: '#666' })}>{enc.nom_reservation_archive || '—'}</td>
                    <td style={tdCell({ textAlign: 'center' })}>
                      <input type="checkbox" checked={!!enc.emporte} onChange={() => toggleBool(enc, 'emporte')} style={{ width: 15, height: 15, cursor: 'pointer' }} />
                    </td>
                    <td style={tdCell({ textAlign: 'center' })}>
                      <input type="checkbox" checked={!!enc.depenses} onChange={() => toggleBool(enc, 'depenses')} style={{ width: 15, height: 15, cursor: 'pointer' }} />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_cash}
                        onChange={(e) => majLocal(enc.id, 'montant_cash', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_carte}
                        onChange={(e) => majLocal(enc.id, 'montant_carte', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
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

      <TicketImprimable data={ticketAImprimer} />
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '2px 6px',
  borderRadius: 5,
  border: '1px solid transparent',
  background: 'transparent',
  fontSize: 12,
  boxSizing: 'border-box',
};