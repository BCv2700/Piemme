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

export function genererDonneesTicket({
  encaissementId, dateEncaissement, tableNom,
  lignes, montantCash, montantCarte, montantTotal, nbPersonnes,
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
  };
}

// Construit les données de ticket directement à partir d'un encaissement tel
// que renvoyé par l'API (GET /encaissements/ ou POST /encaissements/), sans
// avoir besoin de recharger table/articles séparément. Utile pour réimprimer
// un ticket depuis la liste des encaissements.
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

// Calcule à l'avance la hauteur de papier nécessaire (en mm) pour un ticket
// donné, en fonction de son contenu réel (nombre de lignes, présence d'une
// table, d'un paiement carte/cash, nombre de taux de TVA utilisés...).
// Reprend exactement les mêmes incréments de "y" que la fonction de dessin
// ci-dessous, afin que la page fasse toujours la bonne taille : ni trop
// courte (contenu coupé), ni trop longue (papier vierge gaspillé — c'est ce
// qui causait l'impression d'un ticket suivi d'un long espace blanc).
function calculerHauteurTicket(data) {
  let y = 8;
  y += 5 + 4 + 4; // nom, adresse, code postal/ville
  y += data.telephones.length * 4;
  y += 4; // tva
  y += 6; // espace après en-tête
  y += 6; // date
  if (data.table) y += 6;
  y += data.lignes.length * 5;
  y += 2;
  y += 6; // total des achats
  y += 6; // à payer
  y += 8; // pers. - prix/pers.
  if (data.montantCarte > 0) y += 5;
  if (data.montantCash > 0) y += 5;
  y += 4;
  y += 8; // ref ticket
  y += 4 + 8; // merci pour votre visite / et à bientôt
  const nbTauxUtilises = [6, 12, 21].filter(t => data.tvaParTaux[t] > 0).length;
  y += nbTauxUtilises * 5;
  y += 8; // marge de bas de page

  const HAUTEUR_MIN = 60; // évite un ticket ridiculement court même sur un cas extrême
  return Math.max(HAUTEUR_MIN, Math.round(y));
}

// Génère le PDF du ticket et l'ouvre dans un nouvel onglet du navigateur.
export function genererPdfTicket(data) {
  const hauteur = calculerHauteurTicket(data);
  const doc = new jsPDF({ unit: 'mm', format: [80, hauteur] });
  let y = 8;
  doc.setFont('courier', 'normal');
  doc.setFontSize(10);
  doc.text(data.nom, 40, y, { align: 'center' }); y += 5;
  doc.text(data.adresse, 40, y, { align: 'center' }); y += 4;
  doc.text(data.codePostalVille, 40, y, { align: 'center' }); y += 4;
  data.telephones.forEach(tel => { doc.text('Tel : ' + tel, 40, y, { align: 'center' }); y += 4; });
  doc.text(data.tva, 40, y, { align: 'center' }); y += 6;
  doc.text(new Date(data.date).toLocaleDateString('fr-BE'), 40, y, { align: 'center' }); y += 6;
  if (data.table) {
    doc.text(data.table, 4, y);
    y += 6;
  }
  data.lignes.forEach(l => {
    doc.text(String(l.quantite), 4, y);
    doc.text(l.nom.slice(0, 22), 12, y);
    doc.text(l.total.toFixed(2), 76, y, { align: 'right' });
    y += 5;
  });
  y += 2;
  doc.text('Total des achats :', 4, y);
  doc.text(data.montantTotal.toFixed(2), 76, y, { align: 'right' });
  y += 6;
  doc.text('à payer :', 4, y);
  doc.text(data.montantTotal.toFixed(2), 76, y, { align: 'right' });
  y += 6;
  doc.text(data.nbPersonnes + ' pers. - Prix/pers. :', 4, y);
  doc.text(data.prixParPersonne.toFixed(2), 76, y, { align: 'right' });
  y += 8;
  if (data.montantCarte > 0) {
    doc.text('Bancontact :', 4, y);
    doc.text(data.montantCarte.toFixed(2), 76, y, { align: 'right' });
    y += 5;
  }
  if (data.montantCash > 0) {
    doc.text('Cash :', 4, y);
    doc.text(data.montantCash.toFixed(2), 76, y, { align: 'right' });
    y += 5;
  }
  y += 4;
  doc.text('Ref ticket : ' + data.numeroTicket, 4, y); y += 8;
  doc.text('MERCI POUR VOTRE VISITE', 40, y, { align: 'center' }); y += 4;
  doc.text('ET A BIENTÔT.', 40, y, { align: 'center' }); y += 8;
  [6, 12, 21].forEach(taux => {
    if (data.tvaParTaux[taux] > 0) {
      doc.text('TVA ' + taux + '%', 4, y);
      doc.text(data.tvaParTaux[taux].toFixed(2), 76, y, { align: 'right' });
      y += 5;
    }
  });
  const blobUrl = doc.output('bloburl');
  window.open(blobUrl, '_blank');
}