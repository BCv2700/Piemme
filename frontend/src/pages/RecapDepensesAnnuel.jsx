import { useState, useEffect, useMemo } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api/api';

const MOIS_NOMS_COURTS = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
const BORDURE = '1px solid #e5e5e0';

function dateKey(annee, mois, jour) {
  return annee + '-' + String(mois).padStart(2, '0') + '-' + String(jour).padStart(2, '0');
}

function joursDansMois(annee, mois) {
  return new Date(annee, mois, 0).getDate();
}

export default function RecapDepensesAnnuel() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const anneeParam = searchParams.get('annee');
  const [annee, setAnnee] = useState(anneeParam ? Number(anneeParam) : new Date().getFullYear());
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  // Tri : { colonne: 'nom' | 'total', sens: 'asc' | 'desc' }
  const [tri, setTri] = useState({ colonne: 'total', sens: 'desc' });

  const changerAnnee = (a) => {
    setAnnee(a);
    setSearchParams({ annee: a });
  };

  const load = () => {
    setLoading(true);
    setError('');
    const debut = dateKey(annee, 1, 1);
    const fin = dateKey(annee, 12, 31);
    api.get('/encaissements/', { params: { date_debut: debut, date_fin: fin } })
      .then(res => setEncaissements(res.data))
      .catch(() => setError('Impossible de charger les dépenses'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [annee]);

  // Dépenses uniquement
  const depenses = useMemo(() => encaissements.filter(e => e.depenses), [encaissements]);

  // Regrouper par fournisseur (article_nom de la première ligne) et par mois
  const { fournisseurs, parFournisseurMois, totauxMois, totauxFournisseur, grandTotal } = useMemo(() => {
    const map = {};
    const totauxM = {};
    for (let m = 1; m <= 12; m++) totauxM[m] = 0;

    depenses.forEach(enc => {
      const d = new Date(enc.date_encaissement);
      if (d.getFullYear() !== annee) return;
      const mois = d.getMonth() + 1;
      // Le nom du fournisseur/catégorie est le nom de l'article de la première ligne.
      // Encaissement sans lignes OU avec un nom vide → catégorie "Autre".
      const premierNom = enc.lignes && enc.lignes[0] ? (enc.lignes[0].article_nom || '') : '';
      const nomFournisseur = premierNom.trim() || 'Autre';
      const montant = Math.abs(Number(enc.montant_total || 0));

      if (!map[nomFournisseur]) {
        map[nomFournisseur] = {};
        for (let m = 1; m <= 12; m++) map[nomFournisseur][m] = 0;
      }
      map[nomFournisseur][mois] += montant;
      totauxM[mois] += montant;
    });

    const fournisseurs = Object.keys(map).sort((a, b) => a.localeCompare(b, 'fr'));
    const totauxF = {};
    let gt = 0;
    fournisseurs.forEach(f => {
      let t = 0;
      for (let m = 1; m <= 12; m++) t += map[f][m];
      totauxF[f] = t;
      gt += t;
    });

    return { fournisseurs, parFournisseurMois: map, totauxMois: totauxM, totauxFournisseur: totauxF, grandTotal: gt };
  }, [depenses, annee]);

  const fmt = (n) => Number(n).toFixed(2);
  const fmtZ = (n) => { const v = Number(n); return Math.abs(v) < 0.005 ? '' : v.toFixed(2); };

  // Liste triée selon le critère actif
  const fournisseursTries = useMemo(() => {
    return [...fournisseurs].sort((a, b) => {
      if (tri.colonne === 'total') {
        const diff = totauxFournisseur[a] - totauxFournisseur[b];
        return tri.sens === 'asc' ? diff : -diff;
      }
      const cmp = a.localeCompare(b, 'fr');
      return tri.sens === 'asc' ? cmp : -cmp;
    });
  }, [fournisseurs, totauxFournisseur, tri]);

  const basculerTri = (colonne) => {
    setTri(prev => ({
      colonne,
      sens: prev.colonne === colonne && prev.sens === 'asc' ? 'desc' : 'asc',
    }));
  };

  const indicateurTri = (colonne) => {
    if (tri.colonne !== colonne) return '';
    return tri.sens === 'asc' ? ' ▲' : ' ▼';
  };

  // Clic sur un montant → ouvrir l'historique filtré dépenses pour ce mois
  // Si fournisseur est spécifié, filtre aussi par nom d'article
  const ouvrirHistorique = (mois, fournisseur) => {
    const debut = dateKey(annee, mois, 1);
    const fin = dateKey(annee, mois, joursDansMois(annee, mois));
    let url = '/historique?debut=' + debut + '&fin=' + fin + '&depenses=1';
    if (fournisseur) url += '&fournisseur=' + encodeURIComponent(fournisseur);
    navigate(url);
  };

  const thCell = (extra = {}) => ({ padding: '6px 8px', border: BORDURE, fontSize: 12, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 8px', border: BORDURE, ...extra });

  return (
    <div>
      <div className="content">
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => changerAnnee(annee - 1)}>−</button>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>
            Dépenses {annee}
          </h2>
          <button className="btn" onClick={() => changerAnnee(annee + 1)}>+</button>
          <button className="btn" onClick={() => navigate(-1)} style={{ marginLeft: 16, fontSize: 12, color: '#888' }}>
            ← Retour
          </button>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : fournisseurs.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucune dépense enregistrée en {annee}</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto', marginBottom: 20 }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8' }}>
                  <th
                    style={thCell({ textAlign: 'left', position: 'sticky', left: 0, background: '#fafaf8', zIndex: 1, minWidth: 140, cursor: 'pointer', userSelect: 'none' })}
                    onClick={() => basculerTri('nom')}
                    title="Trier par nom"
                  >
                    Fournisseur / Catégorie{indicateurTri('nom')}
                  </th>
                  {MOIS_NOMS_COURTS.map((m, i) => (
                    <th key={i} style={thCell({ textAlign: 'right', minWidth: 68 })}>{m}</th>
                  ))}
                  <th
                    style={thCell({ textAlign: 'right', minWidth: 80, cursor: 'pointer', userSelect: 'none' })}
                    onClick={() => basculerTri('total')}
                    title="Trier par total"
                  >
                    Total{indicateurTri('total')}
                  </th>
                </tr>
              </thead>
              <tbody>
                {/* Ligne de totaux en haut */}
                <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                  <td style={tdCell({ textAlign: 'left', position: 'sticky', left: 0, background: '#fafaf8', zIndex: 1 })}>
                    Total {annee}
                  </td>
                  {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                    <td
                      key={m}
                      style={tdCell({
                        textAlign: 'right',
                        color: totauxMois[m] > 0 ? '#b91c1c' : '#ccc',
                        cursor: totauxMois[m] > 0 ? 'pointer' : 'default',
                        textDecoration: totauxMois[m] > 0 ? 'underline dotted' : 'none',
                      })}
                      onClick={() => totauxMois[m] > 0 && ouvrirHistorique(m)}
                      title={totauxMois[m] > 0 ? 'Voir toutes les dépenses de ce mois' : ''}
                    >
                      {fmtZ(totauxMois[m])}
                    </td>
                  ))}
                  <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(grandTotal)}</td>
                </tr>

                {/* Lignes par fournisseur */}
                {fournisseursTries.map(f => (
                  <tr key={f}>
                    <td style={tdCell({ textAlign: 'left', whiteSpace: 'nowrap', fontWeight: 500, position: 'sticky', left: 0, background: 'white', zIndex: 1 })}>
                      {f}
                    </td>
                    {Array.from({ length: 12 }, (_, i) => i + 1).map(m => {
                      const val = parFournisseurMois[f][m];
                      return (
                        <td
                          key={m}
                          style={tdCell({
                            textAlign: 'right',
                            color: val > 0 ? '#b91c1c' : '#ccc',
                            cursor: val > 0 ? 'pointer' : 'default',
                            textDecoration: val > 0 ? 'underline dotted' : 'none',
                          })}
                          onClick={() => val > 0 && ouvrirHistorique(m, f)}
                          title={val > 0 ? 'Voir les dépenses "' + f + '" de ce mois' : ''}
                        >
                          {fmtZ(val)}
                        </td>
                      );
                    })}
                    <td style={tdCell({ textAlign: 'right', fontWeight: 600, color: '#b91c1c' })}>{fmt(totauxFournisseur[f])}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                {/* Ligne de totaux en bas */}
                <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                  <td style={tdCell({ textAlign: 'left', position: 'sticky', left: 0, background: '#fafaf8', zIndex: 1 })}>
                    Total {annee}
                  </td>
                  {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                    <td
                      key={m}
                      style={tdCell({
                        textAlign: 'right',
                        color: totauxMois[m] > 0 ? '#b91c1c' : '#ccc',
                        cursor: totauxMois[m] > 0 ? 'pointer' : 'default',
                        textDecoration: totauxMois[m] > 0 ? 'underline dotted' : 'none',
                      })}
                      onClick={() => totauxMois[m] > 0 && ouvrirHistorique(m)}
                      title={totauxMois[m] > 0 ? 'Voir toutes les dépenses de ce mois' : ''}
                    >
                      {fmtZ(totauxMois[m])}
                    </td>
                  ))}
                  <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(grandTotal)}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}