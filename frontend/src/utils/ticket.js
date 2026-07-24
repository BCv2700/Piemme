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
const LARGEUR_PAR_DEFAUT = 80;

export function obtenirLargeurPapier() {
  try { const v = localStorage.getItem(CLE_LARGEUR); if (v === '80' || v === '72') return Number(v); } catch (e) {}
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
// QZ TRAY : impression directe sans boîte de dialogue
// ═══════════════════════════════════════════════════════════════════════════

let qzModule = null;

async function chargerQzTray() {
  if (qzModule) return qzModule;
  if (window.qz) { qzModule = window.qz; return qzModule; }
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/qz-tray@2.2.4/qz-tray.js';
    script.onload = () => { qzModule = window.qz; resolve(qzModule); };
    script.onerror = () => reject(new Error('Bibliothèque QZ Tray introuvable'));
    document.head.appendChild(script);
  });
}

async function connecterQzTray() {
  const qz = await chargerQzTray();
  if (!qz.websocket.isActive()) {
    // Unsigned mode : QZ Tray affiche une boîte "Faire confiance ?" une seule fois
    if (qz.security && qz.security.setCertificatePromise) {
      qz.security.setCertificatePromise(() => Promise.resolve(''));
    }
    if (qz.security && qz.security.setSignaturePromise) {
      qz.security.setSignaturePromise(() => () => Promise.resolve(''));
    }
    await qz.websocket.connect();
  }
  return qz;
}

async function trouverImprimante(qz) {
  // D'abord vérifier localStorage
  const nomSauvegarde = obtenirNomImprimante();
  if (nomSauvegarde) return nomSauvegarde;
  // Sinon chercher automatiquement une imprimante Star
  const imprimantes = await qz.printers.find();
  const star = imprimantes.find(p =>
    p.toLowerCase().includes('star') ||
    p.toLowerCase().includes('tsp') ||
    p.toLowerCase().includes('pop')
  );
  if (star) {
    definirNomImprimante(star);
    console.log('Imprimante détectée et mémorisée :', star);
    return star;
  }
  throw new Error('Aucune imprimante Star détectée. Imprimantes trouvées : ' + imprimantes.join(', '));
}

// ═══════════════════════════════════════════════════════════════════════════
// CRÉATION DU PDF (utilisé par QZ Tray ET par l'ouverture dans un onglet)
// ═══════════════════════════════════════════════════════════════════════════

function calculerHauteurTicket(data, estTicketFinal) {
  let y = 8;
  y += 5 + 4; // nom, adresse
  if (estTicketFinal) y += data.telephones.length * 4;
  y += 6; // espace
  y += 6; // date
  if (data.table) y += 6;
  y += data.lignes.length * 9; // 2 lignes par article (nom + prix)
  y += 2;
  y += 6; // total
  y += 8; // prix/pers
  if (data.montantCarte > 0) y += 5;
  if (data.montantCash > 0) y += 5;
  if (estTicketFinal) {
    y += 4 + 8; // ref ticket
    const nbTaux = [6, 12, 21].filter(t => data.tvaParTaux[t] > 0).length;
    y += nbTaux * 5;
    y += 2 + 4 + 4 + 6; // merci + tva resto
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
  // Articles : quantité + nom sur une ligne, prix sur la ligne suivante
  data.lignes.forEach(l => {
    doc.text(String(l.quantite) + '  ' + l.nom, 4, y);
    y += 4;
    doc.text(l.total.toFixed(2) + ' €', droite, y, { align: 'right' });
    y += 5;
  });
  y += 2;
  // Total
  doc.text('TOTAL', 4, y);
  doc.text(data.montantTotal.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 6;
  doc.text('Px/pers. (' + data.nbPersonnes + ') :', 4, y);
  doc.text(data.prixParPersonne.toFixed(2) + ' €', droite, y, { align: 'right' }); y += 8;
  // Paiement
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
    doc.text('ET À BIENTÔT.', centre, y, { align: 'center' }); y += 6;
    doc.setFontSize(9);
    doc.text(data.tva, centre, y, { align: 'center' });
  }
  return doc;
}

// ═══════════════════════════════════════════════════════════════════════════
// FONCTION PRINCIPALE : imprimerTicket
// QZ Tray si disponible → sinon ouvre le PDF (fallback Mac)
// ═══════════════════════════════════════════════════════════════════════════

export async function imprimerTicket(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  try {
    // Tenter QZ Tray
    const qz = await connecterQzTray();
    const imprimante = await trouverImprimante(qz);
    // Créer le PDF et le convertir en base64
    const doc = creerDocPdf(data, estTicketFinal, largeur);
    const dataUri = doc.output('datauristring');
    const base64 = dataUri.split(',')[1];
    // Configurer et imprimer
    const config = qz.configs.create(imprimante, {
      margins: 0,
      scaleContent: false,
      size: { width: largeur, units: 'mm' },
    });
    const hauteur = calculerHauteurTicket(data, estTicketFinal);
    await qz.print(config, [{ type: 'pixel', format: 'pdf', flavor: 'base64', data: base64, options: { pageWidth: largeur, pageHeight: hauteur, units: 'mm' } }]);
  } catch (err) {
    console.warn('QZ Tray indisponible, ouverture PDF :', err.message || err);
    // Fallback : ouvrir le PDF dans un nouvel onglet (Mac + mPOP10)
    genererPdfTicket(data, estTicketFinal);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// genererPdfTicket : ouvre le PDF dans un nouvel onglet (bouton 📄)
// ═══════════════════════════════════════════════════════════════════════════

export function genererPdfTicket(data, estTicketFinal = true) {
  const largeur = obtenirLargeurPapier();
  const doc = creerDocPdf(data, estTicketFinal, largeur);
  const blobUrl = doc.output('bloburl');
  window.open(blobUrl, '_blank');
}