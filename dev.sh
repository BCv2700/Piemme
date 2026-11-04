#!/bin/bash
BLEU='\033[0;34m'
VERT='\033[0;32m'
RESET='\033[0m'

echo ""
echo "Démarrage Piemme LOCAL..."
echo ""
echo -e "${BLEU}Backend${RESET}  → http://localhost:8001  (base locale piemme_local)"
echo -e "${VERT}Frontend${RESET} → http://localhost:5174"
echo ""
echo "Ctrl+C pour tout arrêter"
echo "──────────────────────────────────────────"

(cd ~/Desktop/PIEMME/backend && source ~/Desktop/PIEMME/backend/venv/bin/activate && ENV_FILE=.env.local python3.12 -m uvicorn app.main:app --reload --port 8001 2>&1 | sed 's/^/[BACKEND] /') &
PID_BACKEND=$!

sleep 2

(cd ~/Desktop/PIEMME/frontend && npm run dev -- --port 5174 2>&1 | sed 's/^/[FRONTEND] /') &
PID_FRONTEND=$!

sleep 3
open -a "Google Chrome" "http://localhost:5174"

trap "echo ''; echo 'Arrêt...'; kill $PID_BACKEND $PID_FRONTEND 2>/dev/null; exit 0" INT
wait
