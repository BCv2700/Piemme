import jsPDF from 'jspdf';

// Coordonnées du restaurant — à modifier ici si elles changent un jour
export const COORDONNEES_RESTAURANT = {
  nom: "L'Olive",
  adresse: "Rue St Laurent, 318",
  codePostalVille: "4000 Liège",
  telephones: ["0495/313433", "0496/318318"],
  tva: "BE 0867.739.432",
};

export function calculerTvaParTaux(lignes) {
  const taux = [6, 12, 21];
  const totaux = {};
  taux.forEach(t => { totaux[t] = 0; });
  lignes.forEach(l => {
    const montantLigne = Number(l.prix_vente) * Number(l.quantite);
    const t = Number(l.tva);
    if (totaux[t] !== undefined) {
      totaux[t] += montantLigne;
    }
  });
  return totaux;
}

// estTicketFinal : true pour le ticket réel de paiement / sa réimpression
// (téléphones, TVA, numéro de ticket et message de remerciement affichés) ;
// false pour l'addition provisoire imprimée depuis le Caddy avant paiement
// (ces infos n'y ont pas de sens : pas encore de vrai numéro de ticket, pas
// encore de "merci pour votre visite" puisque le client n'a pas encore payé).
export function genererDonneesTicket({
  encaissementId, dateEncaissement, tableNom,
  lignes, montantCash, montantCarte, montantTotal, nbPersonnes,
  estTicketFinal = true,
}) {
  // Nombre de personnes : toujours au moins 1, pour ne jamais diviser par zéro
  // et pour rester cohérent même si la valeur n'a pas été transmise (anciens
  // encaissements réimprimés, par exemple).
  const nb = Number(nbPersonnes) > 0 ? Number(nbPersonnes) : 1;
  return {
    ...COORDONNEES_RESTAURANT,
    numeroTicket: encaissementId,
    date: dateEncaissement,
    table: tableNom,
    lignes: lignes.map(l => ({
      nom: l.article_nom,
      quantite: Number(l.quantite),
      total: Number(l.prix_vente) * Number(l.quantite),
    })),
    montantTotal: Number(montantTotal),
    montantCash: Number(montantCash),
    montantCarte: Number(montantCarte),
    tvaParTaux: calculerTvaParTaux(lignes),
    nbPersonnes: nb,
    prixParPersonne: Number(montantTotal) / nb,
    estTicketFinal,
  };
}

// Construit les données de ticket directement à partir d'un encaissement tel
// que renvoyé par l'API (GET /encaissements/ ou POST /encaissements/), sans
// avoir besoin de recharger table/articles séparément. Utile pour réimprimer
// un ticket depuis la liste des encaissements. Ticket final complet
// (estTicketFinal reste à true par défaut).
export function genererDonneesTicketDepuisEncaissement(enc) {
  return genererDonneesTicket({
    encaissementId: enc.id,
    dateEncaissement: enc.date_encaissement,
    tableNom: enc.table_nom,
    lignes: enc.lignes || [],
    montantCash: enc.montant_cash,
    montantCarte: enc.montant_carte,
    montantTotal: enc.montant_total,
    nbPersonnes: enc.nb_personnes,
  });
}

// ─── Largeur du papier : réglable par ordinateur, mémorisée dans ce navigateur ───
// Chaque poste (Mac maison avec l'imprimante 58mm, PC caisse resto avec la
// TSP100 80mm) mémorise son propre réglage indéfiniment, via localStorage.
// Pas besoin de modifier le code ni de redéployer en changeant de poste :
// un simple clic sur le bouton de réglage (voir Encaissements.jsx) suffit,
// une seule fois par ordinateur.
const CLE_STOCKAGE_LARGEUR = 'lolive_largeur_ticket_mm';
const LARGEURS_VALIDES = [58, 80];
const LARGEUR_PAR_DEFAUT = 58;

export function obtenirLargeurPapier() {
  try {
    const v = Number(localStorage.getItem(CLE_STOCKAGE_LARGEUR));
    return LARGEURS_VALIDES.includes(v) ? v : LARGEUR_PAR_DEFAUT;
  } catch {
    return LARGEUR_PAR_DEFAUT;
  }
}

