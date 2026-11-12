import { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import './App.css';
import Login from './pages/Login';
import PiemmeMensuel from './pages/PiemmeMensuel';
import Administration from './pages/Administration';
import SideBar from './components/SideBar';

function RouteProtegee({ children }) {
  const token = localStorage.getItem('piemme_token');
  if (!token) return <Navigate to="/login" replace />;
  return children;
}

function MiseEnPage({ children, onglet, setOnglet, navBar }) {
  const [menuOuvert, setMenuOuvert] = useState(false);
  return (
    <div className="layout">
      {/* Topbar */}
      <div className="mobile-topbar">
        <button className="hamburger" onClick={() => setMenuOuvert(v => !v)}>☰</button>
        <span className="mobile-topbar-titre">🏠 Piemme</span>
        {navBar && <div style={{marginLeft: 8}}>{navBar}</div>}
      </div>
      {/* Sidebar */}
      <SideBar
        menuOuvert={menuOuvert}
        setMenuOuvert={setMenuOuvert}
        onglet={onglet}
        setOnglet={setOnglet}
      />
      {/* Contenu principal */}
      <div className="main-content">
        {children}
      </div>
    </div>
  );
}

const MOIS_NOMS = ['','Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
const sNav = {padding:'2px 8px',borderRadius:12,border:'1px solid #ccc',fontSize:11,background:'white',color:'#333',cursor:'pointer',fontWeight:600};
const sPdf = (c) => ({padding:'2px 8px',borderRadius:4,border:`1px solid ${c}`,fontSize:10,background:'white',color:c,cursor:'pointer',fontWeight:600});
const sPdfFull = (c) => ({padding:'2px 8px',borderRadius:4,border:`1px solid ${c}`,fontSize:10,background:c,color:'white',cursor:'pointer',fontWeight:600});

async function fetchPdf(annee, mois, url, filename, inline=false) {
  const base = import.meta.env.VITE_API_URL || 'http://localhost:8001';
  const token = localStorage.getItem('piemme_token');
  const rep = await fetch(`${base}${url}`, { headers: { Authorization: `Bearer ${token}` } });
  if (!rep.ok) return;
  const blob = await rep.blob();
  const objUrl = URL.createObjectURL(blob);
  if (inline) { window.open(objUrl, '_blank'); setTimeout(() => URL.revokeObjectURL(objUrl), 60000); }
  else { const a = document.createElement('a'); a.href=objUrl; a.download=filename; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(objUrl); }
}

function AppPiemmeMensuel() {
  const [onglet, setOnglet] = useState('calendrier');
  const now = new Date();
  const [annee, setAnnee] = useState(now.getFullYear());
  const [mois, setMois] = useState(now.getMonth()+1);

  const nav = (d) => {
    let m = mois + d, a = annee;
    if (m > 12) { m = 1; a++; }
    if (m < 1)  { m = 12; a--; }
    setMois(m); setAnnee(a);
  };

  const navBar = (
    <div style={{display:'flex', alignItems:'center', gap:4, flexWrap:'wrap'}}>
      <button onClick={() => nav(-1)} style={sNav}>◀</button>
      <span style={{fontSize:12, fontWeight:700, color:'#0D1B2A', minWidth:72, textAlign:'center'}}>{MOIS_NOMS[mois]} {annee}</span>
      <button onClick={() => nav(1)} style={sNav}>▶</button>
      <button onClick={() => fetchPdf(annee, mois, `/piemme/mois/${annee}/${mois}/pdf?inline=true`, '', true)} style={sPdf('#1d4ed8')}>👁 Mois</button>
      <button onClick={() => fetchPdf(annee, mois, `/piemme/mois/${annee}/${mois}/pdf`, `piemme_${annee}_${String(mois).padStart(2,'0')}.pdf`)} style={sPdfFull('#1d4ed8')}>⬇ Mois</button>
      <button onClick={() => fetchPdf(annee, mois, `/piemme/annuel/${annee}/pdf?inline=true`, '', true)} style={sPdf('#d97706')}>👁 Année</button>
      <button onClick={() => fetchPdf(annee, mois, `/piemme/annuel/${annee}/pdf`, `piemme_annuel_${annee}.pdf`)} style={sPdfFull('#d97706')}>⬇ Année</button>
    </div>
  );

  return (
    <MiseEnPage onglet={onglet} setOnglet={setOnglet} navBar={navBar}>
      <PiemmeMensuel onglet={onglet} setOnglet={setOnglet} annee={annee} mois={mois} nav={nav} />
    </MiseEnPage>
  );
}

function AppAdministration() {
  return (
    <MiseEnPage onglet={null} setOnglet={() => {}}>
      <Administration />
    </MiseEnPage>
  );
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<RouteProtegee><AppPiemmeMensuel /></RouteProtegee>} />
        <Route path="/administration" element={<RouteProtegee><AppAdministration /></RouteProtegee>} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
