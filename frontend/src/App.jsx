import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import PiemmeMensuel from './pages/PiemmeMensuel';
import Administration from './pages/Administration';

function RouteProtegee({ children }) {
  const token = localStorage.getItem('piemme_token');
  if (!token) return <Navigate to="/login" replace />;
  return children;
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<RouteProtegee><PiemmeMensuel /></RouteProtegee>} />
        <Route path="/administration" element={<RouteProtegee><Administration /></RouteProtegee>} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
