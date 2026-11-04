#!/bin/bash
echo ""
echo "Création de la base locale piemme_local..."
psql postgres -c "CREATE DATABASE piemme_local;" 2>/dev/null && echo "Base piemme_local créée." || echo "La base piemme_local existe déjà (c'est OK)."
echo "Prêt. Lance maintenant : bash dev.sh"
echo ""
