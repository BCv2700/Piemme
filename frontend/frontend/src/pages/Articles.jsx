import { useState, useEffect, useRef } from 'react';
import api from '../api/api';

const CODE_VENTE_DEPENSE = 9001;
const BORDURE = '1px solid #e5e5e0';
const LS_KEY = 'lolive_articles_colonnes';

const ARTICLE_VIDE = {
  nom: '', categorie: '', type_article: '', code_vente: '', tva: 21, tva_away: '',
  prix_achat: 0, prix_vente: 0, prix_vente_away: '', stock: 0, stock_min: 0, stock_max: 0,
  stock_a_suivre: false, est_boisson: false, imprimer_cuisine: false, ordre: '',
  ean: '', fournisseur: '', localisation: '', actif: true,
};

const LIBELLES_CODE_VENTE = {
  7001: 'Boissons Alcools', 7002: 'Nourriture', 7003: 'Boissons Softs',
  7004: 'Boissons Vins', 7005: 'Divers', 9001: 'Dépenses',
};

const TOUTES_COLONNES = [
  { id: 'id',              label: 'ID',           type: 'readonly' },
  { id: 'ordre',           label: 'Ordre',        type: 'number',  champ: 'ordre',          width: 44 },
  { id: 'nom',             label: 'Nom',          type: 'text',    champ: 'nom',             minWidth: 160 },
  { id: 'type_article',    label: 'Type',         type: 'text',    champ: 'type_article' },
  { id: 'code_vente',      label: 'Code vente',   type: 'select_code_vente', champ: 'code_vente' },
  { id: 'categorie',       label: 'Catégorie',    type: 'custom_categorie' },
  { id: 'fournisseur',     label: 'Fournisseur',  type: 'text',    champ: 'fournisseur' },
  { id: 'localisation',    label: 'Localisation', type: 'text',    champ: 'localisation' },
  { id: 'ean',             label: 'EAN',          type: 'text',    champ: 'ean' },
  { id: 'prix_vente',      label: 'Prix vente',   type: 'price',   champ: 'prix_vente',      align: 'right', width: 72 },
  { id: 'prix_vente_away', label: 'Prix emport.', type: 'price',   champ: 'prix_vente_away', align: 'right', width: 72 },
  { id: 'prix_achat',      label: 'Prix achat',   type: 'price',   champ: 'prix_achat',      align: 'right', width: 72 },
  { id: 'tva',             label: 'TVA %',        type: 'price',   champ: 'tva',             align: 'right', width: 55 },
  { id: 'tva_away',        label: 'TVA emport.%', type: 'price',   champ: 'tva_away',        align: 'right', width: 55 },
  { id: 'stock',           label: 'Stock',        type: 'number',  champ: 'stock',           align: 'right', width: 55 },
  { id: 'stock_min',       label: 'Stock min',    type: 'number',  champ: 'stock_min',       align: 'right', width: 55 },
  { id: 'stock_max',       label: 'Stock max',    type: 'number',  champ: 'stock_max',       align: 'right', width: 55 },
  { id: 'stock_a_suivre',  label: 'À suivre',     type: 'bool',    champ: 'stock_a_suivre' },
  { id: 'est_boisson',     label: 'Boisson',      type: 'bool',    champ: 'est_boisson' },
  { id: 'imprimer_cuisine',label: 'Cuisine',      type: 'bool',    champ: 'imprimer_cuisine' },
  { id: 'actif',           label: 'Actif',        type: 'dot',     champ: 'actif' },
];

const COLONNES_DEFAUT = ['ordre', 'nom', 'type_article', 'code_vente', 'prix_vente', 'stock', 'stock_min', 'stock_a_suivre', 'actif'];

// Input number sans flèches (spinner)
const inputNoSpinner = {
  MozAppearance: 'textfield',
  WebkitAppearance: 'none',
  appearance: 'textfield',
};

function chargerColonnes() {
  try {
    const saved = localStorage.getItem(LS_KEY);
    if (saved) return JSON.parse(saved);
  } catch {}
  return COLONNES_DEFAUT;
}

