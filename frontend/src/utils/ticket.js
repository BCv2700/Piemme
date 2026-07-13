import jsPDF from 'jspdf';

// ─── Coordonnées du restaurant ─────────────────────────────────────────────
export const COORDONNEES_RESTAURANT = {
  nom: "L'Olive",
  adresse: "Rue St Laurent, 318",
  telephones: ["0495/313433", "0496/318318"],
  tva: "BE 0867.739.432",
};

// ─── Largeur de papier mémorisée par poste (localStorage) ──────────────────
const CLE_LARGEUR = 'lolive_largeur_papier';
const LARGEUR_PAR_DEFAUT = 58; // mm (POP10 à la maison)

export function obtenirLargeurPapier() {
  try {
    const v = localStorage.getItem(CLE_LARGEUR);
    if (v === '80') return 80;
  } catch (e) { /* localStorage indisponible */ }
  return LARGEUR_PAR_DEFAUT;
}

export function definirLargeurPapier(largeur) {
  try { localStorage.setItem(CLE_LARGEUR, String(largeur)); } catch (e) { /* ignore */ }
}

// ─── Calcul TVA par taux ───────────────────────────────────────────────────
export function calculerTvaParTaux(lignes) {
  const taux = [6, 12, 21];
  const totaux = {};
  taux.forEach(t => { totaux[t] = 0; });
  lignes.forEach(l => {
    const montantLigne = Number(l.prix_vente) * Number(l.quantite);
    const t = Number(l.tva);
    if (totaux[t] !== undefined) totaux[t] += montantLigne;
  });
  return totaux;
}

