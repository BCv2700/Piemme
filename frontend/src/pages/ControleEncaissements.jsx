import { useState, useEffect, useMemo, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/api';
import DetailEncaissementModal from '../components/DetailEncaissementModal';

const BORDURE = '1px solid #e5e5e0';

function dateKey(annee, mois, jour) {
  return annee + '-' + String(mois).padStart(2, '0') + '-' + String(jour).padStart(2, '0');
}

export default function ControleEncaissements() {
  const navigate = useNavigate();
  const [annee, setAnnee] = useState(new Date().getFullYear());
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [detailOuvert, setDetailOuvert] = useState(null);
  // Confirmation 2 taps pour la suppression
  const [confirmId, setConfirmId] = useState(null);
  const confirmTimer = useRef(null);

  const load = () => {
    setLoading(true);
    setError('');
    api.get('/encaissements/', {
      params: { date_debut: dateKey(annee, 1, 1), date_fin: dateKey(annee, 12, 31) },
    })
      .then(r => setEncaissements(r.data))
      .catch(() => setError('Impossible de charger les encaissements'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [annee]);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  // ----- Détection des anomalies -----
  const anomalies = useMemo(() => {
    const liste = [];
    encaissements.forEach(enc => {
      const lignes = enc.lignes || [];
      const total = Number(enc.montant_total || 0);

      // 1. Encaissement sans aucune ligne
      if (lignes.length === 0) {
        liste.push({ enc, type: 'Sans ligne de détail', gravite: 'haute' });
        return; // les autres contrôles n'ont pas de sens sans lignes
      }

      // 2. Écart entre montant_total et somme des lignes (tolérance 2 cents)
      const sommeLignes = lignes.reduce(
        (s, l) => s + Number(l.prix_vente) * Number(l.quantite), 0
      );
      if (Math.abs(sommeLignes - total) > 0.02) {
        liste.push({
          enc,
          type: 'Écart Total / lignes',
          detail: 'Total ' + total.toFixed(2) + ' € vs lignes ' + sommeLignes.toFixed(2) + ' €',
          gravite: 'haute',
        });
      }

      // 3. Ligne(s) avec nom d'article vide
      const nbVides = lignes.filter(l => !(l.article_nom || '').trim()).length;
      if (nbVides > 0) {
        liste.push({
          enc,
          type: 'Nom d\'article vide',
          detail: nbVides + ' ligne' + (nbVides > 1 ? 's' : ''),
          gravite: 'moyenne',
        });
      }

      // 4. Dépense avec montant positif
      if (enc.depenses && total > 0) {
        liste.push({ enc, type: 'Dépense avec montant positif', gravite: 'moyenne' });
      }
    });

    // Tri par date décroissante (les plus récentes d'abord)
    liste.sort((a, b) =>
      new Date(b.enc.date_encaissement).getTime() - new Date(a.enc.date_encaissement).getTime()
    );
    return liste;
  }, [encaissements]);

  // ----- Suppression avec confirmation 2 taps -----
  const clicSupprimer = async (encId) => {
    if (confirmId !== encId) {
      setConfirmId(encId);
      clearTimeout(confirmTimer.current);
      confirmTimer.current = setTimeout(() => setConfirmId(null), 4000);
      return;
    }
    clearTimeout(confirmTimer.current);
    setConfirmId(null);
    try {
      await api.delete('/encaissements/' + encId);
      showMsg('success', 'Encaissement #' + encId + ' supprimé');
      load();
    } catch (e) {
      showMsg('error', 'Erreur lors de la suppression');
    }
  };

  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, fontSize: 12, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, fontSize: 12, ...extra });

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
          <button className="btn" onClick={() => setAnnee(a => a - 1)}>−</button>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>🔍 Contrôle {annee}</h2>
          <button className="btn" onClick={() => setAnnee(a => a + 1)}>+</button>
          <button className="btn" onClick={() => navigate(-1)} style={{ marginLeft: 16, fontSize: 12, color: '#888' }}>
            ← Retour
          </button>
          {!loading && (
            <span style={{ marginLeft: 'auto', fontSize: 13, color: anomalies.length ? '#b91c1c' : '#16a34a', fontWeight: 600 }}>
              {anomalies.length === 0
                ? '✓ Aucune anomalie détectée'
                : anomalies.length + ' anomalie' + (anomalies.length > 1 ? 's' : '') + ' détectée' + (anomalies.length > 1 ? 's' : '')}
            </span>
          )}
        </div>

        <div style={{ fontSize: 12, color: '#888', marginBottom: 16 }}>
          Contrôles effectués : encaissement sans ligne de détail · écart entre le Total et la somme des lignes ·
          nom d'article vide · dépense avec montant positif.
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Analyse en cours...</div>
        ) : anomalies.length === 0 ? (
          <div style={{ color: '#16a34a', textAlign: 'center', padding: '40px 0', fontSize: 14 }}>
            ✓ Tous les encaissements de {annee} sont cohérents
          </div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}>Réf</th>
                  <th style={thCell()}>Date</th>
                  <th style={thCell()}>Table</th>
                  <th style={thCell({ textAlign: 'right' })}>Total</th>
                  <th style={thCell()}>Problème</th>
                  <th style={thCell()}>Détail</th>
                  <th style={thCell({ textAlign: 'center' })}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {anomalies.map((a, i) => (
                  <tr key={a.enc.id + '-' + a.type + '-' + i} style={{ background: a.gravite === 'haute' ? '#fef2f2' : '#fffbeb' }}>
                    <td
                      style={tdCell({ color: '#2563eb', cursor: 'pointer', textDecoration: 'underline dotted', fontWeight: 600 })}
                      onClick={() => setDetailOuvert(a.enc.id)}
                      title="Ouvrir le détail"
                    >
                      {a.enc.id}
                    </td>
                    <td style={tdCell({ whiteSpace: 'nowrap', color: '#666' })}>
                      {new Date(a.enc.date_encaissement).toLocaleString('fr-BE', { day: '2-digit', month: '2-digit', year: '2-digit', hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={tdCell({ color: '#666' })}>
                      {a.enc.table_nom || '—'}{a.enc.depenses ? ' 💰' : ''}
                    </td>
                    <td style={tdCell({ textAlign: 'right', fontWeight: 600 })}>
                      {Number(a.enc.montant_total || 0).toFixed(2)} €
                    </td>
                    <td style={tdCell({ fontWeight: 600, color: a.gravite === 'haute' ? '#b91c1c' : '#b45309' })}>
                      {a.type}
                    </td>
                    <td style={tdCell({ color: '#666' })}>{a.detail || ''}</td>
                    <td style={tdCell({ textAlign: 'center', whiteSpace: 'nowrap' })}>
                      <button
                        className="btn"
                        style={{ fontSize: 11, marginRight: 6, minHeight: 36 }}
                        onClick={() => setDetailOuvert(a.enc.id)}
                      >
                        Ouvrir
                      </button>
                      <button
                        className="btn"
                        style={{
                          fontSize: 11, minHeight: 36,
                          color: confirmId === a.enc.id ? 'white' : '#dc2626',
                          background: confirmId === a.enc.id ? '#dc2626' : undefined,
                          borderColor: '#fca5a5',
                        }}
                        onClick={() => clicSupprimer(a.enc.id)}
                      >
                        {confirmId === a.enc.id ? 'Sûr ?' : 'Supprimer'}
                      </button>
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