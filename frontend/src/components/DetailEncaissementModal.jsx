import { useState, useEffect } from 'react';
import api from '../api/api';

const inputStyle = {
  width: '100%',
  padding: '6px 8px',
  borderRadius: 6,
  border: '1px solid #ddd',
  fontSize: 13,
  boxSizing: 'border-box',
};

const labelStyle = { fontSize: 11, color: '#888', display: 'block', marginBottom: 4, fontWeight: 600 };

// Modale de correction complète d'un encaissement : montants + détail des lignes.
// Réutilisable depuis Encaissements.jsx (clic sur une ligne) et HistoriqueVentes.jsx
// (clic sur la réf encaissement). Tout y est éditable, comme dans les deux écrans
// d'origine, mais regroupé en un seul endroit pour corriger une vente complète
// sans devoir naviguer entre les deux écrans.
//
// Props :
// - encaissementId : id de l'encaissement à afficher/corriger
// - onClose() : appelé à la fermeture (croix ou après suppression)
// - onChanged() : appelé après toute modification réussie (pour que l'écran
//   parent puisse recharger sa liste)
export default function DetailEncaissementModal({ encaissementId, onClose, onChanged }) {
  const [enc, setEnc] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

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

  const load = () => {
    setLoading(true);
    api.get('/encaissements/' + encaissementId)
      .then(r => setEnc(r.data))
      .catch(() => setError('Impossible de charger cet encaissement'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [encaissementId]);

  const majLocal = (champ, valeur) => {
    setEnc(prev => ({ ...prev, [champ]: valeur }));
  };

  const majLigneLocal = (ligneId, champ, valeur) => {
    setEnc(prev => ({
      ...prev,
      lignes: prev.lignes.map(l => l.id === ligneId ? { ...l, [champ]: valeur } : l),
    }));
  };

  const saveEncaissement = async (champsSupplementaires = {}) => {
    try {
      await api.patch('/encaissements/' + enc.id, {
        table_nom: enc.table_nom,
        montant_carte: Number(enc.montant_carte),
        montant_cash: Number(enc.montant_cash),
        montant_total: Number(enc.montant_total),
        depenses: !!enc.depenses,
        emporte: !!enc.emporte,
        nb_personnes: Number(enc.nb_personnes) || 1,
        nom_reservation_archive: enc.nom_reservation_archive,
        ...champsSupplementaires,
      });
      showMsg('success', 'Encaissement mis à jour');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  // cash_analyse n'est plus saisi à la main : c'est toujours la somme des lignes
  // cochées "Analysée" (prix_vente × quantité). On la recalcule et on la
  // persiste côté backend chaque fois que l'état "analysée" d'une ligne change.
  const calculerCashAnalyse = (lignes) =>
    lignes.reduce((s, l) => s + (l.vente_analysee ? Number(l.prix_vente) * Number(l.quantite) : 0), 0);

  const syncCashAnalyse = async (lignes) => {
    const nouveauCashAnalyse = calculerCashAnalyse(lignes);
    majLocal('cash_analyse', nouveauCashAnalyse);
    try {
      await api.patch('/encaissements/' + enc.id, { cash_analyse: nouveauCashAnalyse });
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour du cash analysé'));
      load();
    }
  };

  const toggleBool = async (champ) => {
    const nouvelleValeur = !enc[champ];
    majLocal(champ, nouvelleValeur);
    try {
      await api.patch('/encaissements/' + enc.id, { [champ]: nouvelleValeur });
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  const saveLigne = async (ligne) => {
    try {
      await api.patch('/encaissements/lignes/' + ligne.id, {
        article_nom: ligne.article_nom,
        quantite: Number(ligne.quantite),
        prix_vente: Number(ligne.prix_vente),
        tva: Number(ligne.tva),
        vente_analysee: !!ligne.vente_analysee,
      });
      showMsg('success', 'Ligne mise à jour');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  const toggleAnalysee = async (ligne) => {
    const nouvelleValeur = !ligne.vente_analysee;
    const lignesMaj = enc.lignes.map(l => l.id === ligne.id ? { ...l, vente_analysee: nouvelleValeur } : l);
    setEnc(prev => ({ ...prev, lignes: lignesMaj }));
    try {
      await api.patch('/encaissements/lignes/' + ligne.id, { vente_analysee: nouvelleValeur });
      await syncCashAnalyse(lignesMaj);
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  // Clic sur l'en-tête "Analysée" : bascule TOUTES les lignes en une fois.
  // Si elles ne sont pas toutes cochées -> on coche tout. Si elles le sont déjà
  // toutes -> on décoche tout. Un seul recalcul de cash_analyse à la fin.
  const toggleToutesAnalysees = async () => {
    if (!enc.lignes || enc.lignes.length === 0) return;
    const toutesCochees = enc.lignes.every(l => l.vente_analysee);
    const nouvelleValeur = !toutesCochees;
    const lignesMaj = enc.lignes.map(l => ({ ...l, vente_analysee: nouvelleValeur }));
    setEnc(prev => ({ ...prev, lignes: lignesMaj }));
    try {
      await Promise.all(
        lignesMaj.map(l => api.patch('/encaissements/lignes/' + l.id, { vente_analysee: nouvelleValeur }))
      );
      await syncCashAnalyse(lignesMaj);
      showMsg('success', nouvelleValeur ? 'Toutes les lignes marquées analysées' : 'Toutes les lignes décochées');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour groupée'));
      load();
    }
  };

  const deleteLigne = async (ligneId) => {
    if (!window.confirm('Supprimer cette ligne ?')) return;
    try {
      await api.delete('/encaissements/lignes/' + ligneId);
      setEnc(prev => ({ ...prev, lignes: prev.lignes.filter(l => l.id !== ligneId) }));
      showMsg('success', 'Ligne supprimée');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const deleteEncaissement = async () => {
    if (!window.confirm('Supprimer cet encaissement et toutes ses lignes ? Action irréversible.')) return;
    try {
      await api.delete('/encaissements/' + enc.id);
      onChanged && onChanged();
      onClose();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const total = enc ? (enc.lignes || []).reduce((s, l) => s + Number(l.prix_vente) * Number(l.quantite), 0) : 0;

  return (
    <div
      style={{
        position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.45)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 200,
      }}
      onClick={onClose}
    >
      <div
        style={{ background: 'white', borderRadius: 12, padding: 24, width: 760, maxHeight: '85vh', overflowY: 'auto' }}
        onClick={(e) => e.stopPropagation()}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <div style={{ fontWeight: 700, fontSize: 17 }}>
            Encaissement #{encaissementId}
          </div>
          <button className="btn" onClick={onClose} style={{ width: 28, height: 28, padding: 0 }}>✕</button>
        </div>

        {msg && (
          <div style={{
            padding: '8px 14px', borderRadius: 8, marginBottom: 14, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
          }}>
            {msg.text}
          </div>
        )}
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : !enc ? null : (
          <>
            {/* Infos générales + montants */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 16 }}>
              <div>
                <label style={labelStyle}>Date</label>
                <div style={{ fontSize: 13, padding: '6px 0' }}>
                  {new Date(enc.date_encaissement).toLocaleString('fr-BE', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })}
                </div>
              </div>
              <div>
                <label style={labelStyle}>Table</label>
                <input style={inputStyle} value={enc.table_nom || ''} onChange={(e) => majLocal('table_nom', e.target.value)} onBlur={saveEncaissement} />
              </div>
              <div>
                <label style={labelStyle}>Réservation</label>
                <input style={inputStyle} value={enc.nom_reservation_archive || ''} onChange={(e) => majLocal('nom_reservation_archive', e.target.value)} onBlur={saveEncaissement} />
              </div>
              <div style={{ display: 'flex', alignItems: 'flex-end', gap: 16 }}>
                <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
                  <input type="checkbox" checked={!!enc.emporte} onChange={() => toggleBool('emporte')} />
                  Emporté
                </label>
                <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer', color: enc.depenses ? '#b91c1c' : '#333' }}>
                  <input type="checkbox" checked={!!enc.depenses} onChange={() => toggleBool('depenses')} />
                  Dépenses
                </label>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 20 }}>
              <div>
                <label style={labelStyle}>Cash</label>
                <input type="number" step="0.01" style={inputStyle} value={enc.montant_cash} onChange={(e) => majLocal('montant_cash', e.target.value)} onBlur={saveEncaissement} />
              </div>
              <div>
                <label style={labelStyle}>Carte</label>
                <input type="number" step="0.01" style={inputStyle} value={enc.montant_carte} onChange={(e) => majLocal('montant_carte', e.target.value)} onBlur={saveEncaissement} />
              </div>
              <div>
                <label style={labelStyle}>Total</label>
                <input type="number" step="0.01" style={{ ...inputStyle, fontWeight: 700 }} value={enc.montant_total} onChange={(e) => majLocal('montant_total', e.target.value)} onBlur={saveEncaissement} />
              </div>
              <div>
                <label style={labelStyle}>Cash analysé</label>
                <div style={{
                  ...inputStyle, display: 'flex', alignItems: 'center',
                  color: Number(enc.cash_analyse) > 0 ? '#16a34a' : '#888',
                  fontWeight: 600, background: '#fafaf8', cursor: 'default',
                }}>
                  {Number(enc.cash_analyse || 0).toFixed(2)} €
                </div>
              </div>
            </div>

            {/* Détail des lignes (= Historique) */}
            <div style={{ fontSize: 12, color: '#888', fontWeight: 600, marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.4 }}>
              Détail des articles
            </div>
            <div style={{ border: '1px solid #e5e5e0', borderRadius: 8, overflow: 'hidden', marginBottom: 16 }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
                <thead>
                  <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                    <th style={{ padding: '8px 10px' }}>Article</th>
                    <th style={{ padding: '8px 10px', textAlign: 'right' }}>Qté</th>
                    <th style={{ padding: '8px 10px', textAlign: 'right' }}>Px vente</th>
                    <th style={{ padding: '8px 10px', textAlign: 'right' }}>TVA %</th>
                    <th style={{ padding: '8px 10px', textAlign: 'right' }}>Prix payé</th>
                    <th
                      style={{ padding: '8px 10px', textAlign: 'center', cursor: 'pointer', userSelect: 'none' }}
                      onClick={toggleToutesAnalysees}
                      title="Cliquer pour tout cocher / décocher"
                    >
                      Analysée
                    </th>
                    <th style={{ padding: '8px 10px' }}></th>
                  </tr>
                </thead>
                <tbody>
                  {(enc.lignes || []).map(ligne => (
                    <tr key={ligne.id} style={{ borderTop: '1px solid #f0f0ee' }}>
                      <td style={{ padding: '4px 6px' }}>
                        <input
                          style={inputStyle}
                          value={ligne.article_nom}
                          onChange={(e) => majLigneLocal(ligne.id, 'article_nom', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '4px 6px' }}>
                        <input
                          type="number" step="0.01"
                          style={{ ...inputStyle, width: 55, textAlign: 'right' }}
                          value={ligne.quantite}
                          onChange={(e) => majLigneLocal(ligne.id, 'quantite', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '4px 6px' }}>
                        <input
                          type="number" step="0.01"
                          style={{ ...inputStyle, width: 75, textAlign: 'right' }}
                          value={ligne.prix_vente}
                          onChange={(e) => majLigneLocal(ligne.id, 'prix_vente', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '4px 6px' }}>
                        <input
                          type="number" step="1"
                          style={{ ...inputStyle, width: 55, textAlign: 'right' }}
                          value={Math.round(ligne.tva)}
                          onChange={(e) => majLigneLocal(ligne.id, 'tva', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '6px 10px', textAlign: 'right', fontWeight: 600 }}>
                        {(Number(ligne.prix_vente) * Number(ligne.quantite)).toFixed(2)} €
                      </td>
                      <td style={{ padding: '6px 10px', textAlign: 'center' }}>
                        <input
                          type="checkbox"
                          checked={!!ligne.vente_analysee}
                          onChange={() => toggleAnalysee(ligne)}
                          style={{ width: 15, height: 15, cursor: 'pointer' }}
                        />
                      </td>
                      <td style={{ padding: '6px 10px' }}>
                        <button
                          className="btn"
                          style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                          onClick={() => deleteLigne(ligne.id)}
                        >✕</button>
                      </td>
                    </tr>
                  ))}
                  {(!enc.lignes || enc.lignes.length === 0) && (
                    <tr>
                      <td colSpan={7} style={{ padding: 16, textAlign: 'center', color: '#888' }}>Aucune ligne</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div style={{ fontSize: 13, color: '#888' }}>
                Total des lignes : <strong style={{ color: '#111' }}>{total.toFixed(2)} €</strong>
              </div>
              <button
                className="btn"
                style={{ color: '#dc2626', borderColor: '#fca5a5' }}
                onClick={deleteEncaissement}
              >
                Supprimer tout l'encaissement
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