// ─── Données de ticket ─────────────────────────────────────────────────────
export function genererDonneesTicket({
  encaissementId, dateEncaissement, tableNom,
  lignes, montantCash, montantCarte, montantTotal, nbPersonnes,
}) {
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

// ═══════════════════════════════════════════════════════════════════════════
// IMPRESSION DIRECTE (HTML + @page) — pour imprimantes thermiques
// ═══════════════════════════════════════════════════════════════════════════
// Utilise une iframe cachée avec @page { size: XXmm auto } pour que le
// navigateur envoie la BONNE taille de papier au driver de l'imprimante,
// sans passer par un PDF (qui serait réinterprété en A4 par le navigateur
// et causerait 1 mètre de papier blanc avant le contenu).

export function imprimerTicketDirect(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  const maxCar = largeur <= 58 ? 28 : 38; // caractères par ligne

  // Tronque ou enroule un texte pour la colonne de gauche
  const tronquer = (texte, max) => texte.length > max ? texte.substring(0, max) : texte;

  const lignesHtml = data.lignes.map(l => {
    const nom = tronquer(l.nom, maxCar - 8);
    return '<div class="line"><span>' + l.quantite + ' ' + nom + '</span><span>' + l.total.toFixed(2) + '</span></div>';
  }).join('');

  let corpsTicket = '';

  // En-tête
  corpsTicket += '<div class="center bold">' + data.nom + '</div>';
  corpsTicket += '<div class="center">' + data.adresse + '</div>';
  if (estTicketFinal) {
    data.telephones.forEach(t => { corpsTicket += '<div class="center">' + t + '</div>'; });
  }
  corpsTicket += '<hr>';

  // Date + table
  corpsTicket += '<div class="center">' + new Date(data.date).toLocaleDateString('fr-BE') + '</div>';
  if (data.table) corpsTicket += '<div>' + data.table + '</div>';
  corpsTicket += '<hr>';

  // Articles
  corpsTicket += lignesHtml;
  corpsTicket += '<hr>';

  // Totaux
  corpsTicket += '<div class="line bold"><span>TOTAL</span><span>' + data.montantTotal.toFixed(2) + ' €</span></div>';
  corpsTicket += '<div class="line"><span>Px/pers. (' + data.nbPersonnes + ')</span><span>' + data.prixParPersonne.toFixed(2) + ' €</span></div>';

  // Paiement
  if (data.montantCarte > 0) {
    corpsTicket += '<div class="line"><span>Bancontact</span><span>' + data.montantCarte.toFixed(2) + ' €</span></div>';
  }
  if (data.montantCash > 0) {
    corpsTicket += '<div class="line"><span>Cash</span><span>' + data.montantCash.toFixed(2) + ' €</span></div>';
  }

  if (estTicketFinal) {
    corpsTicket += '<hr>';
    corpsTicket += '<div>Ref ticket : ' + data.numeroTicket + '</div>';

    // TVA
    if (estTicketFinal) {
      const tauxUtilises = [6, 12, 21].filter(t => data.tvaParTaux[t] > 0);
      if (tauxUtilises.length > 0) {
        corpsTicket += '<hr>';
        tauxUtilises.forEach(t => {
          corpsTicket += '<div class="line"><span>TVA ' + t + '%</span><span>' + data.tvaParTaux[t].toFixed(2) + ' €</span></div>';
        });
      }
    }

    corpsTicket += '<hr>';
    corpsTicket += '<div class="center bold">MERCI POUR VOTRE VISITE</div>';
    corpsTicket += '<div class="center bold">ET À BIENTÔT.</div>';

    // TVA du restaurant
    corpsTicket += '<div class="center small">' + data.tva + '</div>';
  }

  const html = '<!DOCTYPE html><html><head><meta charset="utf-8"><style>'
    + '@page { size: ' + largeur + 'mm auto; margin: 0; }'
    + '* { box-sizing: border-box; margin: 0; padding: 0; }'
    + 'body { width: ' + largeur + 'mm; padding: 2mm; font-family: "Courier New", Courier, monospace; font-size: 12px; font-weight: bold; -webkit-print-color-adjust: exact; }'
    + '.center { text-align: center; }'
    + '.bold { font-weight: 900; }'
    + '.small { font-size: 10px; margin-top: 2mm; }'
    + '.line { display: flex; justify-content: space-between; }'
    + 'hr { border: none; border-top: 1px dashed #000; margin: 2mm 0; }'
    + 'div { line-height: 1.4; }'
    + '</style></head><body>'
    + corpsTicket
    + '</body></html>';

  // Créer une iframe cachée, y écrire le ticket, et lancer l'impression
  const iframe = document.createElement('iframe');
  iframe.style.cssText = 'position:fixed;left:-9999px;top:0;width:0;height:0;border:none;';
  document.body.appendChild(iframe);
  const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
  iframeDoc.open();
  iframeDoc.write(html);
  iframeDoc.close();

  // Petit délai pour que le rendu soit terminé avant d'imprimer
  setTimeout(() => {
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
    // Nettoyage après un délai suffisant
    setTimeout(() => {
      try { document.body.removeChild(iframe); } catch (e) { /* déjà retiré */ }
    }, 15000);
  }, 400);
}

// ═══════════════════════════════════════════════════════════════════════════
// GÉNÉRATION PDF — pour visualisation / sauvegarde (bouton 📄)
// ═══════════════════════════════════════════════════════════════════════════

function calculerHauteurTicket(data, estTicketFinal) {
  let y = 8;
  y += 5 + 4; // nom, adresse
  if (estTicketFinal) y += data.telephones.length * 4;
  y += 6; // espace
  y += 6; // date
  if (data.table) y += 6;
  y += data.lignes.length * 5;
  y += 2;
  y += 6; // total
  y += 6; // à payer
  y += 8; // prix/pers
  if (data.montantCarte > 0) y += 5;
  if (data.montantCash > 0) y += 5;
  if (estTicketFinal) {
    y += 4 + 8; // ref ticket
    y += 4 + 8; // merci
    const nbTauxUtilises = [6, 12, 21].filter(t => data.tvaParTaux[t] > 0).length;
    y += nbTauxUtilises * 5;
    y += 6; // TVA restaurant
  }
  y += 8;
  return Math.max(60, Math.round(y));
}

export function genererPdfTicket(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  const hauteur = calculerHauteurTicket(data, estTicketFinal);
  const doc = new jsPDF({ unit: 'mm', format: [largeur, hauteur] });
  const centre = largeur / 2;
  const droite = largeur - 4;
  let y = 8;

  doc.setFont('courier', 'bold');
  doc.setFontSize(12);

  // En-tête
  doc.text(data.nom, centre, y, { align: 'center' }); y += 5;
  doc.text(data.adresse, centre, y, { align: 'center' }); y += 4;
  if (estTicketFinal) {
    data.telephones.forEach(tel => { doc.text(tel, centre, y, { align: 'center' }); y += 4; });
  }
  y += 4;

  // Date + table
  doc.text(new Date(data.date).toLocaleDateString('fr-BE'), centre, y, { align: 'center' }); y += 6;
  if (data.table) { doc.text(data.table, 4, y); y += 6; }

  // Articles
  const maxCar = largeur <= 58 ? 20 : 28;
  data.lignes.forEach(l => {
    const nom = l.nom.length > maxCar ? l.nom.substring(0, maxCar) : l.nom;
    doc.text(String(l.quantite), 4, y);
    doc.text(nom, 12, y);
    doc.text(l.total.toFixed(2), droite, y, { align: 'right' });
    y += 5;
  });
  y += 2;

  // Totaux
  doc.text('TOTAL', 4, y);
  doc.text(data.montantTotal.toFixed(2) + ' €', droite, y, { align: 'right' });
  y += 6;
  doc.text('Px/pers. (' + data.nbPersonnes + ') :', 4, y);
  doc.text(data.prixParPersonne.toFixed(2) + ' €', droite, y, { align: 'right' });
  y += 8;

  if (data.montantCarte > 0) {
    doc.text('Bancontact :', 4, y);
    doc.text(data.montantCarte.toFixed(2) + ' €', droite, y, { align: 'right' });
    y += 5;
  }
  if (data.montantCash > 0) {
    doc.text('Cash :', 4, y);
    doc.text(data.montantCash.toFixed(2) + ' €', droite, y, { align: 'right' });
    y += 5;
  }

  if (estTicketFinal) {
    y += 4;
    doc.text('Ref ticket : ' + data.numeroTicket, 4, y); y += 8;

    [6, 12, 21].forEach(taux => {
      if (data.tvaParTaux[taux] > 0) {
        doc.text('TVA ' + taux + '%', 4, y);
        doc.text(data.tvaParTaux[taux].toFixed(2) + ' €', droite, y, { align: 'right' });
        y += 5;
      }
    });

    y += 2;
    doc.text('MERCI POUR VOTRE VISITE', centre, y, { align: 'center' }); y += 4;
    doc.text('ET À BIENTÔT.', centre, y, { align: 'center' }); y += 6;
    doc.setFontSize(9);
    doc.text(data.tva, centre, y, { align: 'center' });
  }

  const blobUrl = doc.output('bloburl');
  window.open(blobUrl, '_blank');
}