export function definirLargeurPapier(mm) {
  if (!LARGEURS_VALIDES.includes(mm)) return;
  try {
    localStorage.setItem(CLE_STOCKAGE_LARGEUR, String(mm));
  } catch {
    // localStorage indisponible (navigation privée, etc.) : le réglage ne sera
    // pas mémorisé d'une session à l'autre, mais l'impression en cours fonctionnera.
  }
}

const TAILLE_POLICE = 12; // le gras + contour suffisent maintenant pour la netteté
const STYLE_POLICE = 'bold';

// Calcule toutes les positions et largeurs disponibles à partir de la largeur
// de papier choisie. hauteurLigneEntete (en-tête) est volontairement plus
// resserrée que hauteurLigne (corps du ticket), pour un haut de ticket
// nettement plus court.
function calculerMiseEnPage(largeurMm) {
  const marge = largeurMm >= 80 ? 4 : 3;
  const xGauche = marge;
  const xCentre = largeurMm / 2;
  const xDroite = largeurMm - marge;
  const largeurDispoCentre = largeurMm - 2 * marge;
  const largeurDispoLabel = largeurMm - 2 * marge;
  const hauteurLigne = 7;
  const hauteurLigneEntete = 4; // environ moitié de hauteurLigne, pour un en-tête plus compact
  return { marge, xGauche, xCentre, xDroite, largeurDispoCentre, largeurDispoLabel, hauteurLigne, hauteurLigneEntete };
}

// Construit la liste complète des lignes de texte à imprimer, avec leur
// position (x, y) et alignement déjà calculés — en repliant automatiquement
// tout texte trop long sur plusieurs lignes selon la largeur disponible.
// measureDoc sert uniquement à mesurer le texte (splitTextToSize), sa taille
// de page n'a pas d'importance : c'est la même police/taille que le document
// final, donc les mesures sont exactes.
function construireLignesTicket(data, mise, measureDoc) {
  const lignes = [];
  let y = 4;

  const ajouter = (texte, x, align) => { lignes.push({ texte, x, y, align }); };
  const ajouterMultiligne = (texte, x, align, largeurDispo, hauteurLigne = mise.hauteurLigne) => {
    measureDoc.splitTextToSize(String(texte), largeurDispo).forEach(morceau => {
      ajouter(morceau, x, align);
      y += hauteurLigne;
    });
  };
  const ajouterLabelPuisValeur = (label, valeur) => {
    ajouterMultiligne(label, mise.xGauche, 'left', mise.largeurDispoLabel);
    // La valeur vient sur sa propre ligne, alignée à droite, pour ne jamais
    // risquer de chevaucher un libellé long à cette taille de police.
    ajouter(valeur, mise.xDroite, 'right');
    y += mise.hauteurLigne;
  };

  // En-tête, resserré (hauteurLigneEntete) : nom du restaurant, puis
  // téléphones et TVA uniquement sur le ticket final (pas sur l'addition).
  // Ni l'adresse ni la ville ne sont imprimées, sur aucun des deux types.
  ajouterMultiligne(data.nom, mise.xCentre, 'center', mise.largeurDispoCentre, mise.hauteurLigneEntete);
  if (data.estTicketFinal) {
    data.telephones.forEach(tel => ajouterMultiligne(tel, mise.xCentre, 'center', mise.largeurDispoCentre, mise.hauteurLigneEntete));
    ajouterMultiligne(data.tva, mise.xCentre, 'center', mise.largeurDispoCentre, mise.hauteurLigneEntete);
  }
  y += 1;
  ajouterMultiligne(new Date(data.date).toLocaleDateString('fr-BE'), mise.xCentre, 'center', mise.largeurDispoCentre, mise.hauteurLigneEntete);
  if (data.table) {
    ajouterMultiligne(data.table, mise.xGauche, 'left', mise.largeurDispoLabel, mise.hauteurLigneEntete);
  }
  y += 2;

  // Chaque article : quantité + nom sur une (ou plusieurs, si le nom est
  // long) ligne(s) pleine largeur, puis le prix seul sur la ligne suivante,
  // aligné à droite — plus de risque de chevauchement entre le nom et le
  // prix, quelle que soit la taille de police ou la largeur du papier.
  data.lignes.forEach(l => {
    ajouterMultiligne(l.quantite + ' ' + l.nom, mise.xGauche, 'left', mise.largeurDispoLabel);
    ajouter(l.total.toFixed(2), mise.xDroite, 'right');
    y += mise.hauteurLigne;
  });
  y += 2;

  ajouterLabelPuisValeur('Total :', data.montantTotal.toFixed(2));
  ajouterLabelPuisValeur('à payer :', data.montantTotal.toFixed(2));
  ajouterLabelPuisValeur(data.nbPersonnes + ' pers. - Prix/pers. :', data.prixParPersonne.toFixed(2));
  if (data.montantCarte > 0) ajouterLabelPuisValeur('Bancontact :', data.montantCarte.toFixed(2));
  if (data.montantCash > 0) ajouterLabelPuisValeur('Cash :', data.montantCash.toFixed(2));

  // Numéro de ticket + remerciement + détail TVA : uniquement sur le ticket
  // final (après paiement réel). Inutiles sur l'addition provisoire.
  if (data.estTicketFinal) {
    y += 2;
    ajouterMultiligne('Ref ticket : ' + data.numeroTicket, mise.xGauche, 'left', mise.largeurDispoLabel);
    y += 2;
    ajouterMultiligne('MERCI POUR VOTRE VISITE', mise.xCentre, 'center', mise.largeurDispoCentre);
    ajouterMultiligne('ET A BIENTÔT.', mise.xCentre, 'center', mise.largeurDispoCentre);
    y += 2;
    [6, 12, 21].forEach(taux => {
      if (data.tvaParTaux[taux] > 0) {
        ajouter('TVA ' + taux + '%', mise.xGauche, 'left');
        ajouter(data.tvaParTaux[taux].toFixed(2), mise.xDroite, 'right');
        y += mise.hauteurLigne;
      }
    });
  }
  y += 8; // marge de bas de page

  return { lignes, hauteurTotale: Math.max(50, Math.round(y)) };
}

