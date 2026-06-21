import { Link, useLocation } from 'react-router-dom';

export default function NavBar() {
  const location = useLocation();

  const linkStyle = (path) => ({
    padding: '8px 14px',
    borderRadius: 8,
    textDecoration: 'none',
    fontSize: 14,
    fontWeight: 500,
    color: location.pathname === path ? 'white' : '#333',
    background: location.pathname === path ? '#111' : 'transparent',
  });

  return (
    <div style={{
      display: 'flex',
      gap: 8,
      padding: '12px 24px',
      borderBottom: '1px solid #e5e5e0',
      background: 'white',
    }}>
      <Link to="/" style={linkStyle('/')}>Plan de salle</Link>
      <Link to="/articles" style={linkStyle('/articles')}>Articles</Link>
      <Link to="/reservations" style={linkStyle('/reservations')}>Réservations</Link>
      <Link to="/historique" style={linkStyle('/historique')}>Historique</Link>
    </div>
  );
}
