# Contexte Piemme — reprise de conversation

## État au 03/11/2026

### Déploiement PROD ✅
- **Frontend** : https://soft.chezpiemme.be (Vercel, repo BCv2700/Piemme, dossier `frontend`)
- **Backend** : https://piemme-production.up.railway.app (Railway, projet `serene-respect`)
- **DB PROD** : PostgreSQL Railway — `postgresql://postgres:RoreYzpKGCPFyomSrCayFXwoeLiSngeE@junction.proxy.rlwy.net:51002/railway`
- **Login PROD** : piemme / piemme2026 ✅

### Stack
- Backend : FastAPI (Python), dossier `/Users/retina/Desktop/PIEMME/backend`
- Frontend : React/Vite, dossier `/Users/retina/Desktop/PIEMME/frontend`
- Auth : JWT, cookie `piemme_token`, bcrypt
- Repo GitHub : BCv2700/Piemme

### Variables Railway (backend)
- DATABASE_URL, SECRET_KEY, APP_NAME=Piemme, FRONTEND_URL, ALLOWED_ORIGINS, BREVO_API_KEY, BREVO_SENDER_EMAIL, BREVO_SENDER_NAME

### Tables DB (toutes migrées depuis LOLIVE)
- `utilisateurs` (id, username, mot_de_passe, actif, role)
- `piemme_jour` (70 lignes)
- `piemme_depense_recurrente` (6 lignes)
- `piemme_config` (3 lignes)
- `piemme_depense_detail` (63 lignes)
- `piemme_enveloppe` (5 lignes)
- `piemme_facture_retard` (7 lignes)

---

## Tâches à faire demain

### 1. Environnement local (comme LOLIVE)
- Créer un script `dev.sh` pour lancer backend + frontend en local
- Copier la DB PROD vers local (pg_dump depuis Railway vers PostgreSQL local)
  - DB locale à créer : `piemme_local` (ou utiliser `.env.local`)
  - Backend local sur port 8001, frontend sur port 5174 (ou autre libre)
- Fichier `.env` local avec `DATABASE_URL=postgresql://...local...`
- Affichage "LOCAL" dans l'interface quand on tourne en local (comme LOLIVE)

### 2. Script sync PROD → local
- Même approche que LOLIVE : pg_dump ou psql \COPY CSV par table
- Attention : pg_dump version mismatch (local v16, Railway v18) → utiliser psql \COPY CSV
- Script bash : `sync_prod_to_local.sh`

### 3. Page Administration
- Bouton "Administration" accessible depuis l'interface (admin uniquement)
- Fonctionnalités :
  - **Gestion mot de passe** : changer le mot de passe d'un utilisateur, ou réinitialiser à `piemme2026`
  - **Backup DB** : dump de la DB (structure + données) → fichier téléchargeable
  - **Backup appli** : archive du code source
  - S'inspirer de ce qui existe dans LOLIVE (`/Users/retina/Desktop/LOLIVE`)

### 4. Référence LOLIVE pour s'inspirer
- Affichage LOCAL : voir `/Users/retina/Desktop/LOLIVE/frontend/src/`
- Page admin LOLIVE : voir `/Users/retina/Desktop/LOLIVE/frontend/src/pages/`
- Script sync LOLIVE : voir `/Users/retina/Desktop/LOLIVE/`

---

## Règles importantes
- NE PAS réécrire le code, seulement corriger ou ajouter
- Vérifier que chaque modif existe bien sur le Mac avant de valider
- Ne pas répondre "tu as raison, je m'excuse"
- Demander accès au Mac si nécessaire (dossier PIEMME déjà connecté)
- Poser les questions en texte normal (pas de boutons/pop-up)
- Push prod : `git add -A && git commit -m "message" && git push` (dans frontend ou backend)

## Accès Mac
- Dossier connecté : `/Users/retina/Desktop/PIEMME`
- Dossier LOLIVE aussi connecté : `/Users/retina/Desktop/LOLIVE`