// Génère le PDF du ticket et l'ouvre dans un nouvel onglet du navigateur.
// La largeur de papier utilisée est celle réglée sur cet ordinateur (voir
// obtenirLargeurPapier / definirLargeurPapier ci-dessus).
export function genererPdfTicket(data) {
  const largeurMm = obtenirLargeurPapier();
  const mise = calculerMiseEnPage(largeurMm);

  // Document de mesure : sert uniquement à calculer les retours à la ligne
  // avec la police exacte utilisée à l'impression ; sa hauteur de page n'a
  // aucune importance puisqu'on n'y dessine rien.
  const measureDoc = new jsPDF({ unit: 'mm', format: [largeurMm, 10] });
  measureDoc.setFont('courier', STYLE_POLICE);
  measureDoc.setFontSize(TAILLE_POLICE);

  const { lignes, hauteurTotale } = construireLignesTicket(data, mise, measureDoc);

  // Document final, cette fois avec la hauteur exacte calculée ci-dessus —
  // ni trop courte (texte coupé), ni trop longue (papier vierge gaspillé).
  const doc = new jsPDF({ unit: 'mm', format: [largeurMm, hauteurTotale] });
  doc.setFont('courier', STYLE_POLICE);
  doc.setFontSize(TAILLE_POLICE);
  // Contour noir en plus du remplissage : dépose visuellement plus d'encre,
  // pour un rendu plus foncé sur une imprimante thermique.
  doc.setLineWidth(0.25);
  doc.setDrawColor(0, 0, 0);

  lignes.forEach(l => {
    doc.text(l.texte, l.x, l.y, { align: l.align, renderingMode: 'fillThenStroke' });
  });

  const blobUrl = doc.output('bloburl');
  window.open(blobUrl, '_blank');
}