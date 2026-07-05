import { useState, useEffect } from 'react';
import api from '../api/api';

const CODE_VENTE_DEPENSE = 9001;

// Bordure de quadrillage commune à toutes les cellules du tableau
const BORDURE = '1px solid #e5e5e0';

const ARTICLE_VIDE = {
  nom: '',
  categorie: '',
  type_article: '',
  code_vente: '',
  tva: 21,
  tva_away: '',
  prix_achat: 0,
  prix_vente: 0,
  prix_vente_away: '',
  stock: 0,
  stock_min: 0,
  stock_max: 0,
  stock_a_suivre: false,
  est_boisson: false,
  imprimer_cuisine: false,
  ordre: '',
  ean: '',
  fournisseur: '',
  localisation: '',
  actif: true,
};

const LIBELLES_CODE_VENTE = {
  7001: 'Boissons Alcools',
  7002: 'Nourriture',
  7003: 'Boissons Softs',
  7004: 'Boissons Vins',
  7005: 'Divers',
  9001: 'Dépenses',
};

export default function Articles() {
  const [articles, setArticles] = useState([]);
  const [recherche, setRecherche] = useState('');
  const [filtreType, setFiltreType] = useState('');
  const [filtreCodeVente, setFiltreCodeVente] = useState('');
  const [filtreASuivre, setFiltreASuivre] = useState(false);
  const [filtreBoisson, setFiltreBoisson] = useState(false);
  const [edition, setEdition] = useState(null); // null = pas de formulaire ouvert, sinon = objet article (ou ARTICLE_VIDE pour créer)
  const [nouvelleCategorie, setNouvelleCategorie] = useState(false); // true = saisie libre d'une nouvelle catégorie de dépense
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selection, setSelection] = useState([]); // ids des articles cochés
  const [suppressionEnCours, setSuppressionEnCours] = useState(false);
  const [composants, setComposants] = useState([]); // lignes de recette (description + prix) du plat en édition
  const [composantsChargement, setComposantsChargement] = useState(false);

  const load = () => {
    setLoading(true);
    api.get('/articles/')
      .then(r => setArticles(r.data))
      .catch(() => setError('Impossible de charger les articles'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const types = [...new Set(articles.map(a => a.type_article).filter(Boolean))].sort();

  // Codes de vente réellement présents dans les articles, triés
  const codesVente = [...new Set(articles.map(a => a.code_vente).filter(c => c != null))]
    .sort((a, b) => a - b);

  // Catégories de dépense déjà saisies (pour la liste déroulante), triées
  const categoriesDepense = [...new Set(
    articles
      .filter(a => a.code_vente === CODE_VENTE_DEPENSE)
      .map(a => a.categorie)
      .filter(Boolean)
  )].sort((a, b) => a.localeCompare(b, 'fr'));

  const articlesAffiches = articles.filter(a =>
    (a.nom.toLowerCase().includes(recherche.toLowerCase()) ||
      (a.type_article || '').toLowerCase().includes(recherche.toLowerCase())) &&
    (filtreType === '' || a.type_article === filtreType) &&
    (filtreCodeVente === '' || String(a.code_vente) === filtreCodeVente) &&
    (!filtreASuivre || a.stock_a_suivre) &&
    (!filtreBoisson || a.est_boisson)
  );

  const ouvrirCreation = () => { setNouvelleCategorie(false); setComposants([]); setEdition({ ...ARTICLE_VIDE }); };

  const ouvrirEdition = async (article) => {
    setNouvelleCategorie(false);
    setEdition({ ...article });
    setComposants([]);
    setComposantsChargement(true);
    try {
      const res = await api.get('/articles-composants/', { params: { article_id: article.id } });
      setComposants(res.data);
    } catch (e) {
      // Silencieux : la composition est secondaire, ne bloque pas l'édition de la fiche
    } finally {
      setComposantsChargement(false);
    }
  };

  const fermerFormulaire = () => { setNouvelleCategorie(false); setEdition(null); setComposants([]); };

  // Ajoute une ligne de composant vide localement (pas encore enregistrée en
  // base tant que la description n'est pas remplie et qu'on ne quitte pas le champ).
  const ajouterComposant = () => {
    setComposants(prev => [...prev, { id: null, description: '', prix: 0 }]);
  };

  const modifierComposantChamp = (index, champ, valeur) => {
    setComposants(prev => prev.map((c, i) => i === index ? { ...c, [champ]: valeur } : c));
  };

  // Enregistre une ligne de composant (création si nouvelle, mise à jour sinon).
  // N'enregistre rien si la description est vide (ligne abandonnée).
  const sauverComposant = async (index) => {
    const ligne = composants[index];
    if (!ligne.description || !ligne.description.trim()) return;
    try {
      if (ligne.id) {
        const res = await api.patch('/articles-composants/' + ligne.id, {
          description: ligne.description,
          prix: Number(String(ligne.prix).replace(',', '.')) || 0,
        });
        setComposants(prev => prev.map((c, i) => i === index ? res.data : c));
      } else {
        const res = await api.post('/articles-composants/', {
          article_id: edition.id,
          description: ligne.description,
          prix: Number(String(ligne.prix).replace(',', '.')) || 0,
        });
        setComposants(prev => prev.map((c, i) => i === index ? res.data : c));
      }
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement du composant");
    }
  };

  const supprimerComposant = async (index) => {
    const ligne = composants[index];
    if (ligne.id) {
      try {
        await api.delete('/articles-composants/' + ligne.id);
      } catch (e) {
        setError(e.response?.data?.detail || 'Erreur lors de la suppression du composant');
        return;
      }
    }
    setComposants(prev => prev.filter((_, i) => i !== index));
  };

  const totalComposants = composants.reduce((s, c) => s + (Number(c.prix) || 0), 0);

  // Duplique l'article en cours d'édition : bascule le formulaire en mode
  // création (id retiré) avec les mêmes valeurs, nom suffixé "(copie)" pour
  // éviter toute confusion si on enregistre sans y toucher.
  const dupliquerArticle = () => {
    setNouvelleCategorie(false);
    setComposants([]);
    setEdition(prev => ({ ...prev, id: undefined, nom: prev.nom + ' (copie)' }));
  };

  const majChamp = (champ, valeur) => setEdition(prev => ({ ...prev, [champ]: valeur }));

  const enregistrer = async () => {
    setError('');
    const payload = {
      ...edition,
      categorie: edition.categorie === '' ? null : edition.categorie,
      code_vente: edition.code_vente === '' ? null : Number(edition.code_vente),
      tva: Number(edition.tva),
      tva_away: edition.tva_away === '' ? null : Number(edition.tva_away),
      prix_achat: Number(edition.prix_achat),
      prix_vente: Number(edition.prix_vente),
      prix_vente_away: edition.prix_vente_away === '' ? null : Number(edition.prix_vente_away),
      stock: Number(edition.stock),
      stock_min: Number(edition.stock_min),
      stock_max: Number(edition.stock_max),
      ordre: edition.ordre === '' || edition.ordre === null || edition.ordre === undefined ? null : Number(edition.ordre),
    };

    try {
      if (edition.id) {
        await api.patch('/articles/' + edition.id, payload);
        setMsg({ type: 'success', text: 'Article mis à jour' });
      } else {
        await api.post('/articles/', payload);
        setMsg({ type: 'success', text: 'Article créé' });
      }
      setEdition(null);
      load();
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement");
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const demanderSuppression = (article) => {
    if (window.confirm('Supprimer définitivement « ' + article.nom + ' » ?')) {
      supprimer(article);
    }
  };

  const supprimer = async (article) => {
    setError('');
    try {
      await api.delete('/articles/' + article.id);
      setMsg({ type: 'success', text: 'Article supprimé' });
      setEdition(null);
      load();
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la suppression');
    }
    setTimeout(() => setMsg(null), 3000);
  };

  // Changement de catégorie directement depuis le tableau (dépenses), enregistré aussitôt
  const changerCategorieLigne = async (article, nouvelleCat) => {
    setError('');
    const valeur = nouvelleCat === '' ? null : nouvelleCat;
    try {
      const res = await api.patch('/articles/' + article.id, { categorie: valeur });
      setArticles(prev => prev.map(a => a.id === article.id ? { ...a, categorie: res.data.categorie } : a));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors du changement de catégorie');
    }
  };

  // Changement de l'ordre d'affichage directement depuis le tableau, enregistré
  // à la perte de focus. Champ vide = pas d'ordre défini (null).
  const changerOrdreLigne = async (article, nouvelOrdreStr) => {
    setError('');
    const valeur = nouvelOrdreStr === '' ? null : Number(nouvelOrdreStr);
    if (valeur !== null && !Number.isInteger(valeur)) return;
    try {
      const res = await api.patch('/articles/' + article.id, { ordre: valeur });
      setArticles(prev => prev.map(a => a.id === article.id ? { ...a, ordre: res.data.ordre } : a));
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors du changement de l'ordre");
    }
  };

  // ───── Sélection multiple ────────────────────────────────────────────────
  const basculerSelection = (id) => {
    setSelection(prev =>
      prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]
    );
  };

  // Ids actuellement affichés (après filtres)
  const idsAffiches = articlesAffiches.map(a => a.id);
  const toutAfficheCoche = idsAffiches.length > 0 && idsAffiches.every(id => selection.includes(id));

  const basculerToutAffiche = () => {
    if (toutAfficheCoche) {
      // décoche uniquement ce qui est affiché
      setSelection(prev => prev.filter(id => !idsAffiches.includes(id)));
    } else {
      // coche tout ce qui est affiché (en gardant d'éventuels cochés hors filtre)
      setSelection(prev => [...new Set([...prev, ...idsAffiches])]);
    }
  };

  const supprimerSelection = async () => {
    if (selection.length === 0) return;
    if (!window.confirm('Supprimer définitivement ' + selection.length + ' article(s) ? Cette action est irréversible.')) {
      return;
    }
    setError('');
    setSuppressionEnCours(true);
    let echecs = 0;
    // L'API supprime un article à la fois : on enchaîne les suppressions.
    for (const id of selection) {
      try {
        await api.delete('/articles/' + id);
      } catch (e) {
        echecs++;
      }
    }
    setSuppressionEnCours(false);
    setSelection([]);
    if (echecs === 0) {
      setMsg({ type: 'success', text: 'Articles supprimés' });
    } else {
      setMsg({ type: 'error', text: echecs + ' suppression(s) ont échoué' });
    }
    load();
    setTimeout(() => setMsg(null), 4000);
  };

  // Styles de cellules avec quadrillage
  const thCell = (extra = {}) => ({ padding: '6px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });

  const escapeHtml = (s) =>
    String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  // Imprime, sur un ticket thermique 80mm, la liste des articles actuellement
  // affichés (recherche + filtres en cours), avec nom, stock et stock min —
  // pour faciliter un inventaire physique (ex: boissons uniquement).
  const imprimerInventaire = () => {
    if (articlesAffiches.length === 0) {
      setMsg({ type: 'error', text: 'Aucun article à imprimer avec les filtres actuels' });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    const lignesHtml = [...articlesAffiches]
      .sort((a, b) => a.nom.localeCompare(b.nom, 'fr', { numeric: true }))
      .map(a => (
        '<tr>'
        + '<td class="nom">' + escapeHtml(a.nom) + '</td>'
        + '<td class="chiffre">' + a.stock + '</td>'
        + '<td class="chiffre">' + a.stock_min + '</td>'
        + '</tr>'
      )).join('');

    const fenetre = window.open('', '_blank', 'width=400,height=600');
    if (!fenetre) {
      setMsg({ type: 'error', text: "Impossible d'ouvrir la fenêtre d'impression (pop-up bloqué ?)" });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    fenetre.document.write(`
      <html>
        <head>
          <meta charset="utf-8" />
          <title>Inventaire</title>
          <style>
            @page { size: 72mm auto; margin: 2mm; }
            body { font-family: 'Courier New', monospace; width: 68mm; margin: 0; padding: 4px; }
            h1 { font-size: 15px; text-align: center; margin: 0 0 4px; }
            .date { font-size: 11px; text-align: center; margin-bottom: 8px; color: #333; }
            hr { border: none; border-top: 1px dashed #000; margin: 6px 0; }
            table { width: 100%; border-collapse: collapse; font-size: 11px; }
            th { text-align: left; font-size: 10px; border-bottom: 1px solid #000; padding: 2px 0; }
            .chiffre { text-align: right; white-space: nowrap; }
            th.chiffre { text-align: right; }
            td.nom { padding: 2px 4px 2px 0; }
            td.chiffre { padding: 2px 0; }
          </style>
        </head>
        <body>
          <h1>📋 INVENTAIRE</h1>
          <div class="date">${new Date().toLocaleDateString('fr-BE', { weekday: 'long', day: 'numeric', month: 'long' })}</div>
          <hr />
          <table>
            <thead><tr><th>Article</th><th class="chiffre">Stock</th><th class="chiffre">Min</th></tr></thead>
            <tbody>${lignesHtml}</tbody>
          </table>
        </body>
      </html>
    `);
    fenetre.document.close();
    fenetre.focus();
    setTimeout(() => { fenetre.print(); }, 250);
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
            {articles.length} article{articles.length !== 1 ? 's' : ''}
          </span>
          <button className="btn" onClick={ouvrirCreation}>+ Nouvel article</button>
          <input
            type="text"
            placeholder="Rechercher par nom ou type..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
            style={{
              flex: 1,
              minWidth: 200,
              padding: '10px 14px',
              borderRadius: 8,
              border: '1px solid #ddd',
              fontSize: 14,
            }}
          />
          <select
            value={filtreCodeVente}
            onChange={(e) => setFiltreCodeVente(e.target.value)}
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          >
            <option value="">Tous les codes de vente</option>
            {codesVente.map(c => (
              <option key={c} value={String(c)}>{LIBELLES_CODE_VENTE[c] || c}</option>
            ))}
          </select>
          <select
            value={filtreType}
            onChange={(e) => setFiltreType(e.target.value)}
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          >
            <option value="">Tous les types</option>
            {types.map(t => <option key={t} value={t}>{t}</option>)}
          </select>
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer', padding: '0 4px' }}>
            <input
              type="checkbox"
              checked={filtreASuivre}
              onChange={(e) => setFiltreASuivre(e.target.checked)}
              style={{ width: 16, height: 16 }}
            />
            À suivre uniquement
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer', padding: '0 4px' }}>
            <input
              type="checkbox"
              checked={filtreBoisson}
              onChange={(e) => setFiltreBoisson(e.target.checked)}
              style={{ width: 16, height: 16 }}
            />
            Boissons uniquement
          </label>
          <button
            className="btn"
            onClick={imprimerInventaire}
            title="Imprime la liste actuellement affichée (nom, stock, stock min) sur un ticket, pour l'inventaire"
          >
            🖨️ Imprimer inventaire
          </button>
        </div>

        {selection.length > 0 && (
          <div style={{
            display: 'flex', alignItems: 'center', gap: 12,
            padding: '10px 16px', marginBottom: 12, borderRadius: 8,
            background: '#fef3c7', border: '1px solid #fcd34d',
          }}>
            <span style={{ fontSize: 13, fontWeight: 600, color: '#92400e' }}>
              {selection.length} article{selection.length > 1 ? 's' : ''} sélectionné{selection.length > 1 ? 's' : ''}
            </span>
            <button
              className="btn"
              disabled={suppressionEnCours}
              style={{ color: '#dc2626', borderColor: '#fca5a5', fontWeight: 600 }}
              onClick={supprimerSelection}
            >
              {suppressionEnCours ? 'Suppression…' : 'Supprimer la sélection'}
            </button>
            <button
              className="btn"
              disabled={suppressionEnCours}
              onClick={() => setSelection([])}
            >
              Tout décocher
            </button>
          </div>
        )}

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}>
                    <input
                      type="checkbox"
                      checked={toutAfficheCoche}
                      onChange={basculerToutAffiche}
                      title="Tout sélectionner (lignes affichées)"
                      style={{ width: 16, height: 16, cursor: 'pointer' }}
                    />
                  </th>
                  <th style={thCell()}></th>
                  <th style={thCell()}>ID</th>
                  <th style={thCell()} title="Ordre d'affichage des boutons dans le Caddy">Ordre</th>
                  <th style={thCell()}>Nom</th>
                  <th style={thCell()}>Type</th>
                  <th style={thCell()}>Code vente</th>
                  <th style={thCell()}>Catégorie</th>
                  <th style={thCell({ textAlign: 'right' })}>Prix vente</th>
                  <th style={thCell({ textAlign: 'right' })}>Stock</th>
                  <th style={thCell({ textAlign: 'right' })}>Stock min</th>
                  <th style={thCell()}>À suivre</th>
                  <th style={thCell()}>Boisson</th>
                  <th style={thCell()} title="Imprimé sur le ticket cuisine">Cuisine</th>
                  <th style={thCell()}>Actif</th>
                </tr>
              </thead>
              <tbody>
                {articlesAffiches.map((article, index) => {
                  const stockBas = article.stock_min > 0 && article.stock < article.stock_min;
                  const fondAlterne = index % 2 === 1 ? '#f0f0ec' : 'transparent';
                  const fondLigne = stockBas ? '#fee2e2' : fondAlterne;
                  return (
                    <tr
                      key={article.id}
                      onClick={() => ouvrirEdition(article)}
                      style={{
                        cursor: 'pointer',
                        background: fondLigne,
                      }}
                    >
                      <td style={tdCell()} onClick={(e) => e.stopPropagation()}>
                        <input
                          type="checkbox"
                          checked={selection.includes(article.id)}
                          onChange={() => basculerSelection(article.id)}
                          style={{ width: 16, height: 16, cursor: 'pointer' }}
                        />
                      </td>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <button
                          className="btn"
                          title="Supprimer cet article"
                          style={{ color: '#dc2626', borderColor: '#fca5a5', fontSize: 14, padding: '2px 8px', lineHeight: 1 }}
                          onClick={(e) => { e.stopPropagation(); demanderSuppression(article); }}
                        >
                          🗑
                        </button>
                      </td>
                      <td style={tdCell({ color: '#aaa' })}>{article.id}</td>
                      <td style={tdCell()} onClick={(e) => e.stopPropagation()}>
                        <input
                          type="number"
                          defaultValue={article.ordre ?? ''}
                          placeholder="—"
                          onBlur={(e) => changerOrdreLigne(article, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{
                            width: 52, padding: '3px 6px', borderRadius: 6,
                            border: '1px solid #ddd', fontSize: 12, textAlign: 'right',
                          }}
                        />
                      </td>
                      <td style={tdCell({ fontWeight: 500 })}>{article.nom}</td>
                      <td style={tdCell({ color: '#666' })}>{article.type_article || '—'}</td>
                      <td style={tdCell({ color: '#666' })}>{LIBELLES_CODE_VENTE[article.code_vente] || article.code_vente || '—'}</td>
                      <td style={tdCell()} onClick={(e) => e.stopPropagation()}>
                        {article.code_vente === CODE_VENTE_DEPENSE ? (
                          <select
                            value={article.categorie || ''}
                            onChange={(e) => changerCategorieLigne(article, e.target.value)}
                            style={{
                              fontSize: 12,
                              padding: '3px 6px',
                              borderRadius: 6,
                              border: '1px solid #ddd',
                              background: 'white',
                              color: article.categorie ? '#333' : '#b45309',
                              fontStyle: article.categorie ? 'normal' : 'italic',
                              cursor: 'pointer',
                              maxWidth: 160,
                            }}
                          >
                            <option value="">Non classé</option>
                            {categoriesDepense.map(c => (
                              <option key={c} value={c} style={{ color: '#333', fontStyle: 'normal' }}>{c}</option>
                            ))}
                          </select>
                        ) : (
                          <span style={{ color: '#ccc' }}>—</span>
                        )}
                      </td>
                      <td style={tdCell({ textAlign: 'right', whiteSpace: 'nowrap' })}>{Number(article.prix_vente).toFixed(2)} €</td>
                      <td style={tdCell({ textAlign: 'right', color: stockBas ? '#dc2626' : 'inherit', fontWeight: stockBas ? 600 : 400 })}>{article.stock}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#666' })}>{article.stock_min}</td>
                      <td style={tdCell()}>{article.stock_a_suivre ? '✓' : ''}</td>
                      <td style={tdCell()}>{article.est_boisson ? '✓' : ''}</td>
                      <td style={tdCell()}>{article.imprimer_cuisine ? '✓' : ''}</td>
                      <td style={tdCell()}>
                        <span style={{
                          display: 'inline-block',
                          width: 10, height: 10, borderRadius: '50%',
                          background: article.actif ? '#22c55e' : '#9ca3af',
                        }} />
                      </td>
                    </tr>
                  );
                })}
                {articlesAffiches.length === 0 && (
                  <tr>
                    <td colSpan={15} style={{ padding: 20, textAlign: 'center', color: '#888', border: BORDURE }}>
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
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
          padding: 20,
        }}>
          <div style={{
            background: 'white', borderRadius: 10, width: 720, maxWidth: '95vw', maxHeight: '92vh',
            display: 'flex', flexDirection: 'column', overflow: 'hidden',
          }}>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 16,
              padding: '14px 22px', borderBottom: '1px solid #e5e5e0', flexShrink: 0,
            }}>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" onClick={enregistrer}>
                  {edition.id ? 'Enregistrer' : 'Créer'}
                </button>
                {edition.id && (
                  <button className="btn" onClick={dupliquerArticle}>
                    Dupliquer
                  </button>
                )}
                {edition.id && (
                  <button
                    className="btn"
                    style={{ color: '#dc2626', borderColor: '#fca5a5' }}
                    onClick={() => supprimer(edition)}
                  >
                    Supprimer
                  </button>
                )}
                <button className="btn" onClick={fermerFormulaire}>Annuler</button>
              </div>
              <div style={{ fontWeight: 600, fontSize: 16 }}>
                {edition.id ? 'Modifier l\u2019article' : 'Nouvel article'}
              </div>
            </div>

            <div style={{ padding: 20, overflowY: 'auto' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>

              <div style={{ display: 'flex', gap: 10 }}>
                <Champ label="Nom" style={{ flex: 3 }}>
                  <input style={inputStyle} value={edition.nom} onChange={e => majChamp('nom', e.target.value)} />
                </Champ>
                <Champ label="Type d'article" style={{ flex: 2 }}>
                  <input style={inputStyle} value={edition.type_article || ''} onChange={e => majChamp('type_article', e.target.value)} placeholder="2. APERITIF..." />
                </Champ>
                <Champ label="Ordre" style={{ width: 80 }}>
                  <input
                    type="number"
                    style={inputStyle}
                    value={edition.ordre ?? ''}
                    onChange={e => majChamp('ordre', e.target.value)}
                    placeholder="—"
                    title="Ordre des boutons dans le Caddy. Vide = après les articles avec ordre, triés par nom."
                  />
                </Champ>
              </div>

              <div style={{ display: 'flex', gap: 10 }}>
                <Champ label="Code de vente" style={{ flex: 1 }}>
                  <select
                    style={inputStyle}
                    value={edition.code_vente ?? ''}
                    onChange={e => majChamp('code_vente', e.target.value)}
                  >
                    <option value="">—</option>
                    {Object.entries(LIBELLES_CODE_VENTE).map(([code, libelle]) => (
                      <option key={code} value={code}>{libelle}</option>
                    ))}
                  </select>
                </Champ>
                {String(edition.code_vente) === String(CODE_VENTE_DEPENSE) ? (
                  <Champ label="Catégorie de dépense" style={{ flex: 2 }}>
                    {nouvelleCategorie ? (
                      <div style={{ display: 'flex', gap: 8 }}>
                        <input
                          style={inputStyle}
                          autoFocus
                          value={edition.categorie || ''}
                          onChange={e => majChamp('categorie', e.target.value)}
                          placeholder="Ex: Charges fixes, Magasins, Divers..."
                        />
                        <button
                          className="btn"
                          type="button"
                          onClick={() => { setNouvelleCategorie(false); majChamp('categorie', ''); }}
                        >
                          Liste
                        </button>
                      </div>
                    ) : (
                      <select
                        style={inputStyle}
                        value={edition.categorie || ''}
                        onChange={e => {
                          if (e.target.value === '__NOUVELLE__') {
                            setNouvelleCategorie(true);
                            majChamp('categorie', '');
                          } else {
                            majChamp('categorie', e.target.value);
                          }
                        }}
                      >
                        <option value="">— Non classé —</option>
                        {categoriesDepense.map(c => (
                          <option key={c} value={c}>{c}</option>
                        ))}
                        <option value="__NOUVELLE__">+ Nouvelle catégorie…</option>
                      </select>
                    )}
                  </Champ>
                ) : (
                  <Champ label="Fournisseur" style={{ flex: 1 }}>
                    <input style={inputStyle} value={edition.fournisseur || ''} onChange={e => majChamp('fournisseur', e.target.value)} />
                  </Champ>
                )}
                <Champ label="EAN" style={{ flex: 1 }}>
                  <input style={inputStyle} value={edition.ean || ''} onChange={e => majChamp('ean', e.target.value)} />
                </Champ>
                <Champ label="Localisation" style={{ flex: 1 }}>
                  <input style={inputStyle} value={edition.localisation || ''} onChange={e => majChamp('localisation', e.target.value)} />
                </Champ>
              </div>

              {/* Si code de vente = Dépenses, le fournisseur n'a pas de champ dédié ci-dessus
                  (remplacé par la catégorie) : on le montre sur sa propre ligne dans ce cas. */}
              {String(edition.code_vente) === String(CODE_VENTE_DEPENSE) && (
                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Fournisseur" style={{ flex: 1 }}>
                    <input style={inputStyle} value={edition.fournisseur || ''} onChange={e => majChamp('fournisseur', e.target.value)} />
                  </Champ>
                  <div style={{ flex: 3 }} />
                </div>
              )}

              <div style={{ display: 'flex', gap: 10 }}>
                <Champ label="Prix vente (sur place)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.prix_vente} onChange={e => majChamp('prix_vente', e.target.value)} />
                </Champ>
                <Champ label="Prix vente (à emporter)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.prix_vente_away ?? ''} onChange={e => majChamp('prix_vente_away', e.target.value)} placeholder="idem" />
                </Champ>
                <Champ label="TVA sur place (%)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.tva} onChange={e => majChamp('tva', e.target.value)} />
                </Champ>
                <Champ label="TVA à emporter (%)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.tva_away ?? ''} onChange={e => majChamp('tva_away', e.target.value)} placeholder="idem" />
                </Champ>
                <Champ label="Prix d'achat" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.prix_achat} onChange={e => majChamp('prix_achat', e.target.value)} />
                </Champ>
              </div>

              <div style={{ display: 'flex', gap: 10 }}>
                <Champ label="Stock" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock} onChange={e => majChamp('stock', e.target.value)} />
                </Champ>
                <Champ label="Stock min" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock_min} onChange={e => majChamp('stock_min', e.target.value)} />
                </Champ>
                <Champ label="Stock max" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock_max} onChange={e => majChamp('stock_max', e.target.value)} />
                </Champ>
                <div style={{ flex: 2 }} />
              </div>

              {/* Cases à cocher regroupées sur une seule ligne compacte plutôt qu'empilées */}
              <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 4 }}>
                <label style={{
                  display: 'flex', alignItems: 'center', gap: 6, fontSize: 13,
                  padding: '6px 12px', borderRadius: 20, border: '1px solid #ddd', cursor: 'pointer',
                  background: edition.actif ? '#dcfce7' : 'white',
                  borderColor: edition.actif ? '#86efac' : '#ddd',
                }}>
                  <input
                    type="checkbox"
                    checked={edition.actif}
                    onChange={e => majChamp('actif', e.target.checked)}
                    style={{ width: 14, height: 14 }}
                  />
                  Actif
                </label>

                <label style={{
                  display: 'flex', alignItems: 'center', gap: 6, fontSize: 13,
                  padding: '6px 12px', borderRadius: 20, border: '1px solid #ddd', cursor: 'pointer',
                  background: edition.stock_a_suivre ? '#dcfce7' : 'white',
                  borderColor: edition.stock_a_suivre ? '#86efac' : '#ddd',
                }}>
                  <input
                    type="checkbox"
                    checked={edition.stock_a_suivre || false}
                    onChange={e => majChamp('stock_a_suivre', e.target.checked)}
                    style={{ width: 14, height: 14 }}
                  />
                  À suivre
                </label>

                <label style={{
                  display: 'flex', alignItems: 'center', gap: 6, fontSize: 13,
                  padding: '6px 12px', borderRadius: 20, border: '1px solid #ddd', cursor: 'pointer',
                  background: edition.est_boisson ? '#dcfce7' : 'white',
                  borderColor: edition.est_boisson ? '#86efac' : '#ddd',
                }}>
                  <input
                    type="checkbox"
                    checked={edition.est_boisson || false}
                    onChange={e => majChamp('est_boisson', e.target.checked)}
                    style={{ width: 14, height: 14 }}
                  />
                  Boisson
                </label>

                <label style={{
                  display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, fontWeight: 600,
                  padding: '6px 12px', borderRadius: 20, border: '1px solid #fcd34d', cursor: 'pointer',
                  background: edition.imprimer_cuisine ? '#fef3c7' : 'white',
                }}>
                  <input
                    type="checkbox"
                    checked={edition.imprimer_cuisine || false}
                    onChange={e => majChamp('imprimer_cuisine', e.target.checked)}
                    style={{ width: 14, height: 14 }}
                  />
                  🍳 Imprimer en cuisine
                </label>
              </div>

              {/* Composition (coût matière) : uniquement pour un article existant */}
              {edition.id && (
                <div style={{ marginTop: 8, paddingTop: 12, borderTop: '1px solid #eee' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 8 }}>
                    <div style={{ fontSize: 12, color: '#888', fontWeight: 600, textTransform: 'uppercase', letterSpacing: 0.4 }}>
                      Composition (coût matière)
                    </div>
                    <button className="btn" onClick={ajouterComposant} style={{ fontSize: 12, padding: '4px 10px' }}>
                      + Composant
                    </button>
                    <span style={{ marginLeft: 'auto', fontSize: 13, color: '#666' }}>
                      Coût total : <strong style={{ color: '#111' }}>{totalComposants.toFixed(2)} €</strong>
                    </span>
                  </div>

                  {composantsChargement ? (
                    <div style={{ color: '#888', fontSize: 13 }}>Chargement...</div>
                  ) : (
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                      {composants.map((c, index) => (
                        <div key={c.id ?? 'new-' + index} style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                          <input
                            type="text"
                            placeholder="Ex: 5 scampis"
                            value={c.description}
                            onChange={(e) => modifierComposantChamp(index, 'description', e.target.value)}
                            onBlur={() => sauverComposant(index)}
                            style={{ ...inputStyle, flex: 1 }}
                          />
                          <input
                            type="number"
                            step="0.01"
                            placeholder="Prix"
                            value={c.prix}
                            onChange={(e) => modifierComposantChamp(index, 'prix', e.target.value)}
                            onBlur={() => sauverComposant(index)}
                            style={{ ...inputStyle, width: 90, textAlign: 'right' }}
                          />
                          <button
                            className="btn"
                            title="Supprimer ce composant"
                            onClick={() => supprimerComposant(index)}
                            style={{ width: 30, height: 30, padding: 0, fontSize: 12, color: '#dc2626', borderColor: '#fca5a5', flexShrink: 0 }}
                          >
                            ✕
                          </button>
                        </div>
                      ))}
                      {composants.length === 0 && (
                        <div style={{ color: '#aaa', fontSize: 13 }}>
                          Aucun composant — le coût matière utilisera "Prix d'achat" ci-dessus.
                        </div>
                      )}
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

const inputStyle = {
  width: '100%',
  padding: '7px 10px',
  borderRadius: 6,
  border: '1px solid #ddd',
  fontSize: 14,
  boxSizing: 'border-box',
};