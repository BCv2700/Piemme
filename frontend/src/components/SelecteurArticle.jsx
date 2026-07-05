import { useState } from 'react';

// Sélecteur d'article (plat) réutilisable : même principe que SelecteurClient,
// avec un champ cliquable qui ouvre une fenêtre de recherche filtrée en direct
// sur le nom du plat. Utile partout où il faut choisir un article parmi
// plusieurs centaines sans un <select> natif interminable.
export default function SelecteurArticle({ articles, articleId, onChange, placeholder = '— Choisir un plat —', style, compact = false }) {
  const [ouvert, setOuvert] = useState(false);
  const [recherche, setRecherche] = useState('');

  const articleActuel = articles.find(a => a.id === articleId);
  const articlesFiltres = articles.filter(a => a.nom.toLowerCase().includes(recherche.toLowerCase()));

  const choisir = (id) => {
    onChange(id);
    setOuvert(false);
    setRecherche('');
  };

  const effacer = (e) => {
    e.stopPropagation();
    onChange(null);
  };

  return (
    <>
      <div
        onClick={() => setOuvert(true)}
        title={articleActuel ? articleActuel.nom : placeholder}
        style={{
          display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer',
          padding: compact ? '3px 6px' : '9px 12px',
          borderRadius: compact ? 5 : 8,
          border: '1px solid #ddd',
          background: 'white',
          fontSize: compact ? 12 : 14,
          color: articleActuel ? '#333' : '#aaa',
          minWidth: 0,
          ...style,
        }}
      >
        <span style={{ flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          {articleActuel ? articleActuel.nom : placeholder}
        </span>
        {articleActuel && onChange && (
          <span
            onClick={effacer}
            title="Effacer"
            style={{ color: '#dc2626', fontWeight: 700, padding: '0 2px', flexShrink: 0 }}
          >
            ✕
          </span>
        )}
      </div>

      {ouvert && (
        <div
          style={{
            position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 300,
          }}
          onClick={() => setOuvert(false)}
        >
          <div
            style={{ background: 'white', borderRadius: 10, width: 380, maxHeight: '70vh', display: 'flex', flexDirection: 'column' }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ padding: 16, borderBottom: '1px solid #e5e5e0' }}>
              <input
                type="text"
                autoFocus
                placeholder="Rechercher un plat..."
                value={recherche}
                onChange={(e) => setRecherche(e.target.value)}
                style={{ width: '100%', padding: '10px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box' }}
              />
            </div>
            <div style={{ overflowY: 'auto', flex: 1 }}>
              {articlesFiltres.map(a => (
                <div
                  key={a.id}
                  onClick={() => choisir(a.id)}
                  style={{ padding: '10px 16px', cursor: 'pointer', borderBottom: '1px solid #f0f0f0', fontSize: 14 }}
                  onMouseEnter={(e) => e.currentTarget.style.background = '#f5f5f0'}
                  onMouseLeave={(e) => e.currentTarget.style.background = 'white'}
                >
                  {a.nom}
                </div>
              ))}
              {articlesFiltres.length === 0 && (
                <div style={{ padding: 16, textAlign: 'center', color: '#888' }}>Aucun résultat</div>
              )}
            </div>
            <div style={{ padding: 12, borderTop: '1px solid #e5e5e0', textAlign: 'right' }}>
              <button className="btn" onClick={() => setOuvert(false)}>Fermer</button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}