import jsPDF from 'jspdf';
import qz from 'qz-tray';

// ─── Coordonnées du restaurant ─────────────────────────────────────────────
export const COORDONNEES_RESTAURANT = {
  nom: "L'Olive",
  adresse: "Rue St Laurent, 318",
  telephones: ["0495/313433", "0496/318318"],
  tva: "BE 0867.739.432",
};

// ─── Largeur de papier mémorisée par poste (localStorage) ──────────────────
const CLE_LARGEUR = 'lolive_largeur_papier';
const LARGEUR_PAR_DEFAUT = 80;

export function obtenirLargeurPapier() {
  try { const v = localStorage.getItem(CLE_LARGEUR); if (v === '80' || v === '58') return Number(v); } catch (e) {}
  return LARGEUR_PAR_DEFAUT;
}
export function definirLargeurPapier(largeur) {
  try { localStorage.setItem(CLE_LARGEUR, String(largeur)); } catch (e) {}
}

// ─── Nom de l'imprimante mémorisé par poste (localStorage) ─────────────────
const CLE_IMPRIMANTE = 'lolive_nom_imprimante';

export function obtenirNomImprimante() {
  try { return localStorage.getItem(CLE_IMPRIMANTE) || null; } catch (e) { return null; }
}
export function definirNomImprimante(nom) {
  try { localStorage.setItem(CLE_IMPRIMANTE, nom); } catch (e) {}
}

