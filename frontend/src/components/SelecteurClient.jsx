import { useState } from 'react';

// Sélecteur de client réutilisable : un champ cliquable affichant le client
// choisi (ou un placeholder), qui ouvre une fenêtre de recherche avec filtrage
// en direct sur le nom. Une croix permet de retirer le client sélectionné
// directement depuis le champ, sans repasser par la fenêtre.
export default function SelecteurClient({ clients, clientId, onChange, placeholder = '— Aucun client —', style, compact = false }) {
  const [ouvert, setOuvert] = useState(false);
  const [recherche, setRecherche] = useState('');

  const clientActuel = clients.find(c => c.id === clientId);
  const clientsFiltres = clients.filter(c => c.nom.toLowerCase().includes(recherche.toLowerCase()));

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
        title={clientActuel ? clientActuel.nom : placeholder}
        style={{
          display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer',
          padding: compact ? '3px 6px' : '9px 12px',
          borderRadius: compact ? 5 : 8,
          border: '1px solid #ddd',
          background: 'white',
          fontSize: compact ? 12 : 14,
          color: clientActuel ? '#333' : '#aaa',
          minWidth: 0,
          ...style,
        }}
      >
        <span style={{ flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          {clientActuel ? clientActuel.nom : placeholder}
        </span>
        {clientActuel && (
          <span
            onClick={effacer}
            title="Retirer le client"
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
                placeholder="Rechercher un client..."
                value={recherche}
                onChange={(e) => setRecherche(e.target.value)}
                style={{ width: '100%', padding: '10px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box' }}
              />
            </div>
            <div style={{ overflowY: 'auto', flex: 1 }}>
              <div
                onClick={() => choisir(null)}
                style={{ padding: '10px 16px', cursor: 'pointer', color: '#888', borderBottom: '1px solid #f0f0f0', fontStyle: 'italic' }}
                onMouseEnter={(e) => e.currentTarget.style.background = '#f5f5f0'}
                onMouseLeave={(e) => e.currentTarget.style.background = 'white'}
              >
                — Aucun client —
              </div>
              {clientsFiltres.map(c => (
                <div
                  key={c.id}
                  onClick={() => choisir(c.id)}
                  style={{ padding: '10px 16px', cursor: 'pointer', borderBottom: '1px solid #f0f0f0', fontSize: 14 }}
                  onMouseEnter={(e) => e.currentTarget.style.background = '#f5f5f0'}
                  onMouseLeave={(e) => e.currentTarget.style.background = 'white'}
                >
                  {c.nom}
                </div>
              ))}
              {clientsFiltres.length === 0 && (
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