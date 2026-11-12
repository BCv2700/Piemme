import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const ONGLETS_SIMPLES = [
  { id: 'calendrier',   l: '📅 Calendrier' },
  { id: 'depenses_mois',l: '💸 Dépenses' },
  { id: 'factures',     l: '🧾 Factures en retard' },
  { id: 'annuel',       l: '📊 Tableau annuel' },
  { id: 'tva',          l: '🏛️ TVA' },
  { id: 'depenses',     l: '🔁 Récurrentes' },
  { id: 'enveloppes',   l: '✉️ Enveloppes' },
];

const GRAPHIQUES = [
  { id: 'graphique_mois',   l: 'Mois' },
  { id: 'graphique_annuel', l: 'Année' },
];

export default function SideBar({ menuOuvert, setMenuOuvert, onglet, setOnglet }) {
  const navigate = useNavigate();
  const role = localStorage.getItem('piemme_role');
  const isLocal = (import.meta.env.VITE_API_URL || '').includes('localhost');
  const graphiqueActif = GRAPHIQUES.some(g => g.id === onglet);
  const [graphOuvert, setGraphOuvert] = useState(graphiqueActif);

  const allerOnglet = (id) => {
    setOnglet(id);
    setMenuOuvert(false);
  };

  const allerAdmin = () => {
    navigate('/administration');
    setMenuOuvert(false);
  };

  const seDeconnecter = () => {
    localStorage.clear();
    window.location.href = '/login';
  };

  return (
    <>
      {menuOuvert && (
        <div className="sidebar-overlay visible" onClick={() => setMenuOuvert(false)} />
      )}
      <div className={`sidebar${menuOuvert ? ' ouverte' : ''}`}>

        <div className="sidebar-logo">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ fontWeight: 700, fontSize: 16, color: '#1a1a1a' }}>🏠 Piemme</div>
            <div onClick={seDeconnecter} title="Se déconnecter"
              style={{ fontSize: 18, cursor: 'pointer', color: '#ff6b6b', lineHeight: 1 }}>🚪</div>
          </div>
          <div style={{ fontSize: 11, color: '#888', marginTop: 4, display: 'flex', alignItems: 'center', gap: 6 }}>
            <span style={{ fontFamily: 'monospace', fontSize: 10, color: '#b0b0b0' }}>
              v{__APP_VERSION__}
            </span>
            {isLocal && (
              <span style={{ fontSize: 9, background: '#fef3c7', color: '#d97706', border: '1px solid #fcd34d', borderRadius: 3, padding: '1px 4px', fontFamily: 'monospace', fontWeight: 700 }}>LOCAL</span>
            )}
          </div>
        </div>

        {/* Onglets */}
        <div className="nav-section">Navigation</div>

        {/* Calendrier */}
        <div
          className={`nav-item${onglet === 'calendrier' ? ' active' : ''}`}
          onClick={() => allerOnglet('calendrier')}
        >
          📅 Calendrier
        </div>

        {/* Sous-menu Graphique */}
        <div
          className={`nav-item${graphiqueActif ? ' active' : ''}`}
          onClick={() => setGraphOuvert(v => !v)}
          style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}
        >
          <span>📈 Graphique</span>
          <span style={{ fontSize: 10, color: '#999', marginLeft: 4 }}>{graphOuvert ? '▲' : '▼'}</span>
        </div>
        {graphOuvert && GRAPHIQUES.map(g => (
          <div
            key={g.id}
            className={`nav-item${onglet === g.id ? ' active' : ''}`}
            onClick={() => allerOnglet(g.id)}
            style={{ paddingLeft: 32 }}
          >
            {g.l}
          </div>
        ))}

        {/* Reste des onglets */}
        {ONGLETS_SIMPLES.filter(o => o.id !== 'calendrier').map(o => (
          <div
            key={o.id}
            className={`nav-item${onglet === o.id ? ' active' : ''}`}
            onClick={() => allerOnglet(o.id)}
          >
            {o.l}
          </div>
        ))}

        {/* Admin */}
        {role === 'admin' && <>
          <div className="nav-section">⚙️ Admin</div>
          <div className="nav-item" onClick={allerAdmin}>💾 Administration</div>
        </>}

        <div style={{ marginTop: 'auto' }} />
      </div>
    </>
  );
}
