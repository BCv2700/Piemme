import { useState, useEffect, useMemo } from 'react';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';

const LIBELLES_CODE_VENTE = {
  7001: 'Boissons Alcools',
  7002: 'Nourriture',
  7003: 'Boissons Softs',
  7004: 'Boissons Vins',
  7005: 'Divers',
};
const ORDRE_CODE_VENTE = [7001, 7002, 7003, 7004, 7005];

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

export default function CoutMatiere() {
  const [dateUnique, setDateUnique] = useState(todayKey());
  const [encaissements, setEncaissements] = useState([]);
  const [articles, setArticles] = useState([]);
  const [composants, setComposants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const load = () => {
    setLoading(true);
    setError('');
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateUnique, date_fin: dateUnique } }),
      api.get('/articles/'),
      api.get('/articles-composants/'),
    ])
      .then(([encRes, artRes, compRes]) => {
        setEncaissements(encRes.data);
        setArticles(artRes.data);
        setComposants(compRes.data);
      })
      .catch(() => setError('Impossible de charger les données du jour'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateUnique]);

  const articlesParId = useMemo(() => {
    const map = {};
    articles.forEach(a => { map[a.id] = a; });
    return map;
  }, [articles]);

  const composantsParArticle = useMemo(() => {
    const map = {};
    composants.forEach(c => {
      if (!map[c.article_id]) map[c.article_id] = [];
      map[c.article_id].push(c);
    });
    return map;
  }, [composants]);

  // Recettes du jour uniquement (les dépenses n'ont pas de "coût matière")
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Explose chaque ligne vendue en ses composants (ou en elle-même si aucun
  // composant défini, en utilisant Prix d'achat de l'article), regroupés par
  // catégorie (code de vente du plat vendu).
  const { categories, totalCout, totalCa, totalCarte, totalCash } = useMemo(() => {
    const parCategorie = {}; // code_vente -> [{description, qteVendue, prixUnitaire, total}]
    let coutCumule = 0;
    let caCumule = 0;
    let carteCumule = 0;
    let cashCumule = 0;

    recettes.forEach(enc => {
      carteCumule += Number(enc.montant_carte || 0);
      cashCumule += Number(enc.montant_cash || 0);
      (enc.lignes || []).forEach(ligne => {
        const qte = Number(ligne.quantite);
        caCumule += qte * Number(ligne.prix_vente);
        const article = articlesParId[ligne.article_id];
        const codeVente = article ? article.code_vente : null;
        const compos = article ? (composantsParArticle[article.id] || []) : [];

        const lignesCout = compos.length > 0
          ? compos.map(c => ({ description: c.description, prixUnitaire: Number(c.prix) }))
          : [{ description: article ? article.nom : ligne.article_nom, prixUnitaire: article ? Number(article.prix_achat || 0) : 0 }];

        lignesCout.forEach(lc => {
          const total = qte * lc.prixUnitaire;
          coutCumule += total;
          const cle = codeVente || 'autre';
          if (!parCategorie[cle]) parCategorie[cle] = [];
          parCategorie[cle].push({
            description: lc.description,
            qteVendue: qte,
            prixUnitaire: lc.prixUnitaire,
            total,
          });
        });
      });
    });

    const ordreClefs = [...ORDRE_CODE_VENTE, 'autre'].filter(k => parCategorie[k]);
    const categoriesTriees = ordreClefs.map(cle => ({
      cle,
      libelle: LIBELLES_CODE_VENTE[cle] || 'Non classé',
      lignes: parCategorie[cle],
    }));

    return { categories: categoriesTriees, totalCout: coutCumule, totalCa: caCumule, totalCarte: carteCumule, totalCash: cashCumule };
  }, [recettes, articlesParId, composantsParArticle]);

  const pourcentage = totalCa > 0 ? (totalCout / totalCa) * 100 : 0;
  const fmt = (n) => Number(n).toFixed(2);

  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, ...extra });

  return (
    <div>
      <div className="content">
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>Coût matière</h2>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <>
            <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>% Coût matière</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: pourcentage > 33 ? '#dc2626' : '#16a34a' }}>{pourcentage.toFixed(2)}%</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Coût matière</div>
                <div style={{ fontSize: 18, fontWeight: 700 }}>{fmt(totalCout)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Chiffre d'affaires</div>
                <div style={{ fontSize: 18, fontWeight: 700 }}>{fmt(totalCa)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Carte</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: '#2563eb' }}>{fmt(totalCarte)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Cash</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: '#16a34a' }}>{fmt(totalCash)} €</div>
              </div>
            </div>

            {categories.length === 0 ? (
              <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucune vente ce jour</div>
            ) : (
              <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                  <thead>
                    <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                      <th style={thCell()}>Composant</th>
                      <th style={thCell({ textAlign: 'right' })}>Qté vendue</th>
                      <th style={thCell({ textAlign: 'right' })}>Prix</th>
                      <th style={thCell({ textAlign: 'right' })}>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {categories.map(cat => (
                      <>
                        <tr key={'cat-' + cat.cle} style={{ background: '#f0f0ec' }}>
                          <td style={tdCell({ fontWeight: 700 })} colSpan={4}>{cat.libelle}</td>
                        </tr>
                        {cat.lignes.map((l, i) => (
                          <tr key={cat.cle + '-' + i}>
                            <td style={tdCell({ paddingLeft: 24 })}>{l.description}</td>
                            <td style={tdCell({ textAlign: 'right' })}>{l.qteVendue}</td>
                            <td style={tdCell({ textAlign: 'right' })}>{fmt(l.prixUnitaire)}</td>
                            <td style={tdCell({ textAlign: 'right', fontWeight: 600 })}>{fmt(l.total)}</td>
                          </tr>
                        ))}
                      </>
                    ))}
                  </tbody>
                  <tfoot>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell()} colSpan={3}>Total coût matière</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totalCout)}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}