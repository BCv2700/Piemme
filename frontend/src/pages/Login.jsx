import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/api';

export default function Login() {
  const navigate = useNavigate();
  const [username, setUsername] = useState('');
  const [motDePasse, setMotDePasse] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const res = await api.post('/auth/login', { username, mot_de_passe: motDePasse });
      localStorage.setItem('piemme_token', res.data.access_token);
      localStorage.setItem('piemme_username', res.data.username);
      localStorage.setItem('piemme_role', res.data.role);
      navigate('/');
    } catch {
      setError("Nom d'utilisateur ou mot de passe incorrect");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'center', minHeight:'100vh', background:'#fafaf8' }}>
      <form onSubmit={handleSubmit} style={{ background:'white', border:'1px solid #e5e5e0', borderRadius:12, padding:32, width:320, boxShadow:'0 2px 10px rgba(0,0,0,0.04)' }}>
        <h1 style={{ fontSize:20, fontWeight:700, margin:'0 0 6px', textAlign:'center' }}>Piemme</h1>
        <p style={{ fontSize:12, color:'#888', textAlign:'center', margin:'0 0 24px' }}>Gestion financière</p>
        {error && (
          <div style={{ background:'#fee2e2', color:'#dc2626', border:'1px solid #fca5a5', borderRadius:8, padding:'8px 12px', fontSize:13, marginBottom:16 }}>
            {error}
          </div>
        )}
        <label style={{ fontSize:13, fontWeight:600, color:'#555', display:'block', marginBottom:6 }}>Nom d'utilisateur</label>
        <input type="text" value={username} onChange={e => setUsername(e.target.value)} autoFocus
          style={{ width:'100%', padding:'8px 12px', borderRadius:8, border:'1px solid #ddd', fontSize:14, boxSizing:'border-box', marginBottom:16 }} />
        <label style={{ fontSize:13, fontWeight:600, color:'#555', display:'block', marginBottom:6 }}>Mot de passe</label>
        <div style={{ position:'relative' }}>
          <input type={showPassword ? 'text' : 'password'} value={motDePasse} onChange={e => setMotDePasse(e.target.value)}
            style={{ width:'100%', padding:'8px 36px 8px 12px', borderRadius:8, border:'1px solid #ddd', fontSize:14, boxSizing:'border-box', marginBottom:24 }} />
          <button type="button" onClick={() => setShowPassword(v => !v)}
            style={{ position:'absolute', right:8, top:8, background:'none', border:'none', cursor:'pointer', fontSize:16, color:'#888', padding:0, lineHeight:1 }}>
            {showPassword ? '🙈' : '👁'}
          </button>
        </div>
        <button type="submit" disabled={loading}
          style={{ width:'100%', padding:'10px 0', borderRadius:8, border:'none', background:'#111', color:'white', fontSize:14, fontWeight:600, cursor:loading ? 'default' : 'pointer', opacity:loading ? 0.6 : 1 }}>
          {loading ? 'Connexion...' : 'Se connecter'}
        </button>
      </form>
    </div>
  );
}
