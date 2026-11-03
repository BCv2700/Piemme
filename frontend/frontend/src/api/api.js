import axios from "axios";

// En local : utilise localhost:8000 par défaut.
// En production (Vercel) : utilise la variable d'environnement VITE_API_URL,
// définie dans les réglages du projet Vercel avec l'URL Railway du backend.
const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

const api = axios.create({
  baseURL: BASE_URL,
});

// Ajoute automatiquement le jeton de connexion à chaque requête, s'il existe.
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('lolive_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Si le serveur répond 401 (jeton invalide ou expiré), on déconnecte
// automatiquement et on renvoie vers l'écran de connexion.
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      localStorage.removeItem('lolive_token');
      localStorage.removeItem('lolive_username');
      if (window.location.pathname !== '/login') {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default api;