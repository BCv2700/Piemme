import { useState, useEffect, useRef } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';

function toDateKey(date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

// Menu déroulant générique : affiche un bouton, et une liste de liens au clic.
// Se ferme automatiquement au clic en dehors (écouteur sur document).
function MenuDeroulant({ label, actif, children }) {
  const [ouvert, setOuvert] = useState(false);
  const ref = useRef(null);

  useEffect(() => {
    const fermerSiExterieur = (e) => {
      if (ref.current && !ref.current.contains(e.target)) setOuvert(false);
    };
    document.addEventListener('mousedown', fermerSiExterieur);
    return () => document.removeEventListener('mousedown', fermerSiExterieur);
  }, []);

  return (
    <div ref={ref} style={{ position: 'relative' }}>
      <button
        onClick={() => setOuvert(v => !v)}
        style={{
          padding: '8px 14px',
          borderRadius: 8,
          border: 'none',
          background: actif ? '#111' : 'transparent',
          color: actif ? 'white' : '#333',
          fontSize: 14,
          fontWeight: 500,
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          gap: 4,
        }}
      >
        {label} <span style={{ fontSize: 10 }}>▾</span>
      </button>
      {ouvert && (
        <div
          onClick={() => setOuvert(false)}
          style={{
            position: 'absolute', top: '100%', left: 0, marginTop: 4,
            background: 'white', border: '1px solid #e5e5e0', borderRadius: 8,
            boxShadow: '0 4px 12px rgba(0,0,0,0.08)', minWidth: 170, zIndex: 50,
            display: 'flex', flexDirection: 'column', padding: 6,
          }}
        >
          {children}
        </div>
      )}
    </div>
  );
}

export default function NavBar() {
  const location = useLocation();
  const navigate = useNavigate();
  const [dernierDatePlanSalle, setDernierDatePlanSalle] = useState(null);
  const username = localStorage.getItem('lolive_username');

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

  const itemMenuStyle = (path) => ({
    padding: '8px 12px',
    borderRadius: 6,
    textDecoration: 'none',
    fontSize: 13,
    fontWeight: 500,
    color: location.pathname === path ? '#111' : '#333',
    background: location.pathname === path ? '#f0f0ee' : 'transparent',
    whiteSpace: 'nowrap',
  });

  const urlPlanSalle = dernierDatePlanSalle ? '/?date=' + dernierDatePlanSalle : '/';
  const suffixeDate = dernierDatePlanSalle ? '?date=' + dernierDatePlanSalle : '';

  const seDeconnecter = () => {
    localStorage.removeItem('lolive_token');
    localStorage.removeItem('lolive_username');
    navigate('/login');
  };

  const cheminsGestion = ['/articles', '/achats', '/clients', '/composants', '/encaissements-mois', '/controle'];
  const cheminsRapports = ['/cout-matiere', '/reservations', '/historique'];
  const cheminsStatistiques = ['/statistiques/montants-annuels', '/statistiques/plats-demandes', '/statistiques/frequentation'];

  return (
    <div style={{
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      padding: '12px 24px',
      borderBottom: '1px solid #e5e5e0',
      background: 'white',
    }}>
      <Link to={urlPlanSalle} style={linkStyle('/')}>Plan de salle</Link>
      <Link to={'/encaissements' + suffixeDate} style={linkStyle('/encaissements')}>Encaissements</Link>
      <Link to={'/recap' + suffixeDate} style={linkStyle('/recap')}>Récap</Link>
      <Link to="/personnel" style={linkStyle('/personnel')}>Personnel</Link>

      <MenuDeroulant label="Gestion" actif={cheminsGestion.includes(location.pathname)}>
        <Link to="/articles" style={itemMenuStyle('/articles')}>Articles</Link>
        <Link to="/achats" style={itemMenuStyle('/achats')}>Achats</Link>
        <Link to="/composants" style={itemMenuStyle('/composants')}>Composants</Link>
        <Link to="/clients" style={itemMenuStyle('/clients')}>Clients</Link>
        <Link to="/encaissements-mois" style={itemMenuStyle('/encaissements-mois')}>Encaissements (mois)</Link>
        <Link to="/controle" style={itemMenuStyle('/controle')}>🔍 Contrôle</Link>
      </MenuDeroulant>

      <MenuDeroulant label="Rapports" actif={cheminsRapports.includes(location.pathname)}>
        <Link to="/cout-matiere" style={itemMenuStyle('/cout-matiere')}>Coût matière</Link>
        <Link to="/reservations" style={itemMenuStyle('/reservations')}>Réservations</Link>
        <Link to={'/historique' + suffixeDate} style={itemMenuStyle('/historique')}>Historique</Link>
      </MenuDeroulant>

      <MenuDeroulant label="Statistiques" actif={cheminsStatistiques.includes(location.pathname)}>
        <Link to="/statistiques/montants-annuels" style={itemMenuStyle('/statistiques/montants-annuels')}>Montants annuels</Link>
        <Link to="/statistiques/plats-demandes" style={itemMenuStyle('/statistiques/plats-demandes')}>Plats les plus demandés</Link>
        <Link to="/statistiques/frequentation" style={itemMenuStyle('/statistiques/frequentation')}>Fréquentation</Link>
      </MenuDeroulant>

      <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 12 }}>
        {username && <span style={{ fontSize: 13, color: '#888' }}>{username}</span>}
        <button
          onClick={seDeconnecter}
          style={{
            padding: '6px 14px', borderRadius: 8, border: '1px solid #ddd',
            background: 'white', color: '#888', fontSize: 13, cursor: 'pointer',
          }}
        >
          Se déconnecter
        </button>
      </div>
    </div>
  );
}