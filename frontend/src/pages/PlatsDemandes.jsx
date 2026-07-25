import { useState, useEffect, useMemo } from 'react';
import api from '../api/api';

const MOIS_ABR = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
const BORDURE = '1px solid #e5e5e0';

const CATEGORIES = [
  { label: 'Tout', codes: null },
  { label: 'Nourriture', codes: [7002] },
  { label: 'Boissons', codes: [7001, 7003, 7004] },
  { label: 'Divers', codes: [7005] },
  { label: 'Non classé', codes: [null] },
];

const thCell = (extra = {}) => ({ padding: '5px 8px', border: BORDURE, ...extra });
const tdCell = (extra = {}) => ({ padding: '3px 8px', border: BORDURE, ...extra });
const fmtQte = (n) => (Number(n) % 1 === 0 ? Number(n).toString() : Number(n).toFixed(2));

export default function PlatsDemandes() {
  const [annee, setAnnee] = useState(new Date().getFullYear());
  const [donnees, setDonnees] = useState([]);
  const [recherche, setRecherche] = useState('');
  const [categorie, setCategorie] = useState('Tout');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    setLoading(true);
    setError('');
    api.get('/statistiques/plats-demandes/' + annee)
      .then(res => setDonnees(res.data))
      .catch(() => setError('Impossible de charger les plats les plus demandés'))
      .finally(() => setLoading(false));
  }, [annee]);

  const donneesFiltrees = useMemo(() => {
    let result = donnees;
    const cat = CATEGORIES.find(c => c.label === categorie);
    if (cat && cat.codes !== null) {
      result = result.filter(d => {
        if (cat.codes.includes(null)) return d.code_vente == null;
        return cat.codes.includes(d.code_vente);
      });
    }
    if (recherche.trim()) {
      const r = recherche.toLowerCase();
      result = result.filter(d => d.nom.toLowerCase().includes(r));
    }
    return result;
  }, [donnees, recherche, categorie]);

  const totauxParMois = useMemo(() => {
    const t = {};
    for (let m = 1; m <= 12; m++) t[m] = 0;
    donneesFiltrees.forEach(d => {
      for (let m = 1; m <= 12; m++) t[m] += Number(d.mois[m] || 0);
    });
    return t;
  }, [donneesFiltrees]);

  const grandTotal = useMemo(
    () => donneesFiltrees.reduce((acc, d) => acc + Number(d.total || 0), 0),
    [donneesFiltrees]
  );

  return (
    <div>
      <div className="content">
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => setAnnee(a => a - 1)}>−</button>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>
            Plats les plus demandés {annee}
          </h2>
          <button className="btn" onClick={() => setAnnee(a => a + 1)}>+</button>

          <div style={{ display: 'flex', gap: 6, marginLeft: 8 }}>
            {CATEGORIES.map(cat => (
              <button
                key={cat.label}
                className="btn"
                onClick={() => setCategorie(cat.label)}
                style={{
                  background: categorie === cat.label ? '#111' : 'white',
                  color: categorie === cat.label ? 'white' : '#333',
                  fontWeight: categorie === cat.label ? 600 : 400,
                }}
              >
                {cat.label}
              </button>
            ))}
          </div>

          <input
            type="text"
            placeholder="Filtrer par nom..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
            style={{
              padding: '6px 12px', borderRadius: 8, border: '1px solid #ddd',
              fontSize: 13, minWidth: 200,
            }}
          />
          <span style={{ fontSize: 13, color: '#888' }}>
            Triés par quantité totale décroissante
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
                  <th style={thCell({ textAlign: 'left', position: 'sticky', left: 0, background: '#fafaf8', zIndex: 1 })}>Plat</th>
                  <th style={thCell({ textAlign: 'right', fontWeight: 700, position: 'sticky', left: 160, background: '#fafaf8', zIndex: 1 })}>Total</th>
                  {MOIS_ABR.map((nom, i) => (
                    <th key={i} style={thCell({ textAlign: 'right' })}>{nom}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {donneesFiltrees.map(d => (
                  <tr key={d.nom}>
                    <td style={tdCell({ textAlign: 'left', fontWeight: 600, position: 'sticky', left: 0, background: 'white', zIndex: 1 })}>
                      {d.nom}
                    </td>
                    <td style={tdCell({ textAlign: 'right', fontWeight: 700, position: 'sticky', left: 160, background: 'white', zIndex: 1 })}>
                      {fmtQte(d.total)}
                    </td>
                    {MOIS_ABR.map((_, i) => {
                      const mois = i + 1;
                      const valeur = Number(d.mois[mois] || 0);
                      return (
                        <td key={mois} style={tdCell({ textAlign: 'right', color: valeur !== 0 ? '#111' : '#ccc' })}>
                          {valeur !== 0 ? fmtQte(valeur) : '—'}
                        </td>
                      );
                    })}
                  </tr>
                ))}
                {donneesFiltrees.length === 0 && (
                  <tr>
                    <td style={tdCell({ textAlign: 'center', color: '#888' })} colSpan={14}>
                      Aucun plat trouvé
                    </td>
                  </tr>
                )}
              </tbody>
              <tfoot>
                <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                  <td style={tdCell({ textAlign: 'left', position: 'sticky', left: 0, background: '#fafaf8', zIndex: 1 })}>Total</td>
                  <td style={tdCell({ textAlign: 'right', position: 'sticky', left: 160, background: '#fafaf8', zIndex: 1 })}>{fmtQte(grandTotal)}</td>
                  {MOIS_ABR.map((_, i) => (
                    <td key={i} style={tdCell({ textAlign: 'right' })}>{fmtQte(totauxParMois[i + 1])}</td>
                  ))}
                </tr>
              </tfoot>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}