import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

export default function Login() {
  const navigate = useNavigate();
  const [username, setUsername] = useState('');
  const [motDePasse, setMotDePasse] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      // Appel direct via axios (pas via api.js) pour ne pas dépendre d'un
      // jeton qui n'existe pas encore à ce stade.
      const res = await axios.post(BASE_URL + '/auth/login', {
        username,
        mot_de_passe: motDePasse,
      });
      localStorage.setItem('lolive_token', res.data.access_token);
      localStorage.setItem('lolive_username', res.data.username);
      navigate('/');
    } catch (e) {
      setError("Nom d'utilisateur ou mot de passe incorrect");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      minHeight: '100vh', background: '#fafaf8',
    }}>
      <form
        onSubmit={handleSubmit}
        style={{
          background: 'white', border: '1px solid #e5e5e0', borderRadius: 12,
          padding: 32, width: 320, boxShadow: '0 2px 10px rgba(0,0,0,0.04)',
        }}
      >
        <h1 style={{ fontSize: 20, fontWeight: 700, margin: '0 0 24px', textAlign: 'center' }}>
          L'Olive
        </h1>

        {error && (
          <div style={{
            background: '#fee2e2', color: '#dc2626', border: '1px solid #fca5a5',
            borderRadius: 8, padding: '8px 12px', fontSize: 13, marginBottom: 16,
          }}>
            {error}
          </div>
        )}

        <label style={{ fontSize: 13, fontWeight: 600, color: '#555', display: 'block', marginBottom: 6 }}>
          Nom d'utilisateur
        </label>
        <input
          type="text"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          autoFocus
          style={{
            width: '100%', padding: '8px 12px', borderRadius: 8,
            border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box', marginBottom: 16,
          }}
        />

        <label style={{ fontSize: 13, fontWeight: 600, color: '#555', display: 'block', marginBottom: 6 }}>
          Mot de passe
        </label>
        <input
          type="password"
          value={motDePasse}
          onChange={(e) => setMotDePasse(e.target.value)}
          style={{
            width: '100%', padding: '8px 12px', borderRadius: 8,
            border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box', marginBottom: 24,
          }}
        />

        <button
          type="submit"
          disabled={loading}
          style={{
            width: '100%', padding: '10px 0', borderRadius: 8, border: 'none',
            background: '#111', color: 'white', fontSize: 14, fontWeight: 600,
            cursor: loading ? 'default' : 'pointer', opacity: loading ? 0.6 : 1,
          }}
        >
          {loading ? 'Connexion...' : 'Se connecter'}
        </button>
      </form>
    </div>
  );
}