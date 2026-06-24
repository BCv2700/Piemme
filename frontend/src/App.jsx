import { BrowserRouter, Routes, Route } from 'react-router-dom';
import NavBar from './components/NavBar';
import PlanSalle from './pages/PlanSalle';
import Caddy from './pages/Caddy';
import Paiement from './pages/Paiement';
import Articles from './pages/Articles';
import Reservations from './pages/Reservations';
import HistoriqueVentes from './pages/HistoriqueVentes';
import Encaissements from './pages/Encaissements';
import RecapMensuel from './pages/RecapMensuel';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <NavBar />
      <Routes>
        <Route path="/" element={<PlanSalle />} />
        <Route path="/caddy/:tableId" element={<Caddy />} />
        <Route path="/paiement/:tableId" element={<Paiement />} />
        <Route path="/articles" element={<Articles />} />
        <Route path="/reservations" element={<Reservations />} />
        <Route path="/historique" element={<HistoriqueVentes />} />
        <Route path="/encaissements" element={<Encaissements />} />
        <Route path="/recap" element={<RecapMensuel />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;