// ─── Calcul TVA par taux ───────────────────────────────────────────────────
export function calculerTvaParTaux(lignes) {
  const totaux = { 6: 0, 12: 0, 21: 0 };
  lignes.forEach(l => {
    const montant = Number(l.prix_vente) * Number(l.quantite);
    const t = Number(l.tva);
    if (totaux[t] !== undefined) totaux[t] += montant;
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
// ESC/POS : génère les commandes pour imprimante thermique
// ═══════════════════════════════════════════════════════════════════════════

const ESC = '\x1B';
const GS  = '\x1D';

// Nombre de caractères par ligne selon la largeur du papier
function nbCols(largeur) {
  return largeur >= 80 ? 42 : 32;
}

// Centre un texte sur n colonnes
function centrer(texte, cols) {
  if (texte.length >= cols) return texte.substring(0, cols);
  const pad = Math.floor((cols - texte.length) / 2);
  return ' '.repeat(pad) + texte;
}

// Aligne texte gauche + texte droit sur n colonnes
function alignerGaucheDroite(gauche, droite, cols) {
  const espace = cols - gauche.length - droite.length;
  if (espace <= 0) return (gauche + ' ' + droite).substring(0, cols);
  return gauche + ' '.repeat(espace) + droite;
}

// Ligne de séparation
function separateur(cols) {
  return '-'.repeat(cols);
}

function genererEscPos(data, estTicketFinal, largeur) {
  const cols = nbCols(largeur);
  const lignes = [];

  // Init imprimante
  lignes.push(ESC + '@');           // Reset
  lignes.push(ESC + 'a\x01');      // Centrage
  lignes.push(ESC + 'E\x01');      // Gras ON
  lignes.push(ESC + '!\x10');      // Double hauteur

  // En-tête
  lignes.push(data.nom + '\n');
  lignes.push(ESC + '!\x00');      // Taille normale
  lignes.push(data.adresse + '\n');

  if (estTicketFinal) {
    data.telephones.forEach(tel => lignes.push(tel + '\n'));
  }

  lignes.push(ESC + 'E\x00');      // Gras OFF
  lignes.push('\n');

  // Date + table
  const date = new Date(data.date).toLocaleDateString('fr-BE');
  lignes.push(date + '\n');
  lignes.push(ESC + 'a\x00');      // Alignement gauche
  if (data.table) lignes.push(data.table + '\n');
  lignes.push(separateur(cols) + '\n');

  // Articles
  lignes.push(ESC + 'E\x01');      // Gras ON
  data.lignes.forEach(l => {
    const qte = String(l.quantite) + 'x ';
    const prix = l.total.toFixed(2) + ' EUR';
    const nomMax = cols - qte.length - prix.length - 1;
    const nom = l.nom.length > nomMax ? l.nom.substring(0, nomMax) : l.nom;
    lignes.push(alignerGaucheDroite(qte + nom, prix, cols) + '\n');
  });
  lignes.push(ESC + 'E\x00');      // Gras OFF
  lignes.push(separateur(cols) + '\n');

  // Total
  lignes.push(ESC + 'E\x01');
  lignes.push(ESC + '!\x10');      // Double hauteur
  lignes.push(alignerGaucheDroite('TOTAL', data.montantTotal.toFixed(2) + ' EUR', cols) + '\n');
  lignes.push(ESC + '!\x00');
  lignes.push(ESC + 'E\x00');

  // Prix/pers
  const labelPers = 'Px/pers. (' + data.nbPersonnes + ') :';
  lignes.push(alignerGaucheDroite(labelPers, data.prixParPersonne.toFixed(2) + ' EUR', cols) + '\n');

  // Paiement
  if (data.montantCarte > 0) {
    lignes.push(alignerGaucheDroite('Bancontact :', data.montantCarte.toFixed(2) + ' EUR', cols) + '\n');
  }
  if (data.montantCash > 0) {
    lignes.push(alignerGaucheDroite('Cash :', data.montantCash.toFixed(2) + ' EUR', cols) + '\n');
  }

  if (estTicketFinal) {
    lignes.push(separateur(cols) + '\n');
    lignes.push('Ref ticket : ' + data.numeroTicket + '\n');

    // TVA
    [6, 12, 21].forEach(taux => {
      if (data.tvaParTaux[taux] > 0) {
        lignes.push(alignerGaucheDroite('TVA ' + taux + '%', data.tvaParTaux[taux].toFixed(2) + ' EUR', cols) + '\n');
      }
    });

    lignes.push('\n');
    lignes.push(ESC + 'a\x01');    // Centrage
    lignes.push(ESC + 'E\x01');
    lignes.push('MERCI POUR VOTRE VISITE\n');
    lignes.push('ET A BIENTOT.\n');
    lignes.push(ESC + 'E\x00');
    lignes.push(data.tva + '\n');
  }

  // Avance papier + coupe
  lignes.push('\n\n\n');
  lignes.push(GS + 'V\x41\x03');  // Coupe partielle

  return lignes;
}

// ═══════════════════════════════════════════════════════════════════════════
// QZ TRAY : connexion et impression ESC/POS
// ═══════════════════════════════════════════════════════════════════════════

let qzConnecte = false;

async function connecterQz() {
  if (qzConnecte && qz.websocket.isActive()) return;
  // Mode non signé
  qz.security.setCertificatePromise(() => Promise.resolve(''));
  qz.security.setSignatureAlgorithm('SHA512');
  qz.security.setSignaturePromise(() => () => Promise.resolve(''));
  await qz.websocket.connect();
  qzConnecte = true;
}

async function trouverImprimanteQz() {
  const nomSauvegarde = obtenirNomImprimante();
  if (nomSauvegarde) return nomSauvegarde;
  const imprimantes = await qz.printers.find();
  const star = imprimantes.find(p =>
    p.toLowerCase().includes('star') ||
    p.toLowerCase().includes('tsp') ||
    p.toLowerCase().includes('pop')
  );
  if (star) {
    definirNomImprimante(star);
    return star;
  }
  throw new Error('Aucune imprimante Star trouvée. Disponibles : ' + imprimantes.join(', '));
}

// ═══════════════════════════════════════════════════════════════════════════
// CRÉATION DU PDF (fallback Mac / bouton 📄)
// ═══════════════════════════════════════════════════════════════════════════

function calculerHauteurTicket(data, estTicketFinal) {
  let y = 8;
  y += 5 + 4;
  if (estTicketFinal) y += data.telephones.length * 4;
  y += 6;
  y += 6;
  if (data.table) y += 6;
  y += data.lignes.length * 9;
  y += 2;
  y += 6;
  y += 8;
  if (data.montantCarte > 0) y += 5;
  if (data.montantCash > 0) y += 5;
  if (estTicketFinal) {
    y += 4 + 8;
    const nbTaux = [6, 12, 21].filter(t => data.tvaParTaux[t] > 0).length;
    y += nbTaux * 5;
    y += 2 + 4 + 4 + 6;
  }
  y += 8;
  return Math.max(60, Math.round(y));
}

function creerDocPdf(data, estTicketFinal, largeur) {
  const hauteur = calculerHauteurTicket(data, estTicketFinal);
  const doc = new jsPDF({ unit: 'mm', format: [largeur, hauteur] });
  const centre = largeur / 2;
  const droite = largeur - 4;
  let y = 8;
  doc.setFont('courier', 'bold');
  doc.setFontSize(12);
  doc.text(data.nom, centre, y, { align: 'center' }); y += 5;
  doc.text(data.adresse, centre, y, { align: 'center' }); y += 4;
  if (estTicketFinal) {
    data.telephones.forEach(tel => { doc.text(tel, centre, y, { align: 'center' }); y += 4; });
  }
  y += 4;
  doc.text(new Date(data.date).toLocaleDateString('fr-BE'), centre, y, { align: 'center' }); y += 6;
  if (data.table) { doc.text(data.table, 4, y); y += 6; }
  data.lignes.forEach(l => {
    doc.text(String(l.quantite) + '  ' + l.nom, 4, y);
    y += 4;
    doc.text(l.total.toFixed(2) + ' €', droite, y, { align: 'right' });
    y += 5;
  });
  y += 2;
  doc.text('TOTAL', 4, y);
  doc.text(data.montantTotal.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 6;
  doc.text('Px/pers. (' + data.nbPersonnes + ') :', 4, y);
  doc.text(data.prixParPersonne.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 8;
  if (data.montantCarte > 0) {
    doc.text('Bancontact :', 4, y);
    doc.text(data.montantCarte.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 5;
  }
  if (data.montantCash > 0) {
    doc.text('Cash :', 4, y);
    doc.text(data.montantCash.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 5;
  }
  if (estTicketFinal) {
    y += 4;
    doc.text('Ref ticket : ' + data.numeroTicket, 4, y); y += 8;
    [6, 12, 21].forEach(taux => {
      if (data.tvaParTaux[taux] > 0) {
        doc.text('TVA ' + taux + '%', 4, y);
        doc.text(data.tvaParTaux[taux].toFixed(2) + ' €', droite, y, { align: 'right' }); y += 5;
      }
    });
    y += 2;
    doc.text('MERCI POUR VOTRE VISITE', centre, y, { align: 'center' }); y += 4;
    doc.text('ET A BIENTOT.', centre, y, { align: 'center' }); y += 6;
    doc.setFontSize(9);
    doc.text(data.tva, centre, y, { align: 'center' });
  }
  return doc;
}

// ═══════════════════════════════════════════════════════════════════════════
// FONCTION PRINCIPALE : imprimerTicket
// QZ Tray ESC/POS si disponible → sinon PDF dans un onglet (Mac)
// ═══════════════════════════════════════════════════════════════════════════

export async function imprimerTicket(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  try {
    await connecterQz();
    const imprimante = await trouverImprimanteQz();
    const config = qz.configs.create(imprimante);
    const commandes = genererEscPos(data, estTicketFinal, largeur);
    await qz.print(config, commandes.map(c => ({ type: 'raw', format: 'plain', data: c })));
  } catch (err) {
    console.warn('QZ Tray indisponible, fallback PDF :', err.message || err);
    genererPdfTicket(data, estTicketFinal);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// genererPdfTicket : ouvre le PDF dans un nouvel onglet (bouton 📄 / Mac)
// ═══════════════════════════════════════════════════════════════════════════

export function genererPdfTicket(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  const doc = creerDocPdf(data, estTicketFinal, largeur);
  const blobUrl = doc.output('bloburl');
  window.open(blobUrl, '_blank');
}
