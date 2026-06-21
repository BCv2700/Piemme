import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../api/api';

export default function Caddy() {
  const { tableId } = useParams();
  const navigate = useNavigate();

  const [table, setTable] = useState(null);
  const [articles, setArticles] = useState([]);
  const [lignes, setLignes] = useState([]);
  const [codeVente, setCodeVente] = useState(null); // niveau 1 : code_vente (Boissons Alcools, Nourriture...)
  const [categorie, setCategorie] = useState(null); // niveau 2 : type_article (2. APERITIF, VIN ROUGE...)
  const [emporte, setEmporte] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

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
  };

  // Niveau 1 : codes de vente présents (Boissons Alcools, Nourriture...), dans l'ordre des codes
  const codesVente = [...new Set(articles.map(a => a.code_vente))]
    .filter(c => c != null)
    .sort((a, b) => a - b);

  useEffect(() => {
    if (!codeVente && codesVente.length > 0) setCodeVente(codesVente[0]);
  }, [codesVente, codeVente]);

  // Niveau 2 : types précis disponibles pour le code de vente sélectionné (2. APERITIF, VIN ROUGE, 4A. PÂTES...)
  const typesNiveau2 = [...new Set(
    articles
      .filter(a => a.code_vente === codeVente)
      .map(a => a.type_article || 'Sans type')
  )].sort((a, b) => a.localeCompare(b, 'fr', { numeric: true }));

  // Quand on change de code de vente (niveau 1), on resélectionne le premier type disponible
  useEffect(() => {
    if (typesNiveau2.length > 0 && !typesNiveau2.includes(categorie)) {
      setCategorie(typesNiveau2[0]);
    }
  }, [typesNiveau2, categorie]);

  // Niveau 3 : articles du type sélectionné
  const articlesAffiches = articles.filter(a =>
    a.code_vente === codeVente &&
    (a.type_article || 'Sans type') === categorie
  );

  const ajouterArticle = async (article) => {
    setError('');
    const prix = emporte && article.prix_vente_away != null ? article.prix_vente_away : article.prix_vente;
    const tva = emporte && article.tva_away != null ? article.tva_away : article.tva;

    // Une ligne existante = même table + même article + même mode (sur place / à emporter)
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
        <div className="topbar"><h1>Caddy</h1></div>
        <div className="content">Chargement...</div>
      </div>
    );
  }

  return (
    <div>
      <div className="topbar">
        <h1>{table ? table.nom : 'Table'} — Caddy</h1>
      </div>
      <div className="content">

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <button className="btn" onClick={() => navigate('/')}>← Retour au plan de salle</button>

          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer' }}>
            <input
              type="checkbox"
              checked={emporte}
              onChange={(e) => setEmporte(e.target.checked)}
              style={{ width: 16, height: 16 }}
            />
            À emporter
          </label>
        </div>

        <div style={{ display: 'flex', gap: 16 }}>

          {/* Colonne 1 : codes de vente (Boissons Alcools, Nourriture, Boissons Softs, Boissons Vins, Divers) */}
          <div style={{ width: 130, flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 6 }}>
            {codesVente.map(code => (
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

          {/* Colonne 2 : types précis (liste verticale) */}
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
            {typesNiveau2.map(t => (
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
            {typesNiveau2.length === 0 && (
              <div style={{ color: '#888', fontSize: 13, padding: 8 }}>Aucun type</div>
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
                    onClick={() => ajouterArticle(article)}
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
                    <span style={{ fontSize: 11, color: '#888', flexShrink: 0 }}>{Number(prix).toFixed(2)} €</span>
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
            <div style={{ fontWeight: 600, fontSize: 15, marginBottom: 12 }}>Commande en cours</div>

            {lignes.length === 0 && (
              <div style={{ color: '#888', fontSize: 13, marginBottom: 12 }}>Aucun article commandé</div>
            )}

            <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 16 }}>
              {lignes.map(ligne => (
                <div key={ligne.id} style={{ display: 'flex', alignItems: 'flex-start', gap: 8 }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 13, fontWeight: 500 }}>
                      {nomArticle(ligne.article_id)}
                      {ligne.emporte && <span style={{ fontSize: 11, color: '#888' }}> (emporté)</span>}
                    </div>
                    <div style={{ fontSize: 12, color: '#888' }}>
                      {Number(ligne.prix_unitaire).toFixed(2)} € × {Number(ligne.quantite)}
                    </div>
                  </div>

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
    </div>
  );
}