export default function Articles() {
  const [articles, setArticles] = useState([]);
  const [recherche, setRecherche] = useState('');
  const [filtreType, setFiltreType] = useState('');
  const [filtreCodeVente, setFiltreCodeVente] = useState('');
  const [filtreASuivre, setFiltreASuivre] = useState(false);
  const [filtreBoisson, setFiltreBoisson] = useState(false);
  const [colonnesVisibles, setColonnesVisibles] = useState(chargerColonnes);
  const [panneauColonnes, setPanneauColonnes] = useState(false);
  const refPanneau = useRef(null);

  const [edition, setEdition] = useState(null);
  const [nouvelleCategorie, setNouvelleCategorie] = useState(false);
  const [composants, setComposants] = useState([]);
  const [composantsChargement, setComposantsChargement] = useState(false);

  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selection, setSelection] = useState([]);
  const [suppressionEnCours, setSuppressionEnCours] = useState(false);
  const [editsLocaux, setEditsLocaux] = useState({});

  const load = () => {
    setLoading(true);
    api.get('/articles/')
      .then(r => setArticles(r.data))
      .catch(() => setError('Impossible de charger les articles'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  useEffect(() => {
    const handler = (e) => {
      if (refPanneau.current && !refPanneau.current.contains(e.target)) setPanneauColonnes(false);
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const toggleColonne = (id) => {
    setColonnesVisibles(prev => {
      const next = prev.includes(id) ? prev.filter(c => c !== id) : [...prev, id];
      localStorage.setItem(LS_KEY, JSON.stringify(next));
      return next;
    });
  };

  const colonnes = TOUTES_COLONNES.filter(c => colonnesVisibles.includes(c.id));

  const types = [...new Set(articles.map(a => a.type_article).filter(Boolean))].sort();
  const codesVente = [...new Set(articles.map(a => a.code_vente).filter(c => c != null))].sort((a, b) => a - b);
  const categoriesDepense = [...new Set(
    articles.filter(a => a.code_vente === CODE_VENTE_DEPENSE).map(a => a.categorie).filter(Boolean)
  )].sort((a, b) => a.localeCompare(b, 'fr'));

  const articlesAffiches = articles.filter(a =>
    (a.nom.toLowerCase().includes(recherche.toLowerCase()) ||
      (a.type_article || '').toLowerCase().includes(recherche.toLowerCase())) &&
    (filtreType === '' || a.type_article === filtreType) &&
    (filtreCodeVente === '' || String(a.code_vente) === filtreCodeVente) &&
    (!filtreASuivre || a.stock_a_suivre) &&
    (!filtreBoisson || a.est_boisson)
  );

  // ── Édition inline ────────────────────────────────────────────────────────

  const cleEdit = (articleId, champ) => `${articleId}_${champ}`;
  const valeurLocale = (article, champ) => {
    const cle = cleEdit(article.id, champ);
    return cle in editsLocaux ? editsLocaux[cle] : article[champ];
  };
  const setValeurLocale = (articleId, champ, val) =>
    setEditsLocaux(prev => ({ ...prev, [cleEdit(articleId, champ)]: val }));
  const clearValeurLocale = (articleId, champ) =>
    setEditsLocaux(prev => { const n = { ...prev }; delete n[cleEdit(articleId, champ)]; return n; });

  const patchArticle = async (article, champ, valeurRaw) => {
    let valeur = valeurRaw;
    if (['ordre', 'stock', 'stock_min', 'stock_max'].includes(champ))
      valeur = valeurRaw === '' || valeurRaw === null ? null : parseInt(valeurRaw, 10);
    if (['prix_vente', 'prix_achat', 'prix_vente_away', 'tva', 'tva_away'].includes(champ))
      valeur = valeurRaw === '' || valeurRaw === null ? null : parseFloat(valeurRaw);
    if (champ === 'code_vente')
      valeur = valeurRaw === '' ? null : Number(valeurRaw);
    if (valeur === article[champ]) { clearValeurLocale(article.id, champ); return; }
    try {
      const res = await api.patch('/articles/' + article.id, { [champ]: valeur });
      setArticles(prev => prev.map(a => a.id === article.id ? { ...a, ...res.data } : a));
      flash('success', `« ${article.nom} » mis à jour`);
    } catch (e) {
      flash('error', e.response?.data?.detail || 'Erreur lors de la mise à jour');
    } finally {
      clearValeurLocale(article.id, champ);
    }
  };

  const flash = (type, text) => { setMsg({ type, text }); setTimeout(() => setMsg(null), 2500); };

  const CellInput = ({ article, col, type = 'text', step }) => {
    const val = valeurLocale(article, col.champ);
    const isNumber = type !== 'text';
    return (
      <input
        type={isNumber ? 'number' : 'text'}
        step={step}
        value={val ?? ''}
        placeholder="—"
        onChange={e => setValeurLocale(article.id, col.champ, e.target.value)}
        onBlur={e => patchArticle(article, col.champ, e.target.value)}
        onKeyDown={e => { if (e.key === 'Enter') e.target.blur(); if (e.key === 'Escape') { clearValeurLocale(article.id, col.champ); e.target.blur(); } }}
        onClick={e => e.stopPropagation()}
        style={{
          width: col.width ?? (isNumber ? 60 : '100%'),
          minWidth: col.minWidth,
          padding: '3px 5px', borderRadius: 4,
          border: '1px solid #ddd', fontSize: 12,
          textAlign: col.align || 'left',
          background: 'transparent',
          boxSizing: 'border-box',
          ...(isNumber ? inputNoSpinner : {}),
        }}
      />
    );
  };

  const renderCell = (article, col) => {
    switch (col.type) {
      case 'readonly':
        return <span style={{ color: '#aaa', fontSize: 12 }}>{article[col.id]}</span>;
      case 'dot':
      case 'bool':
        return (
          <input type="checkbox" checked={!!valeurLocale(article, col.champ)}
            onClick={e => e.stopPropagation()}
            onChange={e => patchArticle(article, col.champ, e.target.checked)}
            style={{ width: 14, height: 14, cursor: 'pointer' }} />
        );
      case 'text':
        return <CellInput article={article} col={col} type="text" />;
      case 'number':
        return <CellInput article={article} col={col} type="number" step="1" />;
      case 'price':
        return <CellInput article={article} col={col} type="number" step="0.01" />;
      case 'select_code_vente':
        return (
          <select value={article.code_vente ?? ''} onClick={e => e.stopPropagation()}
            onChange={e => patchArticle(article, col.champ, e.target.value)}
            style={{ fontSize: 12, padding: '3px 5px', borderRadius: 4, border: '1px solid #ddd', background: 'white' }}>
            <option value="">—</option>
            {Object.entries(LIBELLES_CODE_VENTE).map(([code, lib]) => <option key={code} value={code}>{lib}</option>)}
          </select>
        );
      case 'custom_categorie':
        if (article.code_vente !== CODE_VENTE_DEPENSE) return <span style={{ color: '#ccc' }}>—</span>;
        return (
          <select value={article.categorie || ''} onClick={e => e.stopPropagation()}
            onChange={e => patchArticle(article, 'categorie', e.target.value === '' ? null : e.target.value)}
            style={{ fontSize: 12, padding: '3px 5px', borderRadius: 4, border: '1px solid #ddd', background: 'white', maxWidth: 150 }}>
            <option value="">Non classé</option>
            {categoriesDepense.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        );
      default: return null;
    }
  };

  // ── Modale ───────────────────────────────────────────────────────────────

  const ouvrirCreation = () => { setNouvelleCategorie(false); setComposants([]); setEdition({ ...ARTICLE_VIDE }); };

  const ouvrirEditionComplete = async (article) => {
    setNouvelleCategorie(false); setEdition({ ...article }); setComposants([]); setComposantsChargement(true);
    try { const res = await api.get('/articles-composants/', { params: { article_id: article.id } }); setComposants(res.data); }
    catch {} finally { setComposantsChargement(false); }
  };

  const fermerFormulaire = () => { setNouvelleCategorie(false); setEdition(null); setComposants([]); };
  const majChamp = (champ, valeur) => setEdition(prev => ({ ...prev, [champ]: valeur }));
  const ajouterComposant = () => setComposants(prev => [...prev, { id: null, description: '', prix: 0 }]);
  const modifierComposantChamp = (index, champ, valeur) =>
    setComposants(prev => prev.map((c, i) => i === index ? { ...c, [champ]: valeur } : c));

  const sauverComposant = async (index) => {
    const ligne = composants[index];
    if (!ligne.description?.trim()) return;
    try {
      if (ligne.id) {
        const res = await api.patch('/articles-composants/' + ligne.id, { description: ligne.description, prix: Number(String(ligne.prix).replace(',', '.')) || 0 });
        setComposants(prev => prev.map((c, i) => i === index ? res.data : c));
      } else {
        const res = await api.post('/articles-composants/', { article_id: edition.id, description: ligne.description, prix: Number(String(ligne.prix).replace(',', '.')) || 0 });
        setComposants(prev => prev.map((c, i) => i === index ? res.data : c));
      }
    } catch (e) { setError(e.response?.data?.detail || "Erreur composant"); }
  };

  const supprimerComposant = async (index) => {
    const ligne = composants[index];
    if (ligne.id) { try { await api.delete('/articles-composants/' + ligne.id); } catch { setError('Erreur suppression composant'); return; } }
    setComposants(prev => prev.filter((_, i) => i !== index));
  };

  const totalComposants = composants.reduce((s, c) => s + (Number(c.prix) || 0), 0);
  const dupliquerArticle = () => { setNouvelleCategorie(false); setComposants([]); setEdition(prev => ({ ...prev, id: undefined, nom: prev.nom + ' (copie)' })); };

  const enregistrer = async () => {
    setError('');
    const payload = {
      ...edition,
      categorie: edition.categorie === '' ? null : edition.categorie,
      code_vente: edition.code_vente === '' ? null : Number(edition.code_vente),
      tva: Number(edition.tva), tva_away: edition.tva_away === '' ? null : Number(edition.tva_away),
      prix_achat: Number(edition.prix_achat), prix_vente: Number(edition.prix_vente),
      prix_vente_away: edition.prix_vente_away === '' ? null : Number(edition.prix_vente_away),
      stock: Number(edition.stock), stock_min: Number(edition.stock_min), stock_max: Number(edition.stock_max),
      ordre: edition.ordre === '' || edition.ordre == null ? null : Number(edition.ordre),
    };
    try {
      if (edition.id) { await api.patch('/articles/' + edition.id, payload); flash('success', 'Article mis à jour'); }
      else { await api.post('/articles/', payload); flash('success', 'Article créé'); }
      setEdition(null); load();
    } catch (e) { setError(e.response?.data?.detail || "Erreur lors de l'enregistrement"); }
  };

  const demanderSuppression = (article) => { if (window.confirm('Supprimer définitivement « ' + article.nom + ' » ?')) supprimer(article); };
  const supprimer = async (article) => {
    try { await api.delete('/articles/' + article.id); flash('success', 'Article supprimé'); setEdition(null); load(); }
    catch (e) { setError(e.response?.data?.detail || 'Erreur lors de la suppression'); }
  };

  const basculerSelection = (id) => setSelection(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  const idsAffiches = articlesAffiches.map(a => a.id);
  const toutAfficheCoche = idsAffiches.length > 0 && idsAffiches.every(id => selection.includes(id));
  const basculerToutAffiche = () => {
    if (toutAfficheCoche) setSelection(prev => prev.filter(id => !idsAffiches.includes(id)));
    else setSelection(prev => [...new Set([...prev, ...idsAffiches])]);
  };
  const supprimerSelection = async () => {
    if (!selection.length) return;
    if (!window.confirm('Supprimer définitivement ' + selection.length + ' article(s) ?')) return;
    setSuppressionEnCours(true);
    let echecs = 0;
    for (const id of selection) { try { await api.delete('/articles/' + id); } catch { echecs++; } }
    setSuppressionEnCours(false); setSelection([]);
    flash(echecs === 0 ? 'success' : 'error', echecs === 0 ? 'Articles supprimés' : echecs + ' suppression(s) ont échoué');
    load();
  };

  const escapeHtml = (s) => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const imprimerInventaire = () => {
    if (!articlesAffiches.length) { flash('error', 'Aucun article à imprimer'); return; }
    const lignesHtml = [...articlesAffiches].sort((a, b) => a.nom.localeCompare(b.nom, 'fr', { numeric: true }))
      .map(a => '<tr><td class="nom">' + escapeHtml(a.nom) + '</td><td class="chiffre">' + a.stock + '</td><td class="chiffre">' + a.stock_min + '</td></tr>').join('');
    const fenetre = window.open('', '_blank', 'width=400,height=600');
    if (!fenetre) { flash('error', "Pop-up bloqué"); return; }
    fenetre.document.write(`<html><head><meta charset="utf-8"/><title>Inventaire</title><style>@page{size:72mm auto;margin:2mm}body{font-family:'Courier New',monospace;width:68mm;margin:0;padding:4px}h1{font-size:15px;text-align:center;margin:0 0 4px}.date{font-size:11px;text-align:center;margin-bottom:8px;color:#333}hr{border:none;border-top:1px dashed #000;margin:6px 0}table{width:100%;border-collapse:collapse;font-size:11px}th{text-align:left;font-size:10px;border-bottom:1px solid #000;padding:2px 0}.chiffre{text-align:right;white-space:nowrap}th.chiffre{text-align:right}td.nom{padding:2px 4px 2px 0}td.chiffre{padding:2px 0}</style></head><body><h1>📋 INVENTAIRE</h1><div class="date">${new Date().toLocaleDateString('fr-BE',{weekday:'long',day:'numeric',month:'long'})}</div><hr/><table><thead><tr><th>Article</th><th class="chiffre">Stock</th><th class="chiffre">Min</th></tr></thead><tbody>${lignesHtml}</tbody></table></body></html>`);
    fenetre.document.close(); fenetre.focus();
    setTimeout(() => fenetre.print(), 250);
  };

  // ── Styles ────────────────────────────────────────────────────────────────
  const thCell = (extra = {}) => ({ padding: '5px 8px', border: BORDURE, whiteSpace: 'nowrap', fontSize: 12, background: '#fafaf8', width: '1%', ...extra });
  const tdCell = (extra = {}) => ({ padding: '3px 8px', border: BORDURE, whiteSpace: 'nowrap', width: '1%', ...extra });

  return (
    <div>
      <div className="content">

        {msg && (
          <div style={{ padding: '10px 16px', borderRadius: 8, marginBottom: 12, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
            border: '1px solid ' + (msg.type === 'success' ? '#86efac' : '#fca5a5') }}>
            {msg.text}
          </div>
        )}
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        {/* Barre d'outils */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          <span style={{ fontSize: 13, color: '#888', fontWeight: 600 }}>{articles.length} article{articles.length !== 1 ? 's' : ''}</span>
          <button className="btn" onClick={ouvrirCreation}>+ Nouvel article</button>
          <input type="text" placeholder="Rechercher par nom ou type..." value={recherche}
            onChange={e => setRecherche(e.target.value)}
            style={{ flex: 1, minWidth: 180, padding: '8px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 13 }} />
          <select value={filtreCodeVente} onChange={e => setFiltreCodeVente(e.target.value)}
            style={{ padding: '8px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 13 }}>
            <option value="">Tous les codes</option>
            {codesVente.map(c => <option key={c} value={String(c)}>{LIBELLES_CODE_VENTE[c] || c}</option>)}
          </select>
          <select value={filtreType} onChange={e => setFiltreType(e.target.value)}
            style={{ padding: '8px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 13 }}>
            <option value="">Tous les types</option>
            {types.map(t => <option key={t} value={t}>{t}</option>)}
          </select>
          <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
            <input type="checkbox" checked={filtreASuivre} onChange={e => setFiltreASuivre(e.target.checked)} style={{ width: 15, height: 15 }} />
            À suivre
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
            <input type="checkbox" checked={filtreBoisson} onChange={e => setFiltreBoisson(e.target.checked)} style={{ width: 15, height: 15 }} />
            Boissons
          </label>
          <button className="btn" onClick={imprimerInventaire} title="Imprimer inventaire">🖨️</button>

          <div ref={refPanneau} style={{ position: 'relative' }}>
            <button className="btn" onClick={() => setPanneauColonnes(v => !v)}
              style={{ background: panneauColonnes ? '#f0f0ee' : undefined }}>
              ⚙️ Colonnes ({colonnesVisibles.length})
            </button>
            {panneauColonnes && (
              <div style={{
                position: 'absolute', top: '100%', right: 0, marginTop: 4, zIndex: 50,
                background: 'white', border: BORDURE, borderRadius: 10,
                boxShadow: '0 4px 16px rgba(0,0,0,0.1)', padding: 12, minWidth: 200,
                display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '4px 16px',
              }}>
                <div style={{ gridColumn: '1/-1', fontSize: 11, color: '#888', fontWeight: 600, marginBottom: 4, textTransform: 'uppercase', letterSpacing: 0.5 }}>
                  Colonnes visibles
                </div>
                {TOUTES_COLONNES.map(col => (
                  <label key={col.id} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer', padding: '2px 0' }}>
                    <input type="checkbox" checked={colonnesVisibles.includes(col.id)}
                      onChange={() => toggleColonne(col.id)} style={{ width: 14, height: 14 }} />
                    {col.label}
                  </label>
                ))}
                <div style={{ gridColumn: '1/-1', marginTop: 8, display: 'flex', gap: 6 }}>
                  <button className="btn" style={{ fontSize: 11, padding: '3px 8px' }}
                    onClick={() => { const all = TOUTES_COLONNES.map(c => c.id); setColonnesVisibles(all); localStorage.setItem(LS_KEY, JSON.stringify(all)); }}>
                    Tout
                  </button>
                  <button className="btn" style={{ fontSize: 11, padding: '3px 8px' }}
                    onClick={() => { setColonnesVisibles(COLONNES_DEFAUT); localStorage.setItem(LS_KEY, JSON.stringify(COLONNES_DEFAUT)); }}>
                    Défaut
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>

        {selection.length > 0 && (
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '8px 14px', marginBottom: 10, borderRadius: 8, background: '#fef3c7', border: '1px solid #fcd34d' }}>
            <span style={{ fontSize: 13, fontWeight: 600, color: '#92400e' }}>{selection.length} sélectionné{selection.length > 1 ? 's' : ''}</span>
            <button className="btn" disabled={suppressionEnCours} style={{ color: '#dc2626', borderColor: '#fca5a5', fontWeight: 600 }} onClick={supprimerSelection}>
              {suppressionEnCours ? 'Suppression…' : 'Supprimer la sélection'}
            </button>
            <button className="btn" onClick={() => setSelection([])}>Tout décocher</button>
          </div>
        )}

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: 'auto', minWidth: '100%', borderCollapse: 'collapse', fontSize: 13, tableLayout: 'auto' }}>
              <thead>
                <tr style={{ textAlign: 'left' }}>
                  {/* Colonne actions unique et compacte */}
                  <th style={thCell({ textAlign: 'center', padding: '5px 6px' })}>
                    <input type="checkbox" checked={toutAfficheCoche} onChange={basculerToutAffiche}
                      style={{ width: 14, height: 14, cursor: 'pointer', verticalAlign: 'middle' }} />
                  </th>
                  {colonnes.map(col => (
                    <th key={col.id} style={thCell({ textAlign: col.align || 'left' })}>{col.label}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {articlesAffiches.map((article, index) => {
                  const stockBas = article.stock_min > 0 && article.stock < article.stock_min;
                  const fond = stockBas ? '#fff5f5' : index % 2 === 1 ? '#f9f9f7' : 'white';
                  return (
                    <tr key={article.id} style={{ background: fond }}>
                      {/* Cellule actions : checkbox + ✏️ + 🗑 dans une seule colonne étroite */}
                      <td style={tdCell({ padding: '2px 6px', textAlign: 'center', whiteSpace: 'nowrap' })}
                          onClick={e => e.stopPropagation()}>
                        <input type="checkbox" checked={selection.includes(article.id)}
                          onChange={() => basculerSelection(article.id)}
                          style={{ width: 13, height: 13, cursor: 'pointer', verticalAlign: 'middle' }} />
                        <span
                          title="Fiche complète"
                          onClick={() => ouvrirEditionComplete(article)}
                          style={{ marginLeft: 6, cursor: 'pointer', fontSize: 13, opacity: 0.7, userSelect: 'none' }}
                          onMouseEnter={e => e.target.style.opacity = 1}
                          onMouseLeave={e => e.target.style.opacity = 0.7}
                        >✏️</span>
                        <span
                          title="Supprimer"
                          onClick={() => demanderSuppression(article)}
                          style={{ marginLeft: 4, cursor: 'pointer', fontSize: 13, opacity: 0.5, userSelect: 'none' }}
                          onMouseEnter={e => e.target.style.opacity = 1}
                          onMouseLeave={e => e.target.style.opacity = 0.5}
                        >🗑️</span>
                      </td>
                      {colonnes.map(col => (
                        <td key={col.id} style={tdCell({ textAlign: col.align || 'left' })}>
                          {renderCell(article, col)}
                        </td>
                      ))}
                    </tr>
                  );
                })}
                {articlesAffiches.length === 0 && (
                  <tr>
                    <td colSpan={1 + colonnes.length} style={{ padding: 20, textAlign: 'center', color: '#888', border: BORDURE }}>
                      Aucun article ne correspond à la recherche
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {edition && (
        <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100, padding: 20 }}>
          <div style={{ background: 'white', borderRadius: 10, width: 720, maxWidth: '95vw', maxHeight: '92vh', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 16, padding: '14px 22px', borderBottom: '1px solid #e5e5e0', flexShrink: 0 }}>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" onClick={enregistrer}>{edition.id ? 'Enregistrer' : 'Créer'}</button>
                {edition.id && <button className="btn" onClick={dupliquerArticle}>Dupliquer</button>}
                {edition.id && <button className="btn" style={{ color: '#dc2626', borderColor: '#fca5a5' }} onClick={() => supprimer(edition)}>Supprimer</button>}
                <button className="btn" onClick={fermerFormulaire}>Annuler</button>
              </div>
              <div style={{ fontWeight: 600, fontSize: 16 }}>{edition.id ? 'Fiche article' : 'Nouvel article'}</div>
            </div>
            <div style={{ padding: 20, overflowY: 'auto' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Nom" style={{ flex: 3 }}><input style={inputStyle} value={edition.nom} onChange={e => majChamp('nom', e.target.value)} /></Champ>
                  <Champ label="Type d'article" style={{ flex: 2 }}><input style={inputStyle} value={edition.type_article || ''} onChange={e => majChamp('type_article', e.target.value)} /></Champ>
                  <Champ label="Ordre" style={{ width: 80 }}><input type="number" style={inputStyle} value={edition.ordre ?? ''} onChange={e => majChamp('ordre', e.target.value)} placeholder="—" /></Champ>
                </div>
                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Code de vente" style={{ flex: 1 }}>
                    <select style={inputStyle} value={edition.code_vente ?? ''} onChange={e => majChamp('code_vente', e.target.value)}>
                      <option value="">—</option>
                      {Object.entries(LIBELLES_CODE_VENTE).map(([code, lib]) => <option key={code} value={code}>{lib}</option>)}
                    </select>
                  </Champ>
                  {String(edition.code_vente) === String(CODE_VENTE_DEPENSE) ? (
                    <Champ label="Catégorie de dépense" style={{ flex: 2 }}>
                      {nouvelleCategorie ? (
                        <div style={{ display: 'flex', gap: 8 }}>
                          <input style={inputStyle} autoFocus value={edition.categorie || ''} onChange={e => majChamp('categorie', e.target.value)} placeholder="Nouvelle catégorie..." />
                          <button className="btn" onClick={() => { setNouvelleCategorie(false); majChamp('categorie', ''); }}>Liste</button>
                        </div>
                      ) : (
                        <select style={inputStyle} value={edition.categorie || ''} onChange={e => { if (e.target.value === '__NOUVELLE__') { setNouvelleCategorie(true); majChamp('categorie', ''); } else majChamp('categorie', e.target.value); }}>
                          <option value="">— Non classé —</option>
                          {categoriesDepense.map(c => <option key={c} value={c}>{c}</option>)}
                          <option value="__NOUVELLE__">+ Nouvelle catégorie…</option>
                        </select>
                      )}
                    </Champ>
                  ) : (
                    <Champ label="Fournisseur" style={{ flex: 1 }}><input style={inputStyle} value={edition.fournisseur || ''} onChange={e => majChamp('fournisseur', e.target.value)} /></Champ>
                  )}
                  <Champ label="EAN" style={{ flex: 1 }}><input style={inputStyle} value={edition.ean || ''} onChange={e => majChamp('ean', e.target.value)} /></Champ>
                  <Champ label="Localisation" style={{ flex: 1 }}><input style={inputStyle} value={edition.localisation || ''} onChange={e => majChamp('localisation', e.target.value)} /></Champ>
                </div>
                {String(edition.code_vente) === String(CODE_VENTE_DEPENSE) && (
                  <div style={{ display: 'flex', gap: 10 }}>
                    <Champ label="Fournisseur" style={{ flex: 1 }}><input style={inputStyle} value={edition.fournisseur || ''} onChange={e => majChamp('fournisseur', e.target.value)} /></Champ>
                    <div style={{ flex: 3 }} />
                  </div>
                )}
                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Prix vente" style={{ flex: 1 }}><input type="number" step="0.01" style={inputStyle} value={edition.prix_vente} onChange={e => majChamp('prix_vente', e.target.value)} /></Champ>
                  <Champ label="Prix emporter" style={{ flex: 1 }}><input type="number" step="0.01" style={inputStyle} value={edition.prix_vente_away ?? ''} onChange={e => majChamp('prix_vente_away', e.target.value)} placeholder="idem" /></Champ>
                  <Champ label="TVA % (place)" style={{ flex: 1 }}><input type="number" step="0.01" style={inputStyle} value={edition.tva} onChange={e => majChamp('tva', e.target.value)} /></Champ>
                  <Champ label="TVA % (emport.)" style={{ flex: 1 }}><input type="number" step="0.01" style={inputStyle} value={edition.tva_away ?? ''} onChange={e => majChamp('tva_away', e.target.value)} placeholder="idem" /></Champ>
                  <Champ label="Prix achat" style={{ flex: 1 }}><input type="number" step="0.01" style={inputStyle} value={edition.prix_achat} onChange={e => majChamp('prix_achat', e.target.value)} /></Champ>
                </div>
                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Stock" style={{ flex: 1 }}><input type="number" style={inputStyle} value={edition.stock} onChange={e => majChamp('stock', e.target.value)} /></Champ>
                  <Champ label="Stock min" style={{ flex: 1 }}><input type="number" style={inputStyle} value={edition.stock_min} onChange={e => majChamp('stock_min', e.target.value)} /></Champ>
                  <Champ label="Stock max" style={{ flex: 1 }}><input type="number" style={inputStyle} value={edition.stock_max} onChange={e => majChamp('stock_max', e.target.value)} /></Champ>
                  <div style={{ flex: 2 }} />
                </div>
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 4 }}>
                  {[
                    { champ: 'actif', label: 'Actif', color: '#dcfce7', border: '#86efac' },
                    { champ: 'stock_a_suivre', label: 'À suivre', color: '#dcfce7', border: '#86efac' },
                    { champ: 'est_boisson', label: 'Boisson', color: '#dcfce7', border: '#86efac' },
                    { champ: 'imprimer_cuisine', label: '🍳 Cuisine', color: '#fef3c7', border: '#fcd34d' },
                  ].map(({ champ, label, color, border }) => (
                    <label key={champ} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, padding: '6px 12px', borderRadius: 20, border: '1px solid', cursor: 'pointer', background: edition[champ] ? color : 'white', borderColor: edition[champ] ? border : '#ddd' }}>
                      <input type="checkbox" checked={!!edition[champ]} onChange={e => majChamp(champ, e.target.checked)} style={{ width: 14, height: 14 }} />
                      {label}
                    </label>
                  ))}
                </div>
                {edition.id && (
                  <div style={{ marginTop: 8, paddingTop: 12, borderTop: '1px solid #eee' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 8 }}>
                      <div style={{ fontSize: 12, color: '#888', fontWeight: 600, textTransform: 'uppercase', letterSpacing: 0.4 }}>Composition (coût matière)</div>
                      <button className="btn" onClick={ajouterComposant} style={{ fontSize: 12, padding: '4px 10px' }}>+ Composant</button>
                      <span style={{ marginLeft: 'auto', fontSize: 13, color: '#666' }}>Coût total : <strong>{totalComposants.toFixed(2)} €</strong></span>
                    </div>
                    {composantsChargement ? <div style={{ color: '#888', fontSize: 13 }}>Chargement...</div> : (
                      <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                        {composants.map((c, index) => (
                          <div key={c.id ?? 'new-' + index} style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                            <input type="text" placeholder="Ex: 5 scampis" value={c.description} onChange={e => modifierComposantChamp(index, 'description', e.target.value)} onBlur={() => sauverComposant(index)} style={{ ...inputStyle, flex: 1 }} />
                            <input type="number" step="0.01" value={c.prix} onChange={e => modifierComposantChamp(index, 'prix', e.target.value)} onBlur={() => sauverComposant(index)} style={{ ...inputStyle, width: 90, textAlign: 'right' }} />
                            <button className="btn" onClick={() => supprimerComposant(index)} style={{ width: 30, height: 30, padding: 0, fontSize: 12, color: '#dc2626', borderColor: '#fca5a5', flexShrink: 0 }}>✕</button>
                          </div>
                        ))}
                        {composants.length === 0 && <div style={{ color: '#aaa', fontSize: 13 }}>Aucun composant — utilise "Prix d'achat".</div>}
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function Champ({ label, children, style }) {
  return (
    <div style={style}>
      <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>{label}</div>
      {children}
    </div>
  );
}

const inputStyle = { width: '100%', padding: '7px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box' };
