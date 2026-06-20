import axios from "axios";

// En local : utilise localhost:8000 par défaut.
// En production (Vercel) : utilise la variable d'environnement VITE_API_URL,
// définie dans les réglages du projet Vercel avec l'URL Railway du backend.
const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

const api = axios.create({
  baseURL: BASE_URL,
});

export default api;