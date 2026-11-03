import { useState, useEffect } from 'react';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';

export default function Stock() {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState(null);
  const [recherche, setRecherche] = useState('');
  const [filtreAlerte, setFiltreAlerte] = useState(false);
  // stock en cours d'édition : { id: articleId, valeur: string }
  const [stockEnEdition, setStockEnEdition] = useState({});

  const load = () => {
    setLoading(true);
    api.get('/articles/', { params: { actif: true } })
      .then(r => {
        // Uniquement les articles à suivre
        setArticles(r.data.filter(a => a.stock_a_suivre));
      })
      .catch(() => setMsg({ type: 'error', text: 'Impossible de charger les articles' }))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const flash = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const sauvegarderStock = async (article, valeurStr) => {
    const valeur = parseInt(valeurStr, 10);
    if (isNaN(valeur)) return;
    if (valeur === article.stock) return; // pas de changement
    try {
      const res = await api.patch('/articles/' + article.id, { stock: valeur });
      setArticles(prev => prev.map(a => a.id === article.id ? { ...a, stock: res.data.stock } : a));
      flash('success', `Stock de « ${article.nom} » mis à jour → ${valeur}`);
    } catch (e) {
      flash('error', e.response?.data?.detail || 'Erreur lors de la mise à jour du stock');
    } finally {
      setStockEnEdition(prev => { const n = { ...prev }; delete n[article.id]; return n; });
    }
  };

  const articlesFiltres = articles.filter(a => {
    const ok_recherche = a.nom.toLowerCase().includes(recherche.toLowerCase()) ||
      (a.type_article || '').toLowerCase().includes(recherche.toLowerCase()) ||
      (a.fournisseur || '').toLowerCase().includes(recherche.toLowerCase());
    const ok_alerte = !filtreAlerte || a.stock <= a.stock_min;
    return ok_recherche && ok_alerte;
  });

  // Tri : négatifs d'abord, puis en dessous du min, puis par nom
  const articlesTriés = [...articlesFiltres].sort((a, b) => {
    const alerteA = a.stock < 0 ? 2 : a.stock <= a.stock_min ? 1 : 0;
    const alerteB = b.stock < 0 ? 2 : b.stock <= b.stock_min ? 1 : 0;
    if (alerteB !== alerteA) return alerteB - alerteA;
    return a.nom.localeCompare(b.nom, 'fr');
  });

  const nbNegatifs = articles.filter(a => a.stock < 0).length;
  const nbSousMin = articles.filter(a => a.stock >= 0 && a.stock <= a.stock_min && a.stock_min > 0).length;

  const thCell = (extra = {}) => ({ padding: '7px 14px', border: BORDURE, whiteSpace: 'nowrap', fontSize: 12, color: '#666', fontWeight: 600, background: '#fafaf8', ...extra });
  const tdCell = (extra = {}) => ({ padding: '6px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });

  const badgeStock = (article) => {
    if (article.stock < 0) return { bg: '#fee2e2', color: '#dc2626', label: '⚠️ Négatif' };
    if (article.stock_min > 0 && article.stock <= article.stock_min) return { bg: '#fef3c7', color: '#d97706', label: '↓ Sous min' };
    return null;
  };

  return (
    <div>
      <div className="content">

        {/* En-tête */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 20, flexWrap: 'wrap' }}>
          <h2 style={{ margin: 0, fontSize: 20, fontWeight: 700, color: '#1a1a1a' }}>📦 Gestion des stocks</h2>
          <span style={{ fontSize: 13, color: '#888' }}>{articles.length} article{articles.length !== 1 ? 's' : ''} suivis</span>
          <button className="btn" onClick={load} style={{ marginLeft: 'auto' }}>🔄 Rafraîchir</button>
        </div>

        {msg && (
          <div style={{
            padding: '10px 16px', borderRadius: 8, marginBottom: 16, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
            border: '1px solid ' + (msg.type === 'success' ? '#86efac' : '#fca5a5'),
          }}>
            {msg.text}
          </div>
        )}

        {/* Bandeaux d'alerte */}
        {(nbNegatifs > 0 || nbSousMin > 0) && (
          <div style={{ display: 'flex', gap: 12, marginBottom: 20, flexWrap: 'wrap' }}>
            {nbNegatifs > 0 && (
              <div style={{
                flex: 1, minWidth: 200,
                background: '#fee2e2', border: '1px solid #fca5a5', borderRadius: 10,
                padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 12,
              }}>
                <span style={{ fontSize: 28 }}>🚨</span>
                <div>
                  <div style={{ fontWeight: 700, color: '#dc2626', fontSize: 15 }}>
                    {nbNegatifs} stock{nbNegatifs > 1 ? 's' : ''} négatif{nbNegatifs > 1 ? 's' : ''}
                  </div>
                  <div style={{ fontSize: 12, color: '#b91c1c' }}>À corriger manuellement</div>
                </div>
              </div>
            )}
            {nbSousMin > 0 && (
              <div style={{
                flex: 1, minWidth: 200,
                background: '#fef3c7', border: '1px solid #fcd34d', borderRadius: 10,
                padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 12,
              }}>
                <span style={{ fontSize: 28 }}>⚠️</span>
                <div>
                  <div style={{ fontWeight: 700, color: '#d97706', fontSize: 15 }}>
                    {nbSousMin} article{nbSousMin > 1 ? 's' : ''} sous le point de commande
                  </div>
                  <div style={{ fontSize: 12, color: '#b45309' }}>Stock ≤ stock minimum</div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* Filtres */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap', alignItems: 'center' }}>
          <input
            type="text"
            placeholder="Rechercher par nom, type, fournisseur..."
            value={recherche}
            onChange={e => setRecherche(e.target.value)}
            style={{ flex: 1, minWidth: 220, padding: '9px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          />
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer', padding: '9px 14px', borderRadius: 8, border: '1px solid #ddd', background: filtreAlerte ? '#fef3c7' : 'white', userSelect: 'none' }}>
            <input
              type="checkbox"
              checked={filtreAlerte}
              onChange={e => setFiltreAlerte(e.target.checked)}
              style={{ width: 15, height: 15 }}
            />
            ⚠️ Alertes uniquement
          </label>
          <span style={{ fontSize: 13, color: '#aaa' }}>{articlesTriés.length} affiché{articlesTriés.length !== 1 ? 's' : ''}</span>
        </div>

        {/* Légende */}
        <div style={{ display: 'flex', gap: 16, marginBottom: 12, fontSize: 12, color: '#888' }}>
          <span><span style={{ display: 'inline-block', width: 10, height: 10, borderRadius: 2, background: '#fee2e2', border: '1px solid #fca5a5', marginRight: 4 }} />Stock négatif</span>
          <span><span style={{ display: 'inline-block', width: 10, height: 10, borderRadius: 2, background: '#fef3c7', border: '1px solid #fcd34d', marginRight: 4 }} />Sous le point de commande</span>
          <span style={{ marginLeft: 8, color: '#aaa' }}>Cliquez sur le stock pour le modifier directement</span>
        </div>

        {loading ? (
          <div style={{ color: '#888', padding: 20 }}>Chargement...</div>
        ) : articlesTriés.length === 0 ? (
          <div style={{ color: '#888', padding: 20, textAlign: 'center' }}>
            {articles.length === 0
              ? 'Aucun article avec suivi de stock activé.'
              : 'Aucun article ne correspond aux filtres.'}
          </div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr>
                  <th style={thCell()}>Article</th>
                  <th style={thCell()}>Type</th>
                  <th style={thCell()}>Fournisseur</th>
                  <th style={thCell({ textAlign: 'center' })}>Stock actuel</th>
                  <th style={thCell({ textAlign: 'center' })}>Stock min</th>
                  <th style={thCell({ textAlign: 'center' })}>Stock max</th>
                  <th style={thCell({ textAlign: 'center' })}>État</th>
                </tr>
              </thead>
              <tbody>
                {articlesTriés.map((article, index) => {
                  const badge = badgeStock(article);
                  const fond = article.stock < 0
                    ? '#fff5f5'
                    : (article.stock_min > 0 && article.stock <= article.stock_min)
                      ? '#fffbeb'
                      : index % 2 === 1 ? '#fafaf8' : 'white';

                  const enEdition = article.id in stockEnEdition;
                  const valeurEdition = stockEnEdition[article.id] ?? String(article.stock);

                  return (
                    <tr key={article.id} style={{ background: fond }}>
                      <td style={tdCell({ fontWeight: 600 })}>{article.nom}</td>
                      <td style={tdCell({ color: '#666' })}>{article.type_article || '—'}</td>
                      <td style={tdCell({ color: '#666' })}>{article.fournisseur || '—'}</td>

                      {/* Stock éditable inline */}
                      <td style={tdCell({ textAlign: 'center', padding: '4px 14px' })}>
                        <input
                          type="number"
                          value={enEdition ? valeurEdition : article.stock}
                          onChange={e => setStockEnEdition(prev => ({ ...prev, [article.id]: e.target.value }))}
                          onFocus={e => {
                            setStockEnEdition(prev => ({ ...prev, [article.id]: String(article.stock) }));
                            e.target.select();
                          }}
                          onBlur={e => sauvegarderStock(article, e.target.value)}
                          onKeyDown={e => {
                            if (e.key === 'Enter') e.target.blur();
                            if (e.key === 'Escape') {
                              setStockEnEdition(prev => { const n = { ...prev }; delete n[article.id]; return n; });
                              e.target.blur();
                            }
                          }}
                          style={{
                            width: 80,
                            padding: '5px 8px',
                            borderRadius: 6,
                            border: enEdition ? '2px solid #6366f1' : '1px solid #ddd',
                            fontSize: 14,
                            fontWeight: 700,
                            textAlign: 'center',
                            color: article.stock < 0 ? '#dc2626' : '#1a1a1a',
                            background: enEdition ? '#f5f3ff' : 'transparent',
                            cursor: 'text',
                            outline: 'none',
                          }}
                        />
                      </td>

                      <td style={tdCell({ textAlign: 'center', color: '#666' })}>
                        {article.stock_min > 0 ? article.stock_min : <span style={{ color: '#ccc' }}>—</span>}
                      </td>
                      <td style={tdCell({ textAlign: 'center', color: '#666' })}>
                        {article.stock_max > 0 ? article.stock_max : <span style={{ color: '#ccc' }}>—</span>}
                      </td>

                      <td style={tdCell({ textAlign: 'center' })}>
                        {badge ? (
                          <span style={{
                            display: 'inline-block',
                            padding: '2px 10px',
                            borderRadius: 20,
                            fontSize: 11,
                            fontWeight: 600,
                            background: badge.bg,
                            color: badge.color,
                          }}>
                            {badge.label}
                          </span>
                        ) : (
                          <span style={{ color: '#16a34a', fontWeight: 600, fontSize: 13 }}>✓ OK</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
