import { useState, useEffect, useMemo } from 'react';
import api from '../api/api';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

export default function HistoriqueVentes() {
  const [modePlage, setModePlage] = useState(false);
  const [dateUnique, setDateUnique] = useState(todayKey());
  const [dateDebut, setDateDebut] = useState(todayKey());
  const [dateFin, setDateFin] = useState(todayKey());
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  const effectiveDebut = modePlage ? dateDebut : dateUnique;
  const effectiveFin = modePlage ? dateFin : dateUnique;

  const load = () => {
    setLoading(true);
    api.get('/encaissements/', { params: { date_debut: effectiveDebut, date_fin: effectiveFin } })
      .then(r => setEncaissements(r.data))
      .catch(() => setError('Impossible de charger l\'historique'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [effectiveDebut, effectiveFin]);

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

  // Déplie les encaissements + leurs lignes en une liste plate, une entrée par article vendu,
  // triée par date d'encaissement puis par id de ligne (ordre d'ajout).
  const lignesAPlat = useMemo(() => {
    const rows = [];
    encaissements.forEach(enc => {
      (enc.lignes || []).forEach(ligne => {
        rows.push({ enc, ligne });
      });
    });
    rows.sort((a, b) => {
      const dA = new Date(a.enc.date_encaissement).getTime();
      const dB = new Date(b.enc.date_encaissement).getTime();
      if (dA !== dB) return dA - dB;
      return a.ligne.id - b.ligne.id;
    });
    return rows;
  }, [encaissements]);

  const majLigneLocal = (encId, ligneId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => {
      if (e.id !== encId) return e;
      return { ...e, lignes: e.lignes.map(l => l.id === ligneId ? { ...l, [champ]: valeur } : l) };
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
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  const toggleAnalysee = async (encId, ligne) => {
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

  const totalPeriode = lignesAPlat.reduce((s, { ligne }) => s + Number(ligne.prix_vente) * Number(ligne.quantite), 0);

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          {!modePlage ? (
            <>
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
              <input
                type="date"
                value={dateUnique}
                onChange={(e) => setDateUnique(e.target.value)}
                style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
            </>
          ) : (
            <>
              <label style={{ fontSize: 13, color: '#888' }}>Du</label>
              <input
                type="date"
                value={dateDebut}
                onChange={(e) => setDateDebut(e.target.value)}
                style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <label style={{ fontSize: 13, color: '#888' }}>au</label>
              <input
                type="date"
                value={dateFin}
                onChange={(e) => setDateFin(e.target.value)}
                style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
            </>
          )}
          <button className="btn" onClick={() => setModePlage(m => !m)} style={{ color: '#888' }}>
            {modePlage ? 'Revenir à un jour précis' : 'Filtrer sur une plage de dates'}
          </button>
          <span style={{ marginLeft: 'auto', fontSize: 13, color: '#888' }}>
            {lignesAPlat.length} ligne{lignesAPlat.length !== 1 ? 's' : ''} · Total : <strong style={{ color: '#111' }}>{totalPeriode.toFixed(2)} €</strong>
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : lignesAPlat.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucune vente sur cette période</div>
        ) : (
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'hidden' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={{ padding: '8px 10px' }}>Date</th>
                  <th style={{ padding: '8px 10px' }}>Article</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Qté</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Px vente</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>TVA %</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Prix payé</th>
                  <th style={{ padding: '8px 10px', textAlign: 'center' }}>Analysée</th>
                  <th style={{ padding: '8px 10px' }}>Réf enc.</th>
                  <th style={{ padding: '8px 10px' }}>Ticket</th>
                  <th style={{ padding: '8px 10px' }}>Réservation</th>
                  <th style={{ padding: '8px 10px' }}></th>
                </tr>
              </thead>
              <tbody>
                {lignesAPlat.map(({ enc, ligne }) => (
                  <tr key={ligne.id} style={{ borderTop: '1px solid #f0f0ee' }}>
                    <td style={{ padding: '6px 10px', whiteSpace: 'nowrap', color: '#666' }}>
                      {new Date(enc.date_encaissement).toLocaleString('fr-BE', { day: '2-digit', month: '2-digit', year: '2-digit', hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        style={inputStyle}
                        value={ligne.article_nom}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'article_nom', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 60, textAlign: 'right' }}
                        value={ligne.quantite}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'quantite', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 80, textAlign: 'right' }}
                        value={ligne.prix_vente}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'prix_vente', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="1"
                        style={{ ...inputStyle, width: 55, textAlign: 'right' }}
                        value={Math.round(ligne.tva)}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'tva', e.target.value)}
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
                        onChange={() => toggleAnalysee(enc.id, ligne)}
                        style={{ width: 15, height: 15, cursor: 'pointer' }}
                      />
                    </td>
                    <td style={{ padding: '6px 10px', color: '#aaa' }}>{enc.id}</td>
                    <td style={{ padding: '6px 10px', color: '#666' }}>{enc.table_nom || '—'}</td>
                    <td style={{ padding: '6px 10px', color: '#666' }}>{enc.nom_reservation_archive || '—'}</td>
                    <td style={{ padding: '6px 10px' }}>
                      <button
                        className="btn"
                        style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                        onClick={() => deleteLigne(enc.id, ligne.id)}
                      >✕</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '4px 6px',
  borderRadius: 5,
  border: '1px solid #ddd',
  fontSize: 12,
  boxSizing: 'border-box',
};
