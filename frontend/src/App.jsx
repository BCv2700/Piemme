import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import NavBar from './components/NavBar';
import Login from './pages/Login';
import PlanSalle from './pages/PlanSalle';
import Caddy from './pages/Caddy';
import Paiement from './pages/Paiement';
import Articles from './pages/Articles';
import Achats from './pages/Achats';
import Clients from './pages/Clients';
import CoutMatiere from './pages/CoutMatiere';
import Composants from './pages/Composants';
import EncaissementsMois from './pages/EncaissementsMois';
import Reservations from './pages/Reservations';
import HistoriqueVentes from './pages/HistoriqueVentes';
import Encaissements from './pages/Encaissements';
import RecapMensuel from './pages/RecapMensuel';
import RecapDepensesAnnuel from './pages/RecapDepensesAnnuel';
import ControleEncaissements from './pages/ControleEncaissements';
import MontantsAnnuels from './pages/MontantsAnnuels';
import PlatsDemandes from './pages/PlatsDemandes';
import Frequentation from './pages/Frequentation';
import Personnel from './pages/Personnel';
import './App.css';

// Empêche l'accès à une page si aucun jeton n'est présent : redirige vers /login.
function RouteProtegee({ children }) {
  const token = localStorage.getItem('lolive_token');
  if (!token) {
    return <Navigate to="/login" replace />;
  }
  return children;
}

// Affiche la NavBar uniquement sur les pages protégées (pas sur /login).
function MiseEnPage({ children }) {
  return (
    <>
      <NavBar />
      {children}
    </>
  );
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<RouteProtegee><MiseEnPage><PlanSalle /></MiseEnPage></RouteProtegee>} />
        <Route path="/caddy/:tableId" element={<RouteProtegee><MiseEnPage><Caddy /></MiseEnPage></RouteProtegee>} />
        <Route path="/paiement/:tableId" element={<RouteProtegee><MiseEnPage><Paiement /></MiseEnPage></RouteProtegee>} />
        <Route path="/articles" element={<RouteProtegee><MiseEnPage><Articles /></MiseEnPage></RouteProtegee>} />
        <Route path="/achats" element={<RouteProtegee><MiseEnPage><Achats /></MiseEnPage></RouteProtegee>} />
        <Route path="/clients" element={<RouteProtegee><MiseEnPage><Clients /></MiseEnPage></RouteProtegee>} />
        <Route path="/cout-matiere" element={<RouteProtegee><MiseEnPage><CoutMatiere /></MiseEnPage></RouteProtegee>} />
        <Route path="/composants" element={<RouteProtegee><MiseEnPage><Composants /></MiseEnPage></RouteProtegee>} />
        <Route path="/encaissements-mois" element={<RouteProtegee><MiseEnPage><EncaissementsMois /></MiseEnPage></RouteProtegee>} />
        <Route path="/reservations" element={<RouteProtegee><MiseEnPage><Reservations /></MiseEnPage></RouteProtegee>} />
        <Route path="/historique" element={<RouteProtegee><MiseEnPage><HistoriqueVentes /></MiseEnPage></RouteProtegee>} />
        <Route path="/encaissements" element={<RouteProtegee><MiseEnPage><Encaissements /></MiseEnPage></RouteProtegee>} />
        <Route path="/recap" element={<RouteProtegee><MiseEnPage><RecapMensuel /></MiseEnPage></RouteProtegee>} />
        <Route path="/depenses-annuelles" element={<RouteProtegee><MiseEnPage><RecapDepensesAnnuel /></MiseEnPage></RouteProtegee>} />
        <Route path="/controle" element={<RouteProtegee><MiseEnPage><ControleEncaissements /></MiseEnPage></RouteProtegee>} />
        <Route path="/statistiques/montants-annuels" element={<RouteProtegee><MiseEnPage><MontantsAnnuels /></MiseEnPage></RouteProtegee>} />
        <Route path="/statistiques/plats-demandes" element={<RouteProtegee><MiseEnPage><PlatsDemandes /></MiseEnPage></RouteProtegee>} />
        <Route path="/statistiques/frequentation" element={<RouteProtegee><MiseEnPage><Frequentation /></MiseEnPage></RouteProtegee>} />
        <Route path="/personnel" element={<RouteProtegee><MiseEnPage><Personnel /></MiseEnPage></RouteProtegee>} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;