import { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/api';

const MOIS_ABR = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
const BORDURE = '1px solid #e5e5e0';

function pad2(n) { return String(n).padStart(2, '0'); }
function joursDansMois(annee, mois) { return new Date(annee, mois, 0).getDate(); }

const thCell = (extra = {}) => ({ padding: '5px 8px', border: BORDURE, ...extra });
const tdCell = (extra = {}) => ({ padding: '3px 8px', border: BORDURE, ...extra });

export default function Frequentation() {
  const navigate = useNavigate();
  const [annee, setAnnee] = useState(new Date().getFullYear());
  const [donnees, setDonnees] = useState([]); // [{ jour, mois, total }]
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    setLoading(true);
    setError('');
    api.get('/statistiques/frequentation/' + annee)
      .then(res => setDonnees(res.data))
      .catch(() => setError('Impossible de charger la fréquentation'))
      .finally(() => setLoading(false));
  }, [annee]);

  const grille = useMemo(() => {
    const g = {};
    for (let j = 1; j <= 31; j++) {
      g[j] = {};
      for (let m = 1; m <= 12; m++) g[j][m] = 0;
    }
    donnees.forEach(d => { g[d.jour][d.mois] = d.total; });
    return g;
  }, [donnees]);

  const totalParMois = useMemo(() => {
    const t = {};
    for (let m = 1; m <= 12; m++) {
      t[m] = 0;
      for (let j = 1; j <= 31; j++) t[m] += grille[j][m];
    }
    return t;
  }, [grille]);

  const totalParJour = useMemo(() => {
    const t = {};
    for (let j = 1; j <= 31; j++) {
      t[j] = 0;
      for (let m = 1; m <= 12; m++) t[j] += grille[j][m];
    }
    return t;
  }, [grille]);

  const grandTotal = useMemo(
    () => Object.values(totalParMois).reduce((a, b) => a + b, 0),
    [totalParMois]
  );

  const ouvrirJour = (jour, mois) => {
    if (grille[jour][mois] === 0) return;
    const dateKey = annee + '-' + pad2(mois) + '-' + pad2(jour);
    navigate('/encaissements?date=' + dateKey);
  };

  return (
    <div>
      <div className="content">
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
          <button className="btn" onClick={() => setAnnee(a => a - 1)}>−</button>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>
            Fréquentation {annee}
          </h2>
          <button className="btn" onClick={() => setAnnee(a => a + 1)}>+</button>
          <span style={{ fontSize: 13, color: '#888', marginLeft: 8 }}>
            Nombre de personnes — sur place uniquement, cliquez sur un jour pour l'ouvrir
          </span>
        </div>

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ borderCollapse: 'collapse', fontSize: 12, minWidth: 1100 }}>
              <thead>
                <tr style={{ background: '#fafaf8' }}>
                  <th style={thCell({ textAlign: 'left' })}>Jour</th>
                  {MOIS_ABR.map((nom, i) => (
                    <th key={i} style={thCell({ textAlign: 'right' })}>{nom}</th>
                  ))}
                  <th style={thCell({ textAlign: 'right', fontWeight: 700 })}>Total</th>
                </tr>
              </thead>
              <tbody>
                {Array.from({ length: 31 }, (_, i) => i + 1).map(jour => (
                  <tr key={jour}>
                    <td style={tdCell({ textAlign: 'left', fontWeight: 600 })}>{pad2(jour)}</td>
                    {MOIS_ABR.map((_, i) => {
                      const mois = i + 1;
                      const existe = jour <= joursDansMois(annee, mois);
                      const valeur = grille[jour][mois];
                      if (!existe) return <td key={mois} style={tdCell({ background: '#f5f5f3' })}></td>;
                      return (
                        <td
                          key={mois}
                          onClick={() => ouvrirJour(jour, mois)}
                          style={tdCell({
                            textAlign: 'right',
                            cursor: valeur !== 0 ? 'pointer' : 'default',
                            color: valeur !== 0 ? '#111' : '#ccc',
                          })}
                        >
                          {valeur !== 0 ? valeur : '—'}
                        </td>
                      );
                    })}
                    <td style={tdCell({ textAlign: 'right', fontWeight: 700 })}>{totalParJour[jour]}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                  <td style={tdCell({ textAlign: 'left' })}>Total</td>
                  {MOIS_ABR.map((_, i) => (
                    <td key={i} style={tdCell({ textAlign: 'right' })}>{totalParMois[i + 1]}</td>
                  ))}
                  <td style={tdCell({ textAlign: 'right' })}>{grandTotal}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}