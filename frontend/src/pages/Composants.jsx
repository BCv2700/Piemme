import { useState, useEffect } from 'react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import api from '../api/api';
import SelecteurArticle from '../components/SelecteurArticle';

const BORDURE = '1px solid #e5e5e0';

const LIBELLES_CODE_VENTE = {
  7001: 'Boissons Alcools',
  7002: 'Nourriture',
  7003: 'Boissons Softs',
  7004: 'Boissons Vins',
  7005: 'Divers',
};

export default function Composants() {
  const [composants, setComposants] = useState([]);
  const [articles, setArticles] = useState([]);
  const [recherche, setRecherche] = useState('');
  const [filtreArticleId, setFiltreArticleId] = useState(null);
  const [filtreCategorie, setFiltreCategorie] = useState('');
  const [creation, setCreation] = useState(null); // { article_id, description, prix }
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);

  const load = () => {
    setLoading(true);
    Promise.all([
      api.get('/articles-composants/'),
      api.get('/articles/'),
    ])
      .then(([compRes, artRes]) => {
        setComposants(compRes.data);
        setArticles(artRes.data);
      })
      .catch(() => setError('Impossible de charger les composants'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const afficherMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const articlesParId = Object.fromEntries(articles.map(a => [a.id, a]));

  const composantsAffiches = composants.filter(c => {
    const article = articlesParId[c.article_id];
    const nomArticle = article ? article.nom : '';
    const matchRecherche = !recherche
      || c.description.toLowerCase().includes(recherche.toLowerCase())
      || nomArticle.toLowerCase().includes(recherche.toLowerCase());
    const matchArticle = !filtreArticleId || c.article_id === filtreArticleId;
    const matchCategorie = !filtreCategorie || (article && String(article.code_vente) === filtreCategorie);
    return matchRecherche && matchArticle && matchCategorie;
  });

  // Tri : par nom de plat, puis par description, pour regrouper visuellement
  // les composants d'un même plat consécutivement.
  const composantsTries = [...composantsAffiches].sort((a, b) => {
    const nomA = articlesParId[a.article_id]?.nom || '';
    const nomB = articlesParId[b.article_id]?.nom || '';
    if (nomA !== nomB) return nomA.localeCompare(nomB, 'fr');
    return a.description.localeCompare(b.description, 'fr');
  });

  const totalAffiche = composantsAffiches.reduce((s, c) => s + Number(c.prix), 0);

  // ───── Édition inline ─────────────────────────────────────────────────
  const majComposant = async (id, champs) => {
    setError('');
    try {
      const res = await api.patch('/articles-composants/' + id, champs);
      setComposants(prev => prev.map(c => c.id === id ? res.data : c));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la mise à jour');
    }
  };

  const changerDescription = (composant, valeur) => {
    if (!valeur.trim()) return;
    majComposant(composant.id, { description: valeur });
  };

  const changerPrix = (composant, valeur) => {
    const n = Number(String(valeur).replace(',', '.'));
    if (!Number.isFinite(n) || n < 0) return;
    majComposant(composant.id, { prix: n });
  };

  const changerArticle = (composant, nouvelArticleId) => {
    if (!nouvelArticleId) return;
    majComposant(composant.id, { article_id: nouvelArticleId });
  };

  const supprimer = async (composant) => {
    if (!window.confirm('Supprimer ce composant ?')) return;
    setError('');
    try {
      await api.delete('/articles-composants/' + composant.id);
      setComposants(prev => prev.filter(c => c.id !== composant.id));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la suppression');
    }
  };

  // ───── Création ───────────────────────────────────────────────────────
  const ouvrirCreation = () => setCreation({ article_id: filtreArticleId || null, description: '', prix: '' });
  const fermerCreation = () => setCreation(null);

  const creerComposant = async () => {
    if (!creation.article_id) {
      afficherMsg('error', 'Choisis un plat');
      return;
    }
    if (!creation.description.trim()) {
      afficherMsg('error', 'La description est requise');
      return;
    }
    setError('');
    try {
      const payload = {
        article_id: creation.article_id,
        description: creation.description,
        prix: creation.prix === '' ? 0 : Number(String(creation.prix).replace(',', '.')),
      };
      const res = await api.post('/articles-composants/', payload);
      setComposants(prev => [...prev, res.data]);
      setCreation(null);
      afficherMsg('success', 'Composant ajouté');
    } catch (e) {
      afficherMsg('error', e.response?.data?.detail || "Erreur lors de l'ajout");
    }
  };

  const thCell = (extra = {}) => ({ padding: '6px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });

  // ───── Export PDF, groupé par plat, en respectant les filtres actifs ────
  const genererPdf = () => {
    if (composantsAffiches.length === 0) {
      afficherMsg('error', 'Aucun composant à imprimer avec les filtres actuels');
      return;
    }
    // Regroupe les composants affichés (déjà filtrés) par plat
    const parArticle = {};
    composantsAffiches.forEach(c => {
      if (!parArticle[c.article_id]) parArticle[c.article_id] = [];
      parArticle[c.article_id].push(c);
    });
    const articlesTries = Object.keys(parArticle)
      .map(id => articlesParId[id])
      .filter(Boolean)
      .sort((a, b) => a.nom.localeCompare(b.nom, 'fr'));

    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    doc.setFontSize(16);
    doc.setFont(undefined, 'bold');
    doc.text('Composants par plat', 14, 15);
    doc.setFontSize(9);
    doc.setFont(undefined, 'normal');
    const sousTitre = [
      filtreCategorie ? LIBELLES_CODE_VENTE[filtreCategorie] : null,
      filtreArticleId ? articlesParId[filtreArticleId]?.nom : null,
      recherche ? 'Recherche : "' + recherche + '"' : null,
    ].filter(Boolean).join('  ·  ') || 'Tous les plats';
    doc.text(sousTitre, 14, 21);

    const body = [];
    articlesTries.forEach(article => {
      const lignes = parArticle[article.id];
      const totalPlat = lignes.reduce((s, l) => s + Number(l.prix), 0);
      body.push([{
        content: article.nom + '  (' + (LIBELLES_CODE_VENTE[article.code_vente] || '—') + ')',
        colSpan: 2,
        styles: { fontStyle: 'bold', fillColor: [240, 240, 236] },
      }]);
      lignes.forEach(l => {
        body.push([l.description, Number(l.prix).toFixed(2)]);
      });
      body.push([
        { content: 'Total ' + article.nom, styles: { fontStyle: 'bold', fillColor: [250, 250, 248] } },
        { content: totalPlat.toFixed(2), styles: { fontStyle: 'bold', fillColor: [250, 250, 248] } },
      ]);
    });

    autoTable(doc, {
      startY: 27,
      head: [['Description', 'Prix']],
      body,
      styles: { fontSize: 8, cellPadding: 1.5, lineColor: [229, 229, 224], lineWidth: 0.1 },
      headStyles: { fillColor: [250, 250, 248], textColor: [40, 40, 40], fontStyle: 'bold' },
      columnStyles: {
        0: { halign: 'left', cellWidth: 140 },
        1: { halign: 'right' },
      },
      margin: { left: 14, right: 14 },
    });

    doc.setProperties({ title: 'composants-par-plat.pdf' });
    const blobUrl = doc.output('bloburl');
    window.open(blobUrl, '_blank');
  };

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <span style={{ fontSize: 13, color: '#888', fontWeight: 600, whiteSpace: 'nowrap' }}>
            {composants.length} composant{composants.length !== 1 ? 's' : ''}
          </span>
          <button className="btn" onClick={ouvrirCreation}>+ Nouveau composant</button>
          <button className="btn" onClick={genererPdf}>📄 PDF</button>
          <input
            type="text"
            placeholder="Rechercher par description ou par plat..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
            style={{ flex: 1, minWidth: 200, padding: '10px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          />
          <select
            value={filtreCategorie}
            onChange={(e) => setFiltreCategorie(e.target.value)}
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          >
            <option value="">Toutes les catégories</option>
            {Object.entries(LIBELLES_CODE_VENTE).map(([code, libelle]) => (
              <option key={code} value={code}>{libelle}</option>
            ))}
          </select>
          <SelecteurArticle
            articles={articles}
            articleId={filtreArticleId}
            onChange={setFiltreArticleId}
            placeholder="Tous les plats"
            style={{ minWidth: 200 }}
          />
          {(recherche || filtreCategorie || filtreArticleId) && (
            <button
              className="btn"
              onClick={() => { setRecherche(''); setFiltreCategorie(''); setFiltreArticleId(null); }}
              style={{ color: '#888' }}
            >
              Réinitialiser les filtres
            </button>
          )}
          <span style={{ marginLeft: 'auto', fontSize: 13, color: '#888' }}>
            Total affiché : <strong style={{ color: '#111' }}>{totalAffiche.toFixed(2)} €</strong>
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}></th>
                  <th style={thCell()}>Plat</th>
                  <th style={thCell()}>Catégorie</th>
                  <th style={thCell()}>Description</th>
                  <th style={thCell({ textAlign: 'right' })}>Prix</th>
                </tr>
              </thead>
              <tbody>
                {composantsTries.map((c, index) => {
                  const article = articlesParId[c.article_id];
                  const fondAlterne = index % 2 === 1 ? '#f0f0ec' : 'transparent';
                  return (
                    <tr key={c.id} style={{ background: fondAlterne }}>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <button
                          className="btn"
                          title="Supprimer ce composant"
                          style={{ color: '#dc2626', borderColor: '#fca5a5', fontSize: 14, padding: '2px 8px', lineHeight: 1 }}
                          onClick={() => supprimer(c)}
                        >
                          🗑
                        </button>
                      </td>
                      <td style={tdCell({ padding: '2px 4px', minWidth: 200 })}>
                        <SelecteurArticle
                          articles={articles}
                          articleId={c.article_id}
                          onChange={(id) => changerArticle(c, id)}
                          compact
                          style={{ width: '100%' }}
                        />
                      </td>
                      <td style={tdCell({ color: '#666' })}>
                        {article ? (LIBELLES_CODE_VENTE[article.code_vente] || '—') : '—'}
                      </td>
                      <td style={tdCell({ whiteSpace: 'normal', minWidth: 220 })}>
                        <input
                          type="text"
                          defaultValue={c.description}
                          onBlur={(e) => changerDescription(c, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{ width: '100%', padding: '4px 8px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                        />
                      </td>
                      <td style={tdCell({ textAlign: 'right' })}>
                        <input
                          type="number"
                          step="0.01"
                          min="0"
                          defaultValue={Number(c.prix).toFixed(2)}
                          onBlur={(e) => changerPrix(c, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{ width: 90, padding: '4px 8px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, textAlign: 'right' }}
                        />
                      </td>
                    </tr>
                  );
                })}
                {composantsTries.length === 0 && (
                  <tr>
                    <td colSpan={5} style={{ padding: 20, textAlign: 'center', color: '#888', border: BORDURE }}>
                      Aucun composant ne correspond aux filtres
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {creation && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 380 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 16 }}>Nouveau composant</div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Plat</label>
            <div style={{ marginBottom: 14 }}>
              <SelecteurArticle
                articles={articles}
                articleId={creation.article_id}
                onChange={(id) => setCreation({ ...creation, article_id: id })}
                style={{ width: '100%', boxSizing: 'border-box' }}
              />
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Description</label>
            <input
              type="text"
              autoFocus
              value={creation.description}
              onChange={(e) => setCreation({ ...creation, description: e.target.value })}
              placeholder="Ex: 5 scampis"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Prix</label>
            <input
              type="number"
              step="0.01"
              min="0"
              value={creation.prix}
              onChange={(e) => setCreation({ ...creation, prix: e.target.value })}
              placeholder="0.00"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={fermerCreation}>Annuler</button>
              <button className="btn" style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }} onClick={creerComposant}>Ajouter</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}