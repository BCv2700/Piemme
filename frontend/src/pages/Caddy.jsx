import { useState, useEffect } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import api from '../api/api';

// ───────────────────────────────────────────────────────────────────────────
// Les dépenses (code_vente 9001) sont regroupées par leur champ « categorie »,
// défini pour chaque dépense dans l'onglet Articles. Aucune liste en dur ici :
// les catégories sont relevées automatiquement depuis la base. Une dépense sans
// catégorie apparaît dans « Non classé ».
// ───────────────────────────────────────────────────────────────────────────
const CODE_VENTE_DEPENSE = 9001;

export default function Caddy() {
  const { tableId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const retourDate = searchParams.get('retourDate');
  const urlRetourPlan = retourDate ? '/?date=' + retourDate : '/';

  const [table, setTable] = useState(null);
  const [articles, setArticles] = useState([]);
  const [lignes, setLignes] = useState([]);
  const [codeVente, setCodeVente] = useState(null); // niveau 1 : code_vente (Boissons Alcools, Nourriture...)
  const [categorie, setCategorie] = useState(null); // niveau 2 : type_article (2. APERITIF, VIN ROUGE...)
  const [emporte, setEmporte] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  // Saisie d'un montant de dépense (null = fenêtre fermée)
  const [saisieDepense, setSaisieDepense] = useState(null); // { article, montant }

  const load = async () => {
    try {
      const [tableRes, articlesRes, lignesRes] = await Promise.all([
        api.get('/tables/' + tableId),
        api.get('/articles/', { params: { actif: true } }),
        api.get('/commandes/', { params: { table_id: tableId } }),
      ]);
      setTable(tableRes.data);
      setArticles(articlesRes.data);
      setLignes(lignesRes.data);
    } catch (e) {
      setError(e.response?.data?.detail || 'Impossible de charger le caddy');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, [tableId]);

  const LIBELLES_CODE_VENTE = {
    7001: 'Boissons Alcools',
    7002: 'Nourriture',
    7003: 'Boissons Softs',
    7004: 'Boissons Vins',
    7005: 'Divers',
    9001: 'Dépenses',
  };

  // Cet écran est-il un écran de dépenses ? On le détecte de façon fiable :
  // dès qu'il existe au moins un article en code_vente 9001 / type "depense".
  const estEcranDepense = articles.some(
    a => a.code_vente === CODE_VENTE_DEPENSE || a.type === 'depense'
  );

  // Niveau 1 : codes de vente présents (Boissons Alcools, Nourriture...), dans l'ordre des codes
  const codesVente = [...new Set(articles.map(a => a.code_vente))]
    .filter(c => c != null)
    .sort((a, b) => a - b);

  useEffect(() => {
    if (!codeVente && codesVente.length > 0) setCodeVente(codesVente[0]);
  }, [codesVente, codeVente]);

  // ───── MODE DÉPENSE ──────────────────────────────────────────────────────
  // On ne montre que les articles 9001, regroupés par leur champ « categorie ».
  // Le "niveau 2" devient la catégorie (Magasins, Frais fixes, ...).
  const articlesDepense = articles.filter(a => a.code_vente === CODE_VENTE_DEPENSE);

  // Pour chaque dépense, sa catégorie vient du champ « categorie » (saisi dans
  // l'onglet Articles). Vide ou absent => 'Non classé'.
  const categorieDe = (article) => {
    const c = (article.categorie || '').trim();
    return c === '' ? 'Non classé' : c;
  };

  // Liste des catégories présentes, par ordre alphabétique, 'Non classé' à la fin
  const categoriesDepense = (() => {
    const presentes = [...new Set(articlesDepense.map(a => categorieDe(a)))];
    const sansNonClasse = presentes.filter(c => c !== 'Non classé')
      .sort((a, b) => a.localeCompare(b, 'fr'));
    if (presentes.includes('Non classé')) sansNonClasse.push('Non classé');
    return sansNonClasse;
  })();

  // ───── MODE VENTE (inchangé) ─────────────────────────────────────────────
  // Niveau 2 : types précis disponibles pour le code de vente sélectionné
  const typesNiveau2 = [...new Set(
    articles
      .filter(a => a.code_vente === codeVente)
      .map(a => a.type_article || 'Sans type')
  )].sort((a, b) => a.localeCompare(b, 'fr', { numeric: true }));

  // Quand on change de code de vente (niveau 1), on resélectionne le premier type disponible.
  // En mode dépense, le niveau 2 = catégories de dépense.
  useEffect(() => {
    if (estEcranDepense) {
      if (categoriesDepense.length > 0 && !categoriesDepense.includes(categorie)) {
        setCategorie(categoriesDepense[0]);
      }
    } else {
      if (typesNiveau2.length > 0 && !typesNiveau2.includes(categorie)) {
        setCategorie(typesNiveau2[0]);
      }
    }
  }, [estEcranDepense, typesNiveau2, categoriesDepense, categorie]);

  // Niveau 3 : articles affichés
  const articlesAffiches = estEcranDepense
    ? articlesDepense.filter(a => categorieDe(a) === categorie)
        .sort((a, b) => a.nom.localeCompare(b.nom, 'fr', { numeric: true }))
    : articles.filter(a =>
        a.code_vente === codeVente &&
        (a.type_article || 'Sans type') === categorie
      );

  // ───── AJOUT D'UN ARTICLE DE VENTE (inchangé) ────────────────────────────
  const ajouterArticle = async (article) => {
    setError('');
    const prix = emporte && article.prix_vente_away != null ? article.prix_vente_away : article.prix_vente;
    const tva = emporte && article.tva_away != null ? article.tva_away : article.tva;

    const ligneExistante = lignes.find(l => l.article_id === article.id && l.emporte === emporte);

    try {
      if (ligneExistante) {
        const nouvelleQuantite = Number(ligneExistante.quantite) + 1;
        const res = await api.patch('/commandes/' + ligneExistante.id, { quantite: nouvelleQuantite });
        setLignes(prev => prev.map(l => l.id === ligneExistante.id ? res.data : l));
      } else {
        const res = await api.post('/commandes/', {
          table_id: Number(tableId),
          article_id: article.id,
          quantite: 1,
          prix_unitaire: prix,
          tva: tva,
          emporte: emporte,
        });
        setLignes(prev => [...prev, res.data]);
      }
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'ajout");
    }
  };

  // ───── AJOUT D'UNE DÉPENSE (avec saisie du montant) ──────────────────────
  const ouvrirSaisieDepense = (article) => {
    setSaisieDepense({ article, montant: '' });
  };

  const validerSaisieDepense = async () => {
    if (!saisieDepense) return;
    const montant = Number(String(saisieDepense.montant).replace(',', '.'));
    if (!Number.isFinite(montant) || montant <= 0) {
      setError('Montant invalide');
      return;
    }
    setError('');
    try {
      const res = await api.post('/commandes/', {
        table_id: Number(tableId),
        article_id: saisieDepense.article.id,
        quantite: 1,
        prix_unitaire: montant,
        tva: saisieDepense.article.tva,
        emporte: false,
      });
      setLignes(prev => [...prev, res.data]);
      setSaisieDepense(null);
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'ajout de la dépense");
    }
  };

  // ───── ÉDITION DU MONTANT D'UNE LIGNE (dépense) ──────────────────────────
  const modifierMontantLigne = async (ligne, nouveauMontantStr) => {
    const montant = Number(String(nouveauMontantStr).replace(',', '.'));
    if (!Number.isFinite(montant) || montant < 0) return;
    setError('');
    try {
      const res = await api.patch('/commandes/' + ligne.id, { prix_unitaire: montant });
      setLignes(prev => prev.map(l => l.id === ligne.id ? res.data : l));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la mise à jour du montant');
    }
  };

  const changerQuantite = async (ligne, delta) => {
    const nouvelleQuantite = Number(ligne.quantite) + delta;
    setError('');
    try {
      if (nouvelleQuantite <= 0) {
        await api.delete('/commandes/' + ligne.id);
        setLignes(prev => prev.filter(l => l.id !== ligne.id));
      } else {
        const res = await api.patch('/commandes/' + ligne.id, { quantite: nouvelleQuantite });
        setLignes(prev => prev.map(l => l.id === ligne.id ? res.data : l));
      }
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la mise à jour');
    }
  };

  const supprimerLigne = async (ligne) => {
    setError('');
    try {
      await api.delete('/commandes/' + ligne.id);
      setLignes(prev => prev.filter(l => l.id !== ligne.id));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la suppression');
    }
  };

  const nomArticle = (articleId) => {
    const a = articles.find(a => a.id === articleId);
    return a ? a.nom : 'Article #' + articleId;
  };

  const total = lignes.reduce((sum, l) => sum + Number(l.prix_unitaire) * Number(l.quantite), 0);

  if (loading) {
    return (
      <div>
        <div className="content">Chargement...</div>
      </div>
    );
  }

  return (
    <div>
      <div className="content">

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button className="btn" onClick={() => navigate(urlRetourPlan)}>← Retour au plan de salle</button>
            <span style={{
              fontSize: 13, fontWeight: 700, color: '#111',
              background: '#f0f0ee', borderRadius: 6, padding: '6px 12px',
            }}>
              {table ? table.nom : 'Table'}
            </span>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            {!estEcranDepense && (
              <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer' }}>
                <input
                  type="checkbox"
                  checked={emporte}
                  onChange={(e) => setEmporte(e.target.checked)}
                  style={{ width: 16, height: 16 }}
                />
                À emporter
              </label>
            )}
            <button
              className="btn"
              style={{ background: '#15803d', color: 'white', fontWeight: 600 }}
              onClick={() => navigate('/paiement/' + tableId + (retourDate ? '?retourDate=' + retourDate : ''))}
            >
              Payer →
            </button>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 16 }}>

          {/* Colonne 1 : codes de vente — masquée en mode dépense (un seul code) */}
          {!estEcranDepense && (
            <div style={{ width: 130, flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {codesVente.filter(c => c !== CODE_VENTE_DEPENSE).map(code => (
                <button
                  key={code}
                  className="btn"
                  style={{
                    background: codeVente === code ? '#111' : 'white',
                    color: codeVente === code ? 'white' : '#333',
                    fontWeight: 600,
                    padding: '12px 8px',
                    fontSize: 13,
                  }}
                  onClick={() => setCodeVente(code)}
                >
                  {LIBELLES_CODE_VENTE[code] || code}
                </button>
              ))}
            </div>
          )}

          {/* Colonne 2 : types précis (vente) OU catégories (dépense) */}
          <div style={{
            width: 150,
            flexShrink: 0,
            display: 'flex',
            flexDirection: 'column',
            gap: 4,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 8,
            height: 'fit-content',
            maxHeight: 560,
            overflowY: 'auto',
          }}>
            {(estEcranDepense ? categoriesDepense : typesNiveau2).map(t => (
              <button
                key={t}
                onClick={() => setCategorie(t)}
                style={{
                  textAlign: 'left',
                  padding: '10px 12px',
                  borderRadius: 6,
                  border: 'none',
                  fontSize: 13,
                  fontWeight: categorie === t ? 600 : 400,
                  background: categorie === t ? '#f0f0ee' : 'transparent',
                  color: '#222',
                  cursor: 'pointer',
                }}
              >
                {t}
              </button>
            ))}
            {(estEcranDepense ? categoriesDepense : typesNiveau2).length === 0 && (
              <div style={{ color: '#888', fontSize: 13, padding: 8 }}>
                {estEcranDepense ? 'Aucune dépense' : 'Aucun type'}
              </div>
            )}
          </div>

          {/* Colonne 3 : articles de la catégorie sélectionnée */}
          <div style={{ flex: '1 1 0%', minWidth: 0 }}>
            <div style={{
              display: 'flex',
              flexWrap: 'wrap',
              gap: 8,
            }}>
              {articlesAffiches.map(article => {
                const prix = emporte && article.prix_vente_away != null ? article.prix_vente_away : article.prix_vente;
                return (
                  <button
                    key={article.id}
                    className="btn"
                    onClick={() => estEcranDepense ? ouvrirSaisieDepense(article) : ajouterArticle(article)}
                    title={article.nom}
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'flex-start',
                      justifyContent: 'space-between',
                      textAlign: 'left',
                      height: 64,
                      width: 130,
                      flexShrink: 0,
                      padding: '6px 10px',
                      overflow: 'hidden',
                    }}
                  >
                    <span style={{
                      fontSize: 12,
                      fontWeight: 600,
                      lineHeight: 1.25,
                      display: '-webkit-box',
                      WebkitLineClamp: 2,
                      WebkitBoxOrient: 'vertical',
                      overflow: 'hidden',
                    }}>{article.nom}</span>
                    {estEcranDepense
                      ? <span style={{ fontSize: 11, color: '#888', flexShrink: 0 }}>Saisir un montant</span>
                      : <span style={{ fontSize: 11, color: '#888', flexShrink: 0 }}>{Number(prix).toFixed(2)} €</span>
                    }
                  </button>
                );
              })}
              {articlesAffiches.length === 0 && (
                <div style={{ color: '#888', fontSize: 13 }}>Aucun article dans cette catégorie</div>
              )}
            </div>
          </div>

          {/* Colonne 4 : ticket de caisse */}
          <div style={{
            width: 280,
            flexShrink: 0,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 16,
            height: 'fit-content',
            position: 'sticky',
            top: 16,
          }}>
            <div style={{ fontWeight: 600, fontSize: 15, marginBottom: 12 }}>
              {estEcranDepense ? 'Dépenses en cours' : 'Commande en cours'}
            </div>

            {lignes.length === 0 && (
              <div style={{ color: '#888', fontSize: 13, marginBottom: 12 }}>
                {estEcranDepense ? 'Aucune dépense saisie' : 'Aucun article commandé'}
              </div>
            )}

            <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 16 }}>
              {lignes.map(ligne => (
                <div key={ligne.id} style={{ display: 'flex', alignItems: 'flex-start', gap: 8 }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 13, fontWeight: 500 }}>
                      {nomArticle(ligne.article_id)}
                      {ligne.emporte && <span style={{ fontSize: 11, color: '#888' }}> (emporté)</span>}
                    </div>
                    {estEcranDepense ? (
                      <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 4 }}>
                        <input
                          type="number"
                          step="0.01"
                          min="0"
                          defaultValue={Number(ligne.prix_unitaire).toFixed(2)}
                          onBlur={(e) => modifierMontantLigne(ligne, e.target.value)}
                          style={{
                            width: 80, padding: '4px 6px', borderRadius: 6,
                            border: '1px solid #ddd', fontSize: 13,
                          }}
                        />
                        <span style={{ fontSize: 12, color: '#888' }}>€</span>
                      </div>
                    ) : (
                      <div style={{ fontSize: 12, color: '#888' }}>
                        {Number(ligne.prix_unitaire).toFixed(2)} € × {Number(ligne.quantite)}
                      </div>
                    )}
                  </div>

                  {/* Quantité : seulement en mode vente */}
                  {!estEcranDepense && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                      <button
                        className="btn"
                        style={{ width: 26, height: 26, padding: 0, fontSize: 14, lineHeight: 1 }}
                        onClick={() => changerQuantite(ligne, -1)}
                      >−</button>
                      <span style={{ fontSize: 13, minWidth: 18, textAlign: 'center' }}>{Number(ligne.quantite)}</span>
                      <button
                        className="btn"
                        style={{ width: 26, height: 26, padding: 0, fontSize: 14, lineHeight: 1 }}
                        onClick={() => changerQuantite(ligne, 1)}
                      >+</button>
                    </div>
                  )}

                  <button
                    className="btn"
                    style={{ width: 26, height: 26, padding: 0, fontSize: 12, lineHeight: 1, color: '#dc2626', borderColor: '#fca5a5' }}
                    onClick={() => supprimerLigne(ligne)}
                    title="Supprimer cette ligne"
                  >✕</button>
                </div>
              ))}
            </div>

            <div style={{
              borderTop: '1px solid #e5e5e0',
              paddingTop: 12,
              display: 'flex',
              justifyContent: 'space-between',
              fontSize: 16,
              fontWeight: 700,
            }}>
              <span>Total</span>
              <span>{total.toFixed(2)} €</span>
            </div>
          </div>

        </div>
      </div>

      {/* Fenêtre de saisie du montant d'une dépense */}
      {saisieDepense && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}
          onClick={() => setSaisieDepense(null)}
        >
          <div
            style={{ background: 'white', borderRadius: 10, padding: 24, width: 320 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 4 }}>{saisieDepense.article.nom}</div>
            <div style={{ fontSize: 12, color: '#888', marginBottom: 16 }}>Montant de la dépense</div>

            <input
              type="number"
              step="0.01"
              min="0"
              autoFocus
              value={saisieDepense.montant}
              onChange={(e) => setSaisieDepense({ ...saisieDepense, montant: e.target.value })}
              onKeyDown={(e) => { if (e.key === 'Enter') validerSaisieDepense(); }}
              placeholder="Ex: 47.30"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 15, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={() => setSaisieDepense(null)}>Annuler</button>
              <button
                className="btn"
                style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }}
                onClick={validerSaisieDepense}
              >Ajouter</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}