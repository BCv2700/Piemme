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
  encaissementId, dateEncaissement, tableNom, nomReservation,
  lignes, montantCash, montantCarte, montantTotal,
}) {
  return {
    ...COORDONNEES_RESTAURANT,
    numeroTicket: encaissementId,
    date: dateEncaissement,
    table: tableNom,
    reservation: nomReservation,
    lignes: lignes.map(l => ({
      nom: l.article_nom,
      quantite: Number(l.quantite),
      total: Number(l.prix_vente) * Number(l.quantite),
    })),
    montantTotal,
    montantCash,
    montantCarte,
    tvaParTaux: calculerTvaParTaux(lignes),
  };
}