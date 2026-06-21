import { useState, useEffect } from 'react';
import api from '../api/api';

function todayKey() {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

export default function HistoriqueVentes() {
  const [dateDebut, setDateDebut] = useState(todayKey());
  const [dateFin, setDateFin] = useState(todayKey());
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [ouverts, setOuverts] = useState({});

  const load = () => {
    setLoading(true);
    api.get('/encaissements/', { params: { date_debut: dateDebut, date_fin: dateFin } })
      .then(r => setEncaissements(r.data))
      .catch(() => setError('Impossible de charger l\'historique'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateDebut, dateFin]);

  const toggleOuvert = (id) => setOuverts(prev => ({ ...prev, [id]: !prev[id] }));

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

  // --- Édition de l'en-tête d'un encaissement (montants, table, serveur, remarque) ---
  const majEncaissementLocal = (encId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => e.id === encId ? { ...e, [champ]: valeur } : e));
  };

  const saveEncaissement = async (enc) => {
    try {
      await api.patch('/encaissements/' + enc.id, {
        table_nom: enc.table_nom,
        montant_carte: Number(enc.montant_carte),
        montant_cash: Number(enc.montant_cash),
        montant_total: Number(enc.montant_total),
        cash_analyse: Number(enc.cash_analyse || 0),
        serveur: enc.serveur,
        remarque: enc.remarque,
        nb_personnes: Number(enc.nb_personnes) || 1,
        emporte: !!enc.emporte,
      });
      showMsg('success', 'Encaissement mis à jour');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
    }
  };

  const deleteEncaissement = async (encId) => {
    if (!window.confirm('Supprimer cet encaissement et toutes ses lignes ? Cette action est irréversible.')) return;
    try {
      await api.delete('/encaissements/' + encId);
      showMsg('success', 'Encaissement supprimé');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  // --- Édition des lignes (articles) ---
  const majLigneLocal = (encId, ligneId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => {
      if (e.id !== encId) return e;
      return {
        ...e,
        lignes: e.lignes.map(l => l.id === ligneId ? { ...l, [champ]: valeur } : l),
      };
    }));
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
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour de la ligne'));
      load();
    }
  };

  const toggleVenteAnalysee = async (encId, ligne) => {
    const nouvelleValeur = !ligne.vente_analysee;
    majLigneLocal(encId, ligne.id, 'vente_analysee', nouvelleValeur);
    try {
      await api.patch('/encaissements/lignes/' + ligne.id, { vente_analysee: nouvelleValeur });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  const deleteLigne = async (encId, ligneId) => {
    if (!window.confirm('Supprimer cette ligne ?')) return;
    try {
      await api.delete('/encaissements/lignes/' + ligneId);
      setEncaissements(prev => prev.map(e => {
        if (e.id !== encId) return e;
        return { ...e, lignes: e.lignes.filter(l => l.id !== ligneId) };
      }));
      showMsg('success', 'Ligne supprimée');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const ajouterLigne = async (encId) => {
    try {
      const res = await api.post('/encaissements/' + encId + '/lignes', {
        article_nom: 'Nouvel article',
        quantite: 1,
        prix_vente: 0,
        tva: 0,
        vente_analysee: false,
      });
      setEncaissements(prev => prev.map(e => {
        if (e.id !== encId) return e;
        return { ...e, lignes: [...e.lignes, res.data] };
      }));
      showMsg('success', 'Ligne ajoutée');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de l\'ajout'));
    }
  };

  const totalPeriode = encaissements.reduce((sum, e) => sum + Number(e.montant_total || 0), 0);

  return (
    <div>
      <div className="content">

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
          <label style={{ fontSize: 13, color: '#888', fontWeight: 600 }}>Du</label>
          <input
            type="date"
            value={dateDebut}
            onChange={(e) => setDateDebut(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <label style={{ fontSize: 13, color: '#888', fontWeight: 600 }}>au</label>
          <input
            type="date"
            value={dateFin}
            onChange={(e) => setDateFin(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <span style={{ marginLeft: 'auto', fontSize: 13, color: '#888' }}>
            {encaissements.length} encaissement{encaissements.length !== 1 ? 's' : ''} · Total : <strong style={{ color: '#111' }}>{totalPeriode.toFixed(2)} €</strong>
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : encaissements.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun encaissement sur cette période</div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {encaissements.map(enc => {
              const isOpen = !!ouverts[enc.id];
              const totalLignes = (enc.lignes || []).reduce((s, l) => s + Number(l.prix_vente) * Number(l.quantite), 0);
              return (
                <div key={enc.id} style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'hidden' }}>

                  {/* En-tête de l'encaissement */}
                  <div
                    style={{
                      padding: '12px 16px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: 12,
                      flexWrap: 'wrap',
                      cursor: 'pointer',
                      background: '#fafaf8',
                    }}
                    onClick={() => toggleOuvert(enc.id)}
                  >
                    <span style={{ fontSize: 13, color: '#888', width: 16 }}>{isOpen ? '▼' : '▶'}</span>
                    <span style={{ fontSize: 13, fontWeight: 600, color: '#333', minWidth: 130 }}>
                      {new Date(enc.date_encaissement).toLocaleString('fr-BE', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })}
                    </span>
                    <span style={{ fontSize: 13, color: '#666', minWidth: 50 }}>{enc.table_nom || '—'}</span>
                    <span style={{ fontSize: 13, color: '#888' }}>{(enc.lignes || []).length} article{(enc.lignes || []).length !== 1 ? 's' : ''}</span>
                    <span style={{ fontSize: 14, fontWeight: 700, marginLeft: 'auto' }}>{Number(enc.montant_total).toFixed(2)} €</span>
                  </div>

                  {isOpen && (
                    <div style={{ padding: 16, borderTop: '1px solid #eee' }} onClick={(e) => e.stopPropagation()}>

                      {/* Champs éditables de l'encaissement */}
                      <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginBottom: 12 }}>
                        <Champ label="Table">
                          <input
                            style={inputStyle}
                            value={enc.table_nom || ''}
                            onChange={(e) => majEncaissementLocal(enc.id, 'table_nom', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                        <Champ label="Serveur">
                          <input
                            style={inputStyle}
                            value={enc.serveur || ''}
                            onChange={(e) => majEncaissementLocal(enc.id, 'serveur', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                        <Champ label="Montant carte">
                          <input
                            type="number" step="0.01"
                            style={inputStyle}
                            value={enc.montant_carte}
                            onChange={(e) => majEncaissementLocal(enc.id, 'montant_carte', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                        <Champ label="Montant cash">
                          <input
                            type="number" step="0.01"
                            style={inputStyle}
                            value={enc.montant_cash}
                            onChange={(e) => majEncaissementLocal(enc.id, 'montant_cash', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                        <Champ label="Cash analysé">
                          <input
                            type="number" step="0.01"
                            style={inputStyle}
                            value={enc.cash_analyse || 0}
                            onChange={(e) => majEncaissementLocal(enc.id, 'cash_analyse', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                        <Champ label="Montant total">
                          <input
                            type="number" step="0.01"
                            style={inputStyle}
                            value={enc.montant_total}
                            onChange={(e) => majEncaissementLocal(enc.id, 'montant_total', e.target.value)}
                            onBlur={() => saveEncaissement(enc)}
                          />
                        </Champ>
                      </div>

                      <Champ label="Remarque">
                        <input
                          style={{ ...inputStyle, width: '100%' }}
                          value={enc.remarque || ''}
                          onChange={(e) => majEncaissementLocal(enc.id, 'remarque', e.target.value)}
                          onBlur={() => saveEncaissement(enc)}
                        />
                      </Champ>

                      {/* Lignes (articles) */}
                      <div style={{ marginTop: 16, marginBottom: 8, fontSize: 12, color: '#888', fontWeight: 600, textTransform: 'uppercase' }}>
                        Articles vendus
                      </div>
                      <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                        {(enc.lignes || []).map(ligne => (
                          <div key={ligne.id} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 0', borderBottom: '1px solid #f5f5f0' }}>
                            <input
                              style={{ ...inputStyle, flex: 2 }}
                              value={ligne.article_nom}
                              onChange={(e) => majLigneLocal(enc.id, ligne.id, 'article_nom', e.target.value)}
                              onBlur={() => saveLigne(ligne)}
                            />
                            <input
                              type="number" step="0.01"
                              title="Quantité"
                              style={{ ...inputStyle, width: 60 }}
                              value={ligne.quantite}
                              onChange={(e) => majLigneLocal(enc.id, ligne.id, 'quantite', e.target.value)}
                              onBlur={() => saveLigne(ligne)}
                            />
                            <input
                              type="number" step="0.01"
                              title="Prix de vente"
                              style={{ ...inputStyle, width: 80 }}
                              value={ligne.prix_vente}
                              onChange={(e) => majLigneLocal(enc.id, ligne.id, 'prix_vente', e.target.value)}
                              onBlur={() => saveLigne(ligne)}
                            />
                            <input
                              type="number" step="0.01"
                              title="TVA (%)"
                              style={{ ...inputStyle, width: 60 }}
                              value={ligne.tva}
                              onChange={(e) => majLigneLocal(enc.id, ligne.id, 'tva', e.target.value)}
                              onBlur={() => saveLigne(ligne)}
                            />
                            <span style={{ fontSize: 12, color: '#888', width: 70, textAlign: 'right' }}>
                              {(Number(ligne.prix_vente) * Number(ligne.quantite)).toFixed(2)} €
                            </span>
                            <label style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 11, color: '#888', cursor: 'pointer' }} title="Vente analysée">
                              <input
                                type="checkbox"
                                checked={!!ligne.vente_analysee}
                                onChange={() => toggleVenteAnalysee(enc.id, ligne)}
                                style={{ width: 14, height: 14 }}
                              />
                              Analysée
                            </label>
                            <button
                              className="btn"
                              style={{ width: 26, height: 26, padding: 0, fontSize: 12, color: '#dc2626', borderColor: '#fca5a5' }}
                              onClick={() => deleteLigne(enc.id, ligne.id)}
                            >✕</button>
                          </div>
                        ))}
                      </div>

                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 12 }}>
                        <button className="btn" onClick={() => ajouterLigne(enc.id)}>+ Ajouter un article</button>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                          <span style={{ fontSize: 12, color: '#888' }}>Total lignes : {totalLignes.toFixed(2)} €</span>
                          <button
                            className="btn"
                            style={{ color: '#dc2626', borderColor: '#fca5a5' }}
                            onClick={() => deleteEncaissement(enc.id)}
                          >
                            Supprimer l'encaissement
                          </button>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

function Champ({ label, children }) {
  return (
    <div>
      <div style={{ fontSize: 11, color: '#888', marginBottom: 3 }}>{label}</div>
      {children}
    </div>
  );
}

const inputStyle = {
  padding: '6px 8px',
  borderRadius: 6,
  border: '1px solid #ddd',
  fontSize: 13,
  boxSizing: 'border-box',
};
