import { useState, useEffect } from 'react';
import api from '../api/api';
import SelecteurClient from './SelecteurClient';

const inputStyle = {
  width: '100%',
  padding: '6px 8px',
  borderRadius: 6,
  border: '1px solid #ddd',
  fontSize: 13,
  boxSizing: 'border-box',
};

const cellInputStyle = {
  width: '100%',
  padding: '4px 6px',
  borderRadius: 5,
  border: '1px solid transparent',
  background: 'transparent',
  fontSize: 12,
  boxSizing: 'border-box',
};

const BORDURE = '1px solid #e5e5e0';
const labelStyle = { fontSize: 11, color: '#888', display: 'block', marginBottom: 4, fontWeight: 600 };

function decomposerDateHeure(dateIso) {
  const d = new Date(dateIso);
  const date = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  const heure = String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
  return { date, heure };
}

export default function DetailEncaissementModal({ encaissementId, onClose, onChanged }) {
  const [enc, setEnc] = useState(null);
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [dateSaisie, setDateSaisie] = useState('');
  const [heureSaisie, setHeureSaisie] = useState('');

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
    Promise.all([
      api.get('/encaissements/' + encaissementId),
      api.get('/clients/'),
    ])
      .then(([encRes, clientsRes]) => {
        setEnc(encRes.data);
        setClients(clientsRes.data);
        const { date, heure } = decomposerDateHeure(encRes.data.date_encaissement);
        setDateSaisie(date);
        setHeureSaisie(heure);
      })
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

  // Sauvegarde les champs généraux de l'encaissement (table, réservation, montants).
  // N'accepte jamais d'argument positionnel venant d'un événement DOM : on l'appelle
  // toujours via onBlur={() => saveEncaissement()}, jamais onBlur={saveEncaissement}.
  const saveEncaissement = async () => {
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
      });
      showMsg('success', 'Encaissement mis à jour');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  // Changement de client, enregistré immédiatement (pas besoin d'onBlur, comme
  // les cases à cocher Emporté/Dépenses).
  const changerClient = async (nouveauClientId) => {
    majLocal('client_id', nouveauClientId);
    try {
      await api.patch('/encaissements/' + enc.id, { client_id: nouveauClientId });
      showMsg('success', 'Client mis à jour');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors du changement de client'));
      load();
    }
  };

  const saveDateHeure = async (nouvelleDate, nouvelleHeure) => {
    if (!nouvelleDate || !nouvelleHeure) return;
    const dateEncaissement = nouvelleDate + 'T' + nouvelleHeure + ':00';
    majLocal('date_encaissement', dateEncaissement);
    try {
      await api.patch('/encaissements/' + enc.id, { date_encaissement: dateEncaissement });
      showMsg('success', 'Date mise à jour');
      onChanged && onChanged();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour de la date'));
      load();
    }
  };

  const calculerCashAnalyse = (lignes, montantCash) => {
    const sommeAnalysee = lignes.reduce(
      (s, l) => s + (l.vente_analysee ? Number(l.prix_vente) * Number(l.quantite) : 0),
      0
    );
    const cash = Number(montantCash) || 0;
    return Math.max(0, Math.min(sommeAnalysee, cash));
  };

  const syncCashAnalyse = async (lignes) => {
    const nouveauCashAnalyse = calculerCashAnalyse(lignes, enc.montant_cash);
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
        <style>{`
          .cell-input:focus {
            outline: none;
            border: 1px solid #bbb !important;
            background: #fff !important;
          }
        `}</style>
        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16 }}>
          <div style={{ fontWeight: 700, fontSize: 17 }}>
            Encaissement #{encaissementId}
          </div>
          {enc && (
            <SelecteurClient
              clients={clients}
              clientId={enc.client_id ?? null}
              onChange={changerClient}
              style={{ minWidth: 180 }}
            />
          )}
          <button className="btn" onClick={onClose} style={{ width: 28, height: 28, padding: 0, marginLeft: 'auto' }}>✕</button>
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
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 8 }}>
              <div></div>
              <div></div>
              <div>
                <button
                  className="btn"
                  style={{ color: '#dc2626', borderColor: '#fca5a5', fontSize: 12 }}
                  onClick={deleteEncaissement}
                >
                  Supprimer tout l'encaissement
                </button>
              </div>
              <div></div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 16 }}>
              <div>
                <label style={labelStyle}>Date</label>
                <input
                  type="date"
                  style={inputStyle}
                  value={dateSaisie}
                  onChange={(e) => setDateSaisie(e.target.value)}
                  onBlur={() => saveDateHeure(dateSaisie, heureSaisie)}
                />
              </div>
              <div>
                <label style={labelStyle}>Heure</label>
                <input
                  type="time"
                  style={inputStyle}
                  value={heureSaisie}
                  onChange={(e) => setHeureSaisie(e.target.value)}
                  onBlur={() => saveDateHeure(dateSaisie, heureSaisie)}
                />
              </div>
              <div>
                <label style={labelStyle}>Table</label>
                <input style={inputStyle} value={enc.table_nom || ''} onChange={(e) => majLocal('table_nom', e.target.value)} onBlur={() => saveEncaissement()} />
              </div>
              <div>
                <label style={labelStyle}>Réservation</label>
                <input style={inputStyle} value={enc.nom_reservation_archive || ''} onChange={(e) => majLocal('nom_reservation_archive', e.target.value)} onBlur={() => saveEncaissement()} />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
                <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
                  <input type="checkbox" checked={!!enc.emporte} onChange={() => toggleBool('emporte')} />
                  Emporté
                </label>
                <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer', color: enc.depenses ? '#b91c1c' : '#333' }}>
                  <input type="checkbox" checked={!!enc.depenses} onChange={() => toggleBool('depenses')} />
                  Dépenses
                </label>
              </div>
              <div>
                <label style={labelStyle}>Nb personnes</label>
                <input
                  type="number" min="1" style={inputStyle}
                  value={enc.nb_personnes ?? 1}
                  onChange={(e) => majLocal('nb_personnes', e.target.value)}
                  onBlur={() => saveEncaissement()}
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 20 }}>
              <div>
                <label style={labelStyle}>Cash</label>
                <input type="number" step="0.01" style={inputStyle} value={enc.montant_cash} onChange={(e) => majLocal('montant_cash', e.target.value)} onBlur={() => saveEncaissement()} />
              </div>
              <div>
                <label style={labelStyle}>Carte</label>
                <input type="number" step="0.01" style={inputStyle} value={enc.montant_carte} onChange={(e) => majLocal('montant_carte', e.target.value)} onBlur={() => saveEncaissement()} />
              </div>
              <div>
                <label style={labelStyle}>Total</label>
                <input type="number" step="0.01" style={{ ...inputStyle, fontWeight: 700 }} value={enc.montant_total} onChange={(e) => majLocal('montant_total', e.target.value)} onBlur={() => saveEncaissement()} />
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

            <div style={{ fontSize: 12, color: '#888', fontWeight: 600, marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.4 }}>
              Détail des articles
            </div>
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 6, fontSize: 13, color: '#888' }}>
              Total des lignes : <strong style={{ marginLeft: 4, color: '#111' }}>{total.toFixed(2)} €</strong>
            </div>
            <div style={{ border: BORDURE, borderRadius: 8, overflow: 'hidden', marginBottom: 16 }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, tableLayout: 'fixed' }}>
                <colgroup>
                  <col style={{ width: '38%' }} />
                  <col style={{ width: '7%' }} />
                  <col style={{ width: '15%' }} />
                  <col style={{ width: '7%' }} />
                  <col style={{ width: '15%' }} />
                  <col style={{ width: '10%' }} />
                  <col style={{ width: '8%' }} />
                </colgroup>
                <thead>
                  <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                    <th style={{ padding: '6px 10px', border: BORDURE }}>Article</th>
                    <th style={{ padding: '6px 10px', border: BORDURE, textAlign: 'center' }}>Qté</th>
                    <th style={{ padding: '6px 10px', border: BORDURE, textAlign: 'center' }}>Px vente</th>
                    <th style={{ padding: '6px 10px', border: BORDURE, textAlign: 'center' }}>TVA %</th>
                    <th style={{ padding: '6px 10px', border: BORDURE, textAlign: 'right' }}>Prix payé</th>
                    <th
                      style={{ padding: '6px 10px', border: BORDURE, textAlign: 'center', cursor: 'pointer', userSelect: 'none' }}
                      onClick={toggleToutesAnalysees}
                      title="Cliquer pour tout cocher / décocher"
                    >
                      Analysée
                    </th>
                    <th style={{ padding: '6px 10px', border: BORDURE }}></th>
                  </tr>
                </thead>
                <tbody>
                  {(enc.lignes || []).map(ligne => (
                    <tr key={ligne.id}>
                      <td style={{ padding: '2px 6px', border: BORDURE }}>
                        <input
                          className="cell-input"
                          style={cellInputStyle}
                          value={ligne.article_nom}
                          onChange={(e) => majLigneLocal(ligne.id, 'article_nom', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '2px 6px', border: BORDURE }}>
                        <input
                          type="number" step="0.01"
                          className="cell-input"
                          style={{ ...cellInputStyle, textAlign: 'right' }}
                          value={ligne.quantite}
                          onChange={(e) => majLigneLocal(ligne.id, 'quantite', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '2px 6px', border: BORDURE }}>
                        <input
                          type="number" step="0.01"
                          className="cell-input"
                          style={{ ...cellInputStyle, textAlign: 'right' }}
                          value={ligne.prix_vente}
                          onChange={(e) => majLigneLocal(ligne.id, 'prix_vente', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '2px 6px', border: BORDURE }}>
                        <input
                          type="number" step="1"
                          className="cell-input"
                          style={{ ...cellInputStyle, textAlign: 'right' }}
                          value={Math.round(ligne.tva)}
                          onChange={(e) => majLigneLocal(ligne.id, 'tva', e.target.value)}
                          onBlur={() => saveLigne(ligne)}
                        />
                      </td>
                      <td style={{ padding: '4px 10px', border: BORDURE, textAlign: 'right', fontWeight: 600 }}>
                        {(Number(ligne.prix_vente) * Number(ligne.quantite)).toFixed(2)} €
                      </td>
                      <td style={{ padding: '4px 10px', border: BORDURE, textAlign: 'center' }}>
                        <input
                          type="checkbox"
                          checked={!!ligne.vente_analysee}
                          onChange={() => toggleAnalysee(ligne)}
                          style={{ width: 15, height: 15, cursor: 'pointer' }}
                        />
                      </td>
                      <td style={{ padding: '4px 10px', border: BORDURE }}>
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

          </>
        )}
      </div>
    </div>
  );
}