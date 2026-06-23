import { useState, useEffect } from 'react';
import api from '../api/api';

const CODE_VENTE_DEPENSE = 9001;

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
  const [edition, setEdition] = useState(null); // null = pas de formulaire ouvert, sinon = objet article (ou ARTICLE_VIDE pour créer)
  const [nouvelleCategorie, setNouvelleCategorie] = useState(false); // true = saisie libre d'une nouvelle catégorie de dépense
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selection, setSelection] = useState([]); // ids des articles cochés
  const [suppressionEnCours, setSuppressionEnCours] = useState(false);

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
    (!filtreASuivre || a.stock_a_suivre)
  );

  const ouvrirCreation = () => { setNouvelleCategorie(false); setEdition({ ...ARTICLE_VIDE }); };
  const ouvrirEdition = (article) => { setNouvelleCategorie(false); setEdition({ ...article }); };
  const fermerFormulaire = () => { setNouvelleCategorie(false); setEdition(null); };

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
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'hidden' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={{ padding: '6px 14px' }}>
                    <input
                      type="checkbox"
                      checked={toutAfficheCoche}
                      onChange={basculerToutAffiche}
                      title="Tout sélectionner (lignes affichées)"
                      style={{ width: 16, height: 16, cursor: 'pointer' }}
                    />
                  </th>
                  <th style={{ padding: '6px 14px' }}></th>
                  <th style={{ padding: '6px 14px' }}>ID</th>
                  <th style={{ padding: '6px 14px' }}>Nom</th>
                  <th style={{ padding: '6px 14px' }}>Type</th>
                  <th style={{ padding: '6px 14px' }}>Code vente</th>
                  <th style={{ padding: '6px 14px' }}>Catégorie</th>
                  <th style={{ padding: '6px 14px', textAlign: 'right' }}>Prix vente</th>
                  <th style={{ padding: '6px 14px', textAlign: 'right' }}>Stock</th>
                  <th style={{ padding: '6px 14px', textAlign: 'right' }}>Stock min</th>
                  <th style={{ padding: '6px 14px' }}>À suivre</th>
                  <th style={{ padding: '6px 14px' }}>Boisson</th>
                  <th style={{ padding: '6px 14px' }}>Actif</th>
                </tr>
              </thead>
              <tbody>
                {articlesAffiches.map((article, index) => {
                  const stockBas = article.stock_min > 0 && article.stock < article.stock_min;
                  const fondAlterne = index % 2 === 1 ? '#f0f0ec' : 'transparent';
                  return (
                    <tr
                      key={article.id}
                      onClick={() => ouvrirEdition(article)}
                      style={{
                        borderTop: '1px solid #f0f0ee',
                        cursor: 'pointer',
                        background: stockBas ? '#fee2e2' : fondAlterne,
                      }}
                    >
                      <td style={{ padding: '4px 14px' }} onClick={(e) => e.stopPropagation()}>
                        <input
                          type="checkbox"
                          checked={selection.includes(article.id)}
                          onChange={() => basculerSelection(article.id)}
                          style={{ width: 16, height: 16, cursor: 'pointer' }}
                        />
                      </td>
                      <td style={{ padding: '4px 14px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                          <button
                            className="btn"
                            style={{ color: '#dc2626', borderColor: '#fca5a5', fontSize: 12, padding: '2px 8px' }}
                            onClick={(e) => { e.stopPropagation(); demanderSuppression(article); }}
                          >
                            Supprimer
                          </button>
                          <span style={{ color: '#888', fontSize: 12 }}>Modifier →</span>
                        </div>
                      </td>
                      <td style={{ padding: '4px 14px', color: '#aaa' }}>{article.id}</td>
                      <td style={{ padding: '4px 14px', fontWeight: 500 }}>{article.nom}</td>
                      <td style={{ padding: '4px 14px', color: '#666' }}>{article.type_article || '—'}</td>
                      <td style={{ padding: '4px 14px', color: '#666' }}>{LIBELLES_CODE_VENTE[article.code_vente] || article.code_vente || '—'}</td>
                      <td style={{ padding: '4px 14px' }}>
                        {article.code_vente === CODE_VENTE_DEPENSE
                          ? (article.categorie
                              ? <span style={{ color: '#666' }}>{article.categorie}</span>
                              : <span style={{ color: '#b45309', fontStyle: 'italic' }}>Non classé</span>)
                          : <span style={{ color: '#ccc' }}>—</span>}
                      </td>
                      <td style={{ padding: '4px 14px', textAlign: 'right' }}>{Number(article.prix_vente).toFixed(2)} €</td>
                      <td style={{ padding: '4px 14px', textAlign: 'right', color: stockBas ? '#dc2626' : 'inherit', fontWeight: stockBas ? 600 : 400 }}>{article.stock}</td>
                      <td style={{ padding: '4px 14px', textAlign: 'right', color: '#666' }}>{article.stock_min}</td>
                      <td style={{ padding: '4px 14px' }}>{article.stock_a_suivre ? '✓' : ''}</td>
                      <td style={{ padding: '4px 14px' }}>{article.est_boisson ? '✓' : ''}</td>
                      <td style={{ padding: '4px 14px' }}>
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
                    <td colSpan={13} style={{ padding: 20, textAlign: 'center', color: '#888' }}>
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
            background: 'white', borderRadius: 10, width: 480, maxHeight: '90vh',
            display: 'flex', flexDirection: 'column', overflow: 'hidden',
          }}>
            <div style={{
              display: 'flex', alignItems: 'center', justifyContent: 'space-between',
              padding: '16px 24px', borderBottom: '1px solid #e5e5e0', flexShrink: 0,
            }}>
              <div style={{ fontWeight: 600, fontSize: 16 }}>
                {edition.id ? 'Modifier l\u2019article' : 'Nouvel article'}
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" onClick={enregistrer}>
                  {edition.id ? 'Enregistrer' : 'Créer'}
                </button>
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
            </div>

            <div style={{ padding: 24, overflowY: 'auto' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>

              <Champ label="Nom">
                <input style={inputStyle} value={edition.nom} onChange={e => majChamp('nom', e.target.value)} />
              </Champ>

              <div style={{ display: 'flex', gap: 12 }}>
                <Champ label="Type d'article" style={{ flex: 1 }}>
                  <input style={inputStyle} value={edition.type_article || ''} onChange={e => majChamp('type_article', e.target.value)} placeholder="2. APERITIF, VIN ROUGE, 4A. PÂTES..." />
                </Champ>
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
              </div>

              {/* Catégorie : uniquement pour les dépenses (code de vente 9001).
                  Regroupe les dépenses dans le caddy (Magasins, Charges fixes, Divers...). */}
              {String(edition.code_vente) === String(CODE_VENTE_DEPENSE) && (
                <Champ label="Catégorie de dépense">
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
                        Choisir dans la liste
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
              )}

              <div style={{ display: 'flex', gap: 12 }}>
                <Champ label="Prix de vente (sur place)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.prix_vente} onChange={e => majChamp('prix_vente', e.target.value)} />
                </Champ>
                <Champ label="Prix de vente (à emporter)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.prix_vente_away ?? ''} onChange={e => majChamp('prix_vente_away', e.target.value)} placeholder="laisser vide si identique" />
                </Champ>
              </div>

              <div style={{ display: 'flex', gap: 12 }}>
                <Champ label="TVA sur place (%)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.tva} onChange={e => majChamp('tva', e.target.value)} />
                </Champ>
                <Champ label="TVA à emporter (%)" style={{ flex: 1 }}>
                  <input type="number" step="0.01" style={inputStyle} value={edition.tva_away ?? ''} onChange={e => majChamp('tva_away', e.target.value)} placeholder="laisser vide si identique" />
                </Champ>
              </div>

              <Champ label="Prix d'achat">
                <input type="number" step="0.01" style={inputStyle} value={edition.prix_achat} onChange={e => majChamp('prix_achat', e.target.value)} />
              </Champ>

              <div style={{ display: 'flex', gap: 12 }}>
                <Champ label="Stock" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock} onChange={e => majChamp('stock', e.target.value)} />
                </Champ>
                <Champ label="Stock min" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock_min} onChange={e => majChamp('stock_min', e.target.value)} />
                </Champ>
                <Champ label="Stock max" style={{ flex: 1 }}>
                  <input type="number" style={inputStyle} value={edition.stock_max} onChange={e => majChamp('stock_max', e.target.value)} />
                </Champ>
              </div>

              <div style={{ display: 'flex', gap: 12 }}>
                <Champ label="Fournisseur" style={{ flex: 1 }}>
                  <input style={inputStyle} value={edition.fournisseur || ''} onChange={e => majChamp('fournisseur', e.target.value)} />
                </Champ>
                <Champ label="EAN" style={{ flex: 1 }}>
                  <input style={inputStyle} value={edition.ean || ''} onChange={e => majChamp('ean', e.target.value)} />
                </Champ>
              </div>

              <Champ label="Localisation">
                <input style={inputStyle} value={edition.localisation || ''} onChange={e => majChamp('localisation', e.target.value)} />
              </Champ>

              <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginTop: 4 }}>
                <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13 }}>
                  <input
                    type="checkbox"
                    checked={edition.actif}
                    onChange={e => majChamp('actif', e.target.checked)}
                    style={{ width: 16, height: 16 }}
                  />
                  Article actif (visible dans le caddy)
                </label>

                <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13 }}>
                  <input
                    type="checkbox"
                    checked={edition.stock_a_suivre || false}
                    onChange={e => majChamp('stock_a_suivre', e.target.checked)}
                    style={{ width: 16, height: 16 }}
                  />
                  À suivre (article important à surveiller)
                </label>

                <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13 }}>
                  <input
                    type="checkbox"
                    checked={edition.est_boisson || false}
                    onChange={e => majChamp('est_boisson', e.target.checked)}
                    style={{ width: 16, height: 16 }}
                  />
                  Boisson
                </label>
              </div>
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
  padding: '8px 10px',
  borderRadius: 6,
  border: '1px solid #ddd',
  fontSize: 14,
  boxSizing: 'border-box',
};