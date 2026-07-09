import { useState, useEffect, useMemo } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api/api';
import DetailEncaissementModal from '../components/DetailEncaissementModal';
import SelecteurClient from '../components/SelecteurClient';
import TicketImprimable from '../components/TicketImprimable';
import { genererDonneesTicketDepuisEncaissement, genererPdfTicket } from '../utils/ticket';

const MOIS_NOMS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function joursDansMois(annee, mois) {
  return new Date(annee, mois, 0).getDate();
}

function pad2(n) { return String(n).padStart(2, '0'); }

function dateKey(annee, mois, jour) {
  return annee + '-' + pad2(mois) + '-' + pad2(jour);
}

const BORDURE = '1px solid #e5e5e0';

export default function EncaissementsMois() {
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();
  const dateInitiale = searchParams.get('date') || todayKey();
  const [anneeStr, moisStr] = dateInitiale.split('-');

  const [annee, setAnnee] = useState(Number(anneeStr));
  const [mois, setMois] = useState(Number(moisStr));
  const [encaissements, setEncaissements] = useState([]);
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [detailOuvert, setDetailOuvert] = useState(null);
  const [ticketAImprimer, setTicketAImprimer] = useState(null);
  const [filtreTable, setFiltreTable] = useState(searchParams.get('filtre') || '');
  const [idsServicesLies, setIdsServicesLies] = useState(new Set());

  // Garde le filtre dans l'URL en temps réel (pas seulement au moment du
  // clic vers Personnel) : ainsi il survit aussi à un bouton "précédent" du
  // navigateur, une actualisation de page, ou un lien partagé — pas
  // uniquement au retour via nos propres boutons Annuler/Enregistrer.
  useEffect(() => {
    const next = new URLSearchParams(searchParams);
    if (filtreTable.trim()) next.set('filtre', filtreTable.trim());
    else next.delete('filtre');
    setSearchParams(next, { replace: true });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filtreTable]);

  const load = () => {
    setLoading(true);
    const dateDebut = dateKey(annee, mois, 1);
    const dateFin = dateKey(annee, mois, joursDansMois(annee, mois));
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateDebut, date_fin: dateFin } }),
      api.get('/clients/'),
      api.get('/service-personnel/', { params: { date_debut: dateDebut, date_fin: dateFin } }),
    ])
      .then(([encRes, clientsRes, servicesRes]) => {
        setEncaissements(encRes.data);
        setClients(clientsRes.data);
        // Encaissements déjà reliés à une fiche Personnel (sert à distinguer
        // les "Service XXX" déjà corrigés de ceux qui restent à migrer).
        const ids = new Set(servicesRes.data.map(s => s.encaissement_id).filter(id => id != null));
        setIdsServicesLies(ids);
      })
      .catch(() => setError('Impossible de charger les encaissements'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [annee, mois]);

  const moisPrecedent = () => {
    if (mois === 1) { setMois(12); setAnnee(a => a - 1); } else { setMois(m => m - 1); }
  };
  const moisSuivant = () => {
    if (mois === 12) { setMois(1); setAnnee(a => a + 1); } else { setMois(m => m + 1); }
  };
  const moisActuel = () => {
    const d = new Date();
    setAnnee(d.getFullYear());
    setMois(d.getMonth() + 1);
  };

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
  const totalMois = recettes.reduce((s, e) => s + Number(e.montant_total || 0), 0);

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
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
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

  const reimprimerTicket = (enc) => {
    if (enc.depenses) return;
    const data = genererDonneesTicketDepuisEncaissement(enc);
    setTicketAImprimer(data);
    setTimeout(() => window.print(), 200);
  };

  const telechargerPdfTicket = (enc) => {
    if (enc.depenses) return;
    const data = genererDonneesTicketDepuisEncaissement(enc);
    genererPdfTicket(data);
  };

  // Lien vers Personnel, en conservant le filtre actif (query "filtre") pour
  // qu'il soit toujours là au retour, au lieu de repartir à vide.
  const suffixeFiltre = filtreTable.trim() ? '&filtre=' + encodeURIComponent(filtreTable.trim()) : '';

  // Clic sur "⋯" : si la dépense provient d'une saisie de service personnel
  // (module Personnel), on redirige vers cet écran (avec retour=mois, pour
  // revenir ici à la fermeture) plutôt que d'ouvrir le détail générique.
  const ouvrirDetailOuService = async (enc) => {
    if (enc.depenses) {
      try {
        const res = await api.get('/service-personnel/by-encaissement/' + enc.id);
        const service = res.data;
        navigate('/personnel?date=' + service.date_service + '&service=' + service.id + '&retour=mois' + suffixeFiltre);
        return;
      } catch (e) {
        // Pas de service personnel lié : détail générique comme avant.
      }
    }
    setDetailOuvert(enc.id);
  };

  // Repère les anciennes dépenses "Service XXX" pas encore reliées au module
  // Personnel (bouton de migration temporaire, à retirer une fois
  // l'historique repris).
  const estServiceMigrable = (enc) => {
    if (!enc.depenses || !enc.lignes || !enc.lignes[0]) return false;
    const nomArticle = (enc.lignes[0].article_nom || '').trim().toLowerCase();
    return nomArticle.startsWith('service ');
  };

  // Un "Service XXX" déjà relié à une fiche Personnel (migré ou créé
  // directement via le nouveau module) : plus besoin du bouton de migration,
  // juste un indicateur visuel qu'il a déjà été corrigé.
  const estDejaCorrige = (enc) => idsServicesLies.has(enc.id);

  // ⚠️ TEMPORAIRE : relie un ancien encaissement "Service XXX" à une nouvelle
  // fiche du module Personnel (sans créer de nouvelle dépense), puis ouvre
  // cette fiche pour corriger les heures et le taux horaire. retour=mois pour
  // revenir directement ici (Encaissements du mois) après correction.
  const migrerVersPersonnel = async (enc) => {
    try {
      const res = await api.post('/service-personnel/depuis-encaissement/' + enc.id);
      navigate('/personnel?date=' + res.data.date_service + '&service=' + res.data.id + '&retour=mois' + suffixeFiltre);
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la migration'));
    }
  };

  const encaissementsTries = [...encaissements].sort((a, b) => new Date(a.date_encaissement) - new Date(b.date_encaissement));

  // Ce qui s'affiche réellement dans la colonne "Table" : le nom de la table
  // pour une recette, le nom de l'article pour une dépense (ex: "Service
  // Elise"). Sert de base au filtre texte ci-dessous.
  const libelleTable = (enc) =>
    enc.depenses ? ((enc.lignes && enc.lignes[0] ? enc.lignes[0].article_nom : '') || '') : (enc.table_nom || '');

  const encaissementsAffiches = filtreTable.trim() === ''
    ? encaissementsTries
    : encaissementsTries.filter(enc => libelleTable(enc).toLowerCase().includes(filtreTable.trim().toLowerCase()));

  const servicesAMigrer = encaissementsTries.filter(enc => estServiceMigrable(enc) && !estDejaCorrige(enc)).length;
  const servicesCorriges = encaissementsTries.filter(enc => estServiceMigrable(enc) && estDejaCorrige(enc)).length;

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0, textTransform: 'capitalize' }}>
            {MOIS_NOMS[mois - 1]} {annee}
          </h2>
          <button className="btn" onClick={moisPrecedent}>−</button>
          <button className="btn" onClick={moisSuivant}>+</button>
          <button className="btn" onClick={moisActuel} style={{ color: '#888' }}>Ce mois</button>
          <input
            type="text"
            value={filtreTable}
            onChange={(e) => setFiltreTable(e.target.value)}
            placeholder="Filtrer sur Table (ex: Service)"
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, width: 220 }}
          />
          <span style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 14 }}>
            {(servicesAMigrer > 0 || servicesCorriges > 0) && (
              <span style={{ fontSize: 12, color: '#888' }}>
                Services : <span style={{ color: '#16a34a', fontWeight: 700 }}>{servicesCorriges} corrigés</span>
                {' · '}
                <span style={{ color: '#b45309', fontWeight: 700 }}>{servicesAMigrer} à migrer</span>
              </span>
            )}
            <span style={{ fontSize: 14, fontWeight: 700 }}>Total du mois : {totalMois.toFixed(2)} €</span>
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : encaissementsAffiches.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>
            {filtreTable.trim() === '' ? 'Aucun encaissement ce mois' : 'Aucun résultat pour ce filtre'}
          </div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}></th>
                  <th style={thCell()}></th>
                  <th style={thCell({ textAlign: 'center' })}>Ticket</th>
                  <th style={thCell()}>Réf</th>
                  <th style={thCell()}>Date</th>
                  <th style={thCell()}>Table</th>
                  <th style={thCell()}>Réservation</th>
                  <th style={thCell()}>Client</th>
                  <th style={thCell({ textAlign: 'right' })}>Nb pers.</th>
                  <th style={thCell({ textAlign: 'center' })}>Emp.</th>
                  <th style={thCell({ textAlign: 'center' })}>Dép.</th>
                  <th style={thCell({ textAlign: 'center' })}>Cash</th>
                  <th style={thCell({ textAlign: 'center' })}>Carte</th>
                  <th style={thCell({ textAlign: 'center' })}>Total</th>
                </tr>
              </thead>
              <tbody>
                {encaissementsAffiches.map(enc => (
                  <tr key={enc.id} style={estDejaCorrige(enc) ? { background: '#f0fdf4' } : undefined}>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ width: 20, height: 20, padding: 0, fontSize: 11 }}
                        title="Voir / corriger le détail"
                        onClick={() => ouvrirDetailOuService(enc)}
                      >⋯</button>
                    </td>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ width: 20, height: 20, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                        onClick={() => deleteEncaissement(enc.id)}
                      >✕</button>
                    </td>
                    <td style={tdCell({ textAlign: 'center', whiteSpace: 'nowrap' })}>
                      {!enc.depenses ? (
                        <>
                          <button className="btn" style={{ width: 20, height: 20, padding: 0, fontSize: 11, marginRight: 3 }} title="Réimprimer le ticket" onClick={() => reimprimerTicket(enc)}>🖨️</button>
                          <button className="btn" style={{ width: 20, height: 20, padding: 0, fontSize: 11 }} title="Ticket en PDF" onClick={() => telechargerPdfTicket(enc)}>📄</button>
                        </>
                      ) : estServiceMigrable(enc) ? (
                        estDejaCorrige(enc) ? (
                          <button
                            className="btn"
                            style={{ width: 20, height: 20, padding: 0, fontSize: 11, color: '#16a34a', borderColor: '#86efac' }}
                            title="Déjà repris dans Personnel — cliquer pour ouvrir sa fiche"
                            onClick={() => ouvrirDetailOuService(enc)}
                          >✔</button>
                        ) : (
                          <button
                            className="btn"
                            style={{ width: 20, height: 20, padding: 0, fontSize: 11, color: '#b45309', borderColor: '#fde68a' }}
                            title="Migrer (temporaire) vers le module Personnel"
                            onClick={() => migrerVersPersonnel(enc)}
                          >🔧</button>
                        )
                      ) : null}
                    </td>
                    <td style={tdCell({ color: '#aaa' })}>{enc.id}</td>
                    <td style={tdCell({ whiteSpace: 'nowrap', color: '#666' })}>
                      {new Date(enc.date_encaissement).toLocaleDateString('fr-BE')}
                    </td>
                    <td style={tdCell({ padding: '2px 4px' })}>
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
                    <td style={tdCell({ padding: '2px 4px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_cash}
                        onChange={(e) => majLocal(enc.id, 'montant_cash', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 4px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right' }}
                        value={enc.montant_carte}
                        onChange={(e) => majLocal(enc.id, 'montant_carte', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 4px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input" style={{ ...inputStyle, width: '100%', textAlign: 'right', fontWeight: 700 }}
                        value={enc.montant_total}
                        onChange={(e) => majLocal(enc.id, 'montant_total', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
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
  padding: '2px 4px',
  borderRadius: 5,
  border: '1px solid transparent',
  background: 'transparent',
  fontSize: 12,
  boxSizing: 'border-box',
};