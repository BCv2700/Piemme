import { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';

function toDateKey(date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export default function NavBar() {
  const location = useLocation();
  const [dernierDatePlanSalle, setDernierDatePlanSalle] = useState(null);

  // Mémorise la date du Plan de salle chaque fois qu'on s'y trouve, pour pouvoir
  // y revenir avec cette même date même après avoir visité un autre écran.
  // Important : si l'URL n'a pas de paramètre ?date= (cas "aujourd'hui", où
  // PlanSalle retire volontairement le paramètre), on retombe explicitement sur
  // la date du jour plutôt que sur null, sinon la mémorisation se perd et les
  // liens Historique/Encaissements partent sans aucune date.
  useEffect(() => {
    if (location.pathname === '/') {
      const date = new URLSearchParams(location.search).get('date') || toDateKey(new Date());
      setDernierDatePlanSalle(date);
    }
  }, [location]);

  const linkStyle = (path) => ({
    padding: '8px 14px',
    borderRadius: 8,
    textDecoration: 'none',
    fontSize: 14,
    fontWeight: 500,
    color: location.pathname === path ? 'white' : '#333',
    background: location.pathname === path ? '#111' : 'transparent',
  });

  const urlPlanSalle = dernierDatePlanSalle ? '/?date=' + dernierDatePlanSalle : '/';
  const suffixeDate = dernierDatePlanSalle ? '?date=' + dernierDatePlanSalle : '';

  return (
    <div style={{
      display: 'flex',
      gap: 8,
      padding: '12px 24px',
      borderBottom: '1px solid #e5e5e0',
      background: 'white',
    }}>
      <Link to={urlPlanSalle} style={linkStyle('/')}>Plan de salle</Link>
      <Link to="/articles" style={linkStyle('/articles')}>Articles</Link>
      <Link to="/reservations" style={linkStyle('/reservations')}>Réservations</Link>
      <Link to={'/historique' + suffixeDate} style={linkStyle('/historique')}>Historique</Link>
      <Link to={'/encaissements' + suffixeDate} style={linkStyle('/encaissements')}>Encaissements</Link>
    </div>
  );
}
