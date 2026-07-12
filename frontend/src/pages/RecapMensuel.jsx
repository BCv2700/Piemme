import { useState, useEffect, useMemo } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import api from '../api/api';

const TAUX_TVA = [6, 12, 21];

const MOIS_NOMS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

// Bordure de quadrillage commune à toutes les cellules du tableau (style de référence)
const BORDURE = '1px solid #e5e5e0';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function pad2(n) {
  return String(n).padStart(2, '0');
}

// Nombre de jours dans un mois (mois = 1..12)
function joursDansMois(annee, mois) {
  return new Date(annee, mois, 0).getDate();
}

// Clé AAAA-MM-JJ pour un jour donné
function dateKey(annee, mois, jour) {
  return annee + '-' + pad2(mois) + '-' + pad2(jour);
}

// Total des km d'un mois à partir d'un enregistrement recap (ou null si le
// mois n'a jamais été touché) : km_defaut (53.4 par défaut) pour chaque jour,
// sauf exception dans km_par_jour. Même logique que kmDuJour dans la vue
// mensuelle, mais utilisable pour n'importe quel mois (pas seulement celui
// affiché), pour construire le récapitulatif annuel.
function calculerTotalKmMois(recapMois, annee, mois) {
  const kmDefaut = recapMois ? Number(recapMois.km_defaut) : 53.4;
  const nbJours = joursDansMois(annee, mois);
  let total = 0;
  for (let j = 1; j <= nbJours; j++) {
    const exception = recapMois && recapMois.km_par_jour ? recapMois.km_par_jour[String(j)] : undefined;
    total += exception !== undefined ? Number(exception) : kmDefaut;
  }
  return total;
}

export default function RecapMensuel() {
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();
  const [vue, setVue] = useState('tous'); // 'tous' = version 1 ; 'analyse' = version 2
  const [afficherTotaux, setAfficherTotaux] = useState(false);
  const [modeAffichage, setModeAffichage] = useState('mensuel'); // 'mensuel' | 'annuel'
  const dateRef = searchParams.get('date') || todayKey();
  const [anneeStr, moisStr] = dateRef.split('-');
  const annee = Number(anneeStr);
  const mois = Number(moisStr); // 1..12

  const [anneeAnnuelle, setAnneeAnnuelle] = useState(annee);
  const [recapsAnnee, setRecapsAnnee] = useState([]);
  const [chargementAnnuel, setChargementAnnuel] = useState(false);

  const [encaissements, setEncaissements] = useState([]);
  const [recap, setRecap] = useState(null); // { memo, km_defaut, km_par_jour, ferme_par_jour }
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const load = () => {
    setLoading(true);
    setError('');
    const nbJours = joursDansMois(annee, mois);
    const dateDebut = dateKey(annee, mois, 1);
    const dateFin = dateKey(annee, mois, nbJours);
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateDebut, date_fin: dateFin } }),
      api.get('/recap-mensuel/' + annee + '/' + mois),
    ])
      .then(([encRes, recapRes]) => {
        setEncaissements(encRes.data);
        setRecap(recapRes.data);
      })
      .catch(() => setError('Impossible de charger le récap mensuel'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [annee, mois]);

  // Charge les 12 mois de l'année sélectionnée, uniquement quand la vue
  // annuelle est active (pas besoin de le faire au chargement de la page).
  const loadAnnee = () => {
    setChargementAnnuel(true);
    api.get('/recap-mensuel/annee/' + anneeAnnuelle)
      .then(r => setRecapsAnnee(r.data))
      .catch(() => showMsg('error', "Impossible de charger le récapitulatif de l'année"))
      .finally(() => setChargementAnnuel(false));
  };

  useEffect(() => {
    if (modeAffichage === 'annuel') loadAnnee();
  }, [modeAffichage, anneeAnnuelle]);

  // Recettes uniquement (on exclut les dépenses), comme dans l'écran Encaissements
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Dépenses uniquement (montant_total négatif en base, on prend la valeur absolue
  // pour un affichage positif et lisible dans le récap)
  const depensesSeules = useMemo(() => encaissements.filter(e => e.depenses), [encaissements]);

  // Regroupe les recettes par jour du mois (1..31)
  const parJour = useMemo(() => {
    const map = {}; // jour -> { total, cash, carte, cashAnalyse, tva, totalAnalyse, tvaAnalyse, depenses }
    const nbJours = joursDansMois(annee, mois);
    for (let j = 1; j <= nbJours; j++) {
      map[j] = {
        total: 0, cash: 0, carte: 0, cashAnalyse: 0,
        tva: { 6: 0, 12: 0, 21: 0, autre: 0 },
        totalAnalyse: 0,
        tvaAnalyse: { 6: 0, 12: 0, 21: 0, autre: 0 },
        depenses: 0,
      };
    }
    recettes.forEach(enc => {
      const d = new Date(enc.date_encaissement);
      // On se base sur l'année/mois/jour locaux de la date d'encaissement
      if (d.getFullYear() !== annee || (d.getMonth() + 1) !== mois) return;
      const j = d.getDate();
      if (!map[j]) return;
      map[j].total += Number(enc.montant_total || 0);
      map[j].cash += Number(enc.montant_cash || 0);
      map[j].carte += Number(enc.montant_carte || 0);
      map[j].cashAnalyse += Number(enc.cash_analyse || 0);
      (enc.lignes || []).forEach(ligne => {
        const montant = Number(ligne.prix_vente) * Number(ligne.quantite);
        const taux = Math.round(Number(ligne.tva));
        // Version 1 (toutes les lignes)
        if (map[j].tva[taux] !== undefined) map[j].tva[taux] += montant;
        else map[j].tva.autre += montant;
        // Version 2 (uniquement les lignes analysées)
        if (ligne.vente_analysee) {
          map[j].totalAnalyse += montant;
          if (map[j].tvaAnalyse[taux] !== undefined) map[j].tvaAnalyse[taux] += montant;
          else map[j].tvaAnalyse.autre += montant;
        }
      });
    });
    // Dépenses par jour, en valeur absolue (montant_total est négatif en base)
    depensesSeules.forEach(enc => {
      const d = new Date(enc.date_encaissement);
      if (d.getFullYear() !== annee || (d.getMonth() + 1) !== mois) return;
      const j = d.getDate();
      if (!map[j]) return;
      map[j].depenses += Math.abs(Number(enc.montant_total || 0));
    });
    return map;
  }, [recettes, depensesSeules, annee, mois]);

  // Totaux du mois
  const totaux = useMemo(() => {
    const t = {
      total: 0, cash: 0, carte: 0, cashAnalyse: 0,
      tva: { 6: 0, 12: 0, 21: 0, autre: 0 },
      totalAnalyse: 0,
      tvaAnalyse: { 6: 0, 12: 0, 21: 0, autre: 0 },
      depenses: 0,
    };
    Object.values(parJour).forEach(j => {
      t.total += j.total;
      t.cash += j.cash;
      t.carte += j.carte;
      t.cashAnalyse += j.cashAnalyse;
      t.tva[6] += j.tva[6];
      t.tva[12] += j.tva[12];
      t.tva[21] += j.tva[21];
      t.tva.autre += j.tva.autre;
      t.totalAnalyse += j.totalAnalyse;
      t.tvaAnalyse[6] += j.tvaAnalyse[6];
      t.tvaAnalyse[12] += j.tvaAnalyse[12];
      t.tvaAnalyse[21] += j.tvaAnalyse[21];
      t.tvaAnalyse.autre += j.tvaAnalyse.autre;
      t.depenses += j.depenses;
    });
    return t;
  }, [parJour]);

  // Base ventilée : les deux vues utilisent la TVA complète (toutes les lignes),
  // car en vue Analyse le Total inclut toute la carte, donc la TVA doit aussi
  // inclure toutes les lignes pour rester cohérente.
  const tvaActive = totaux.tva;
  const baseTva = tvaActive[6] + tvaActive[12] + tvaActive[21];
  const pourcentage = (montant) => (baseTva > 0 ? (montant / baseTva) * 100 : 0);

  // TVA à payer par taux = base × taux / (100 + taux)
  const tvaApayer = (base, taux) => base * taux / (100 + taux);

  // Somme des 3 TVA à payer (6% + 12% + 21%), pour la vue active
  const totalTvaApayer = (tvaParTaux) =>
    tvaApayer(tvaParTaux[6], 6) + tvaApayer(tvaParTaux[12], 12) + tvaApayer(tvaParTaux[21], 21);

  // ───── km : valeur par défaut + exceptions par jour ──────────────────────
  const kmDefaut = recap ? Number(recap.km_defaut) : 53.4;
  const kmDuJour = (jour) => {
    if (recap && recap.km_par_jour && recap.km_par_jour[String(jour)] !== undefined) {
      return Number(recap.km_par_jour[String(jour)]);
    }
    return kmDefaut;
  };

  const totalKm = useMemo(() => {
    const nbJours = joursDansMois(annee, mois);
    let s = 0;
    for (let j = 1; j <= nbJours; j++) s += kmDuJour(j);
    return s;
  }, [recap, annee, mois]);

  // Enregistre une exception de km pour un jour
  const changerKm = async (jour, valeurStr) => {
    const valeur = Number(String(valeurStr).replace(',', '.'));
    if (!Number.isFinite(valeur) || valeur < 0) return;
    const nouvellesExceptions = { ...(recap?.km_par_jour || {}) };
    nouvellesExceptions[String(jour)] = valeur;
    // Mise à jour locale immédiate
    setRecap(prev => ({ ...prev, km_par_jour: nouvellesExceptions }));
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { km_par_jour: nouvellesExceptions });
      setRecap(res.data);
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement des km');
      load();
    }
  };

  // Double-clic sur le champ km d'un jour : bascule entre 0 et la valeur par
  // défaut (km_defaut, ex: 53,4). Si la valeur actuelle est déjà le défaut,
  // on passe à 0 ; sinon (0 ou toute autre valeur), on revient au défaut.
  const basculerKm = (jour, inputEl) => {
    const actuel = kmDuJour(jour);
    const nouvelleValeur = actuel === kmDefaut ? 0 : kmDefaut;
    if (inputEl) inputEl.value = fmt(nouvelleValeur);
    changerKm(jour, nouvelleValeur);
  };

  // ───── jours fermés (étiquette visuelle uniquement, pas de calcul) ───────
  const estFerme = (jour) => {
    return !!(recap && recap.ferme_par_jour && recap.ferme_par_jour[String(jour)]);
  };

  // Coche/décoche "Fermé" pour un jour et sauvegarde immédiatement
  const basculerFerme = async (jour) => {
    const nouvellesValeurs = { ...(recap?.ferme_par_jour || {}) };
    const nouvelEtat = !estFerme(jour);
    if (nouvelEtat) {
      nouvellesValeurs[String(jour)] = true;
    } else {
      delete nouvellesValeurs[String(jour)];
    }
    // Mise à jour locale immédiate
    setRecap(prev => ({ ...prev, ferme_par_jour: nouvellesValeurs }));
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { ferme_par_jour: nouvellesValeurs });
      setRecap(res.data);
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement du jour fermé');
      load();
    }
  };

  // Enregistre le mémo (au blur)
  const [memoLocal, setMemoLocal] = useState('');
  useEffect(() => { setMemoLocal(recap ? (recap.memo || '') : ''); }, [recap?.memo]);

  const sauverMemo = async () => {
    if (!recap) return;
    if (memoLocal === (recap.memo || '')) return; // rien changé
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { memo: memoLocal });
      setRecap(res.data);
      showMsg('success', 'Mémo enregistré');
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement du mémo');
    }
  };

  const nbJours = joursDansMois(annee, mois);
  const jours = Array.from({ length: nbJours }, (_, i) => i + 1);

  // Nombre de jours cochés "Fermé" ce mois-ci, affiché en tête du bloc Annotations
  const nbJoursFermes = useMemo(() => jours.filter(j => estFerme(j)).length, [jours, recap]);

  // Recette moyenne par jour "d'ouverture", défini comme un jour où cash+carte
  // est positif (peu importe la case Fermé, qui est une étiquette manuelle) :
  // total du mois sur ces jours, divisé par leur nombre.
  const joursAvecRecette = useMemo(
    () => jours.filter(j => (parJour[j].cash + parJour[j].carte) > 0),
    [jours, parJour]
  );
  const nbJoursAvecRecette = joursAvecRecette.length;
  const recetteMoyenneParJour = useMemo(() => {
    if (nbJoursAvecRecette === 0) return 0;
    const totalJoursOuverts = joursAvecRecette.reduce((s, j) => s + parJour[j].total, 0);
    return totalJoursOuverts / nbJoursAvecRecette;
  }, [joursAvecRecette, parJour, nbJoursAvecRecette]);

  const nomJourSemaine = (jour) => {
    const d = new Date(annee, mois - 1, jour);
    return d.toLocaleDateString('fr-BE', { weekday: 'long' });
  };

  const fmt = (n) => Number(n).toFixed(2);
  // Comme fmt, mais retourne '' si la valeur est nulle (pour alléger le tableau)
  const fmtZ = (n) => { const v = Number(n); return Math.abs(v) < 0.005 ? '' : v.toFixed(2); };

  // Navigation mois précédent / suivant, en gardant le jour 1 par convention
  // (le récap ne dépend que de l'année/mois, jamais du jour exact dans l'URL).
  const moisPrecedent = () => {
    let a = annee, m = mois - 1;
    if (m < 1) { m = 12; a -= 1; }
    setSearchParams({ date: dateKey(a, m, 1) });
  };
  const moisSuivant = () => {
    let a = annee, m = mois + 1;
    if (m > 12) { m = 1; a += 1; }
    setSearchParams({ date: dateKey(a, m, 1) });
  };

  // Clic sur un jour -> ouvre l'écran Encaissements positionné sur cette date
  const ouvrirJour = (jour) => {
    navigate('/encaissements?date=' + dateKey(annee, mois, jour));
  };

  // Clic sur la carte "Dépenses" -> ouvre l'écran Historique en mode plage,
  // positionné sur l'ensemble du mois affiché dans le récap, filtré sur les
  // dépenses uniquement (lignes individuelles, comme dans le tableau Historique).
  const ouvrirHistoriqueMois = () => {
    const debut = dateKey(annee, mois, 1);
    const fin = dateKey(annee, mois, joursDansMois(annee, mois));
    navigate('/historique?debut=' + debut + '&fin=' + fin + '&depenses=1');
  };

  // Jours d'ouverture du restaurant (jeudi=4, vendredi=5, samedi=6) -> affichés en rouge gras
  const estJourOuverture = (jour) => {
    const d = new Date(annee, mois - 1, jour);
    const js = d.getDay(); // 0=dimanche ... 6=samedi
    return js === 4 || js === 5 || js === 6;
  };

  // Styles de cellules avec quadrillage (mêmes helpers que Encaissements.jsx / Articles.jsx)
  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, ...extra });

  // ───── Année : totaux par mois pour le récapitulatif des km ─────────────
  const totauxKmParMois = useMemo(() => {
    const res = [];
    for (let m = 1; m <= 12; m++) {
      const recapMois = recapsAnnee.find(r => r.mois === m) || null;
      const total = calculerTotalKmMois(recapMois, anneeAnnuelle, m);
      res.push({ mois: m, aller: total / 2, retour: total / 2, total });
    }
    return res;
  }, [recapsAnnee, anneeAnnuelle]);

  const grandTotalKm = useMemo(() => {
    return totauxKmParMois.reduce(
      (acc, m) => ({ aller: acc.aller + m.aller, retour: acc.retour + m.retour, total: acc.total + m.total }),
      { aller: 0, retour: 0, total: 0 }
    );
  }, [totauxKmParMois]);

  // ───── Export PDF ─────────────────────────────────────────────────────
  // genere le PDF pour la vue "tous" ou "analyse". Toutes les colonnes
  // restent remplies même sur un jour fermé ; on ajoute juste "Fermé" en
  // rouge à côté de la date.
  //
  // ⚠️ Règle : le PDF doit refléter EXACTEMENT l'écran correspondant.
  // La colonne "Contrôle" est donc, comme à l'écran, la somme des 3 TVA
  // (qui doit être égale au Total) — et NON carte + cash analysé (ancienne
  // formule qui créait un écart entre l'écran et le PDF, corrigé le 8 juillet).
  //
  // ⚠️ En vue Analyse, le Total = carte + cash analysé (les paiements carte
  // comptent toujours intégralement ; seul le cash est filtré par l'analyse).
  const genererPdf = (vueExport) => {
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    const nomMois = MOIS_NOMS[mois - 1];
    const nomMoisMaj = nomMois.charAt(0).toUpperCase() + nomMois.slice(1);
    const estTous = vueExport === 'tous';

    doc.setFontSize(16);
    doc.setFont(undefined, 'bold');
    doc.text('Récapitulatif Mensuel', 14, 15);
    doc.setFontSize(13);
    doc.text(nomMoisMaj + ' ' + annee, 90, 15);
    doc.setFont(undefined, 'normal');

    // ligne de totaux / pourcentages TVA, juste sous le titre (comme l'ancien PDF Access).
    // Les pourcentages sont calculés sur la vue EXPORTÉE (tvaRef), pas sur la vue
    // affichée à l'écran au moment du clic (sinon "PDF Comptable" cliqué depuis la
    // vue "Tous" donnait des pourcentages faux).
    const tvaRef = totaux.tva;
    const baseTvaRef = tvaRef[6] + tvaRef[12] + tvaRef[21];
    const pourcentageRef = (montant) => (baseTvaRef > 0 ? (montant / baseTvaRef) * 100 : 0);
    doc.setFontSize(8);
    let ligneInfo = (estTous ? 'Total ' + fmt(totaux.total) : 'Total ' + fmt(totaux.carte + totaux.cashAnalyse))
      + '   Cash ' + fmt(estTous ? totaux.cash : totaux.cashAnalyse)
      + '   Carte ' + fmt(totaux.carte)
      + '   Km A/R ' + fmt(totalKm);
    doc.text(ligneInfo, 14, 21);
    let lignePourcent = TAUX_TVA.map(t => t + '% : ' + pourcentageRef(tvaRef[t]).toFixed(2) + '%').join('    ');
    doc.text(lignePourcent, 14, 26);

    // En-têtes et colonnes selon la vue, identiques à l'écran (la colonne
    // Dépenses reste volontairement absente du PDF comptable)
    const head = estTous
      ? ['Jour', 'Total', 'Total analysé', 'Dépenses', 'Cash', 'Carte', 'Cash analysé', 'Contrôle', 'TVA 6%', 'TVA 12%', 'TVA 21%', 'Km A/R']
      : ['Jour', 'Total', 'Carte', 'Cash analysé', 'Contrôle', 'TVA 6%', 'TVA 12%', 'TVA 21%', 'Km A/R'];

    const body = jours.map(j => {
      const d = parJour[j];
      const ferme = estFerme(j);
      const libelleJour = pad2(j) + ' ' + nomJourSemaine(j) + (ferme ? '  Fermé' : '');
      if (estTous) {
        const controle = d.tva[6] + d.tva[12] + d.tva[21];
        return [
          libelleJour, fmtZ(d.total), fmtZ(d.totalAnalyse), fmtZ(d.depenses), fmtZ(d.cash), fmtZ(d.carte), fmtZ(d.cashAnalyse),
          fmtZ(controle), fmtZ(d.tva[6]), fmtZ(d.tva[12]), fmtZ(d.tva[21]), fmtZ(kmDuJour(j)),
        ];
      }
      // Contrôle = somme des 3 TVA (complètes), comme dans le tableau à l'écran
      const controle = d.tva[6] + d.tva[12] + d.tva[21];
      // Total en vue Analyse = carte + cash analysé
      const totalAnalyseJour = d.carte + d.cashAnalyse;
      return [
        libelleJour, fmtZ(totalAnalyseJour), fmtZ(d.carte), fmtZ(d.cashAnalyse), fmtZ(controle),
        fmtZ(d.tva[6]), fmtZ(d.tva[12]), fmtZ(d.tva[21]), fmtZ(kmDuJour(j)),
      ];
    });

    const totalAnalyseMois = totaux.carte + totaux.cashAnalyse;
    const ligneTotaux = estTous
      ? ['Totaux ' + nomMois, fmt(totaux.total), fmt(totaux.totalAnalyse), fmt(totaux.depenses), fmt(totaux.cash), fmt(totaux.carte), fmt(totaux.cashAnalyse), fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21]), fmt(totaux.tva[6]), fmt(totaux.tva[12]), fmt(totaux.tva[21]), fmt(totalKm)]
      : ['Totaux ' + nomMois, fmt(totalAnalyseMois), fmt(totaux.carte), fmt(totaux.cashAnalyse), fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21]), fmt(totaux.tva[6]), fmt(totaux.tva[12]), fmt(totaux.tva[21]), fmt(totalKm)];

    const ligneTvaApayer = estTous
      ? ['TVA à payer', '', '', '', '', '', '', '', fmt(tvaApayer(totaux.tva[6], 6)), fmt(tvaApayer(totaux.tva[12], 12)), fmt(tvaApayer(totaux.tva[21], 21)), '']
      : ['TVA à payer', '', '', '', '', fmt(tvaApayer(totaux.tva[6], 6)), fmt(tvaApayer(totaux.tva[12], 12)), fmt(tvaApayer(totaux.tva[21], 21)), ''];

    const sommeTva = totalTvaApayer(totaux.tva);
    const ligneSomme = estTous
      ? ['Somme des 3 TVA', '', '', '', '', '', '', '', '', '', fmt(sommeTva), '']
      : ['Somme des 3 TVA', '', '', '', '', '', '', fmt(sommeTva), ''];

    autoTable(doc, {
      startY: 30,
      head: [head],
      body: [...body, ligneTotaux, ligneTvaApayer, ligneSomme],
      styles: { fontSize: 7, cellPadding: 1.2, lineColor: [229, 229, 224], lineWidth: 0.1 },
      headStyles: { fillColor: [250, 250, 248], textColor: [40, 40, 40], fontStyle: 'bold' },
      columnStyles: {
        0: { halign: 'left', cellWidth: 34 },
      },
      bodyStyles: { halign: 'right' },
      didParseCell: (data) => {
        // Mise en évidence des 3 dernières lignes (totaux / tva à payer / somme)
        const estLigneSpeciale = data.row.index >= body.length;
        if (estLigneSpeciale) {
          data.cell.styles.fontStyle = 'bold';
          data.cell.styles.fillColor = [250, 250, 248];
        }
        // Jour ouverture -> rouge gras dans la 1re colonne
        if (data.column.index === 0 && data.row.index < body.length) {
          const j = data.row.index + 1;
          if (estJourOuverture(j)) {
            data.cell.styles.textColor = [220, 38, 38];
            data.cell.styles.fontStyle = 'bold';
          }
        }
      },
      margin: { left: 14, right: 14 },
    });

    // Annotations du mois : jours fermés (les 2 PDF) + recette moyenne par jour
    // d'ouverture (PDF Tous uniquement, cf. écran), puis le mémo libre s'il existe.
    let yAnnotations = doc.lastAutoTable.finalY + 10;
    doc.setFontSize(9);
    doc.setFont(undefined, 'bold');
    doc.text('Annotations du mois', 14, yAnnotations);
    doc.setFont(undefined, 'normal');
    doc.setFontSize(8);
    yAnnotations += 5;
    let ligneStats = nbJoursFermes + ' jour' + (nbJoursFermes > 1 ? 's' : '') + ' fermé' + (nbJoursFermes > 1 ? 's' : '') + ' ce mois-ci';
    if (estTous) {
      ligneStats += '    ·    recette moyenne sur ' + nbJoursAvecRecette + ' jour' + (nbJoursAvecRecette > 1 ? 's' : '') + " d'ouverture : " + fmt(recetteMoyenneParJour) + ' €';
    }
    doc.text(ligneStats, 14, yAnnotations);
    yAnnotations += 5;

    // Mémo du mois, si présent
    if (memoLocal && memoLocal.trim()) {
      const lignesMemo = doc.splitTextToSize(memoLocal, 180);
      doc.text(lignesMemo, 14, yAnnotations);
    }

    const suffixe = estTous ? 'tous' : 'comptable';
    const nomFichier = 'récap ' + suffixe + ' ' + nomMois.charAt(0).toUpperCase() + nomMois.slice(1) + ' ' + String(annee).slice(2) + '.pdf';
    // Ouvre le PDF dans un nouvel onglet plutôt que de le télécharger directement.
    // L'utilisateur peut ensuite l'imprimer ou l'enregistrer lui-même depuis le navigateur.
    doc.setProperties({ title: nomFichier });
    const blobUrl = doc.output('bloburl');
    window.open(blobUrl, '_blank');
  };

  // Cellule "Jour" commune aux deux tableaux : case à cocher Fermé + nom du jour + mention "Fermé"
  const celluleJour = (j, aRecette) => {
    const ouverture = estJourOuverture(j);
    const ferme = estFerme(j);
    return (
      <td style={tdCell({ textAlign: 'left', whiteSpace: 'nowrap' })}>
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
          <input
            type="checkbox"
            checked={ferme}
            onClick={(e) => e.stopPropagation()}
            onChange={() => basculerFerme(j)}
            title="Marquer ce jour comme fermé"
            style={{ cursor: 'pointer' }}
          />
          <span
            style={{
              cursor: 'pointer',
              textDecoration: 'underline dotted',
              color: ouverture ? '#dc2626' : (aRecette ? '#111' : '#aaa'),
              fontWeight: ouverture ? 700 : 400,
            }}
            title="Ouvrir les encaissements de ce jour"
            onClick={() => ouvrirJour(j)}
          >
            {pad2(j)} <span style={{ color: ouverture ? '#dc2626' : '#999', textTransform: 'capitalize' }}>{nomJourSemaine(j)}</span>
          </span>
          {ferme && <span style={{ color: '#b91c1c', fontWeight: 700 }}>Fermé</span>}
        </span>
      </td>
    );
  };

  // ───── Rendu : vue annuelle (récapitulatif des km par mois) ─────────────
  if (modeAffichage === 'annuel') {
    return (
      <div>
        <div className="content">
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, flexWrap: 'wrap' }}>
            <button className="btn" onClick={() => setModeAffichage('mensuel')}>← Retour au récap mensuel</button>
            <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>
              Récapitulatif des Km par mois
            </h2>
            <button className="btn" onClick={() => setAnneeAnnuelle(a => a - 1)}>−</button>
            <span style={{ fontSize: 16, fontWeight: 700 }}>{anneeAnnuelle}</span>
            <button className="btn" onClick={() => setAnneeAnnuelle(a => a + 1)}>+</button>
          </div>

          {chargementAnnuel ? (
            <div style={{ color: '#888' }}>Chargement...</div>
          ) : (
            <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden', maxWidth: 640 }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                <thead>
                  <tr style={{ background: '#fafaf8' }}>
                    <th style={thCell({ textAlign: 'left' })}></th>
                    <th style={thCell({ textAlign: 'right' })}>Aller</th>
                    <th style={thCell({ textAlign: 'right' })}>Retour</th>
                    <th style={thCell({ textAlign: 'right' })}>Total</th>
                  </tr>
                </thead>
                <tbody>
                  {totauxKmParMois.map(m => (
                    <tr key={m.mois}>
                      <td style={tdCell({ textAlign: 'left', textTransform: 'capitalize' })}>
                        {MOIS_NOMS[m.mois - 1]}
                      </td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(m.aller)}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(m.retour)}</td>
                      <td style={tdCell({ textAlign: 'right', fontWeight: 600 })}>{fmt(m.total)}</td>
                    </tr>
                  ))}
                </tbody>
                <tfoot>
                  <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                    <td style={tdCell({ textAlign: 'left' })}>Grand Total</td>
                    <td style={tdCell({ textAlign: 'right' })}>{fmt(grandTotalKm.aller)}</td>
                    <td style={tdCell({ textAlign: 'right' })}>{fmt(grandTotalKm.retour)}</td>
                    <td style={tdCell({ textAlign: 'right' })}>{fmt(grandTotalKm.total)}</td>
                  </tr>
                </tfoot>
              </table>
            </div>
          )}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="content">
        <style>{`
          .cell-input:focus {
            outline: none;
            border: 1px solid #bbb !important;
            background: #fff !important;
          }
        `}</style>

        {msg && (
          <div style={{
            padding: '10px 16px', borderRadius: 8, marginBottom: 16, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
            border: '1px solid ' + (msg.type === 'success' ? '#86efac' : '#fca5a5')
          }}>
            {msg.text}
          </div>
        )}

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16, flexWrap: 'wrap' }}>
          <button className="btn" onClick={moisPrecedent} title="Mois précédent">−</button>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0, textTransform: 'capitalize' }}>
            {MOIS_NOMS[mois - 1]} {annee}
          </h2>
          <button className="btn" onClick={moisSuivant} title="Mois suivant">+</button>
          <div style={{ display: 'flex', gap: 0, border: '1px solid #ddd', borderRadius: 8, overflow: 'hidden' }}>
            <button
              onClick={() => setVue('tous')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'tous' ? '#111' : 'white',
                color: vue === 'tous' ? 'white' : '#333',
              }}
            >
              Tous
            </button>
            <button
              onClick={() => setVue('analyse')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'analyse' ? '#111' : 'white',
                color: vue === 'analyse' ? 'white' : '#333',
              }}
            >
              Analysé
            </button>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <button
              onClick={() => genererPdf('tous')}
              style={{
                padding: '6px 14px', fontSize: 12, fontWeight: 600, borderRadius: 8,
                border: '1px solid #ddd', background: 'white', color: '#333', cursor: 'pointer',
              }}
              title="Exporter le PDF de la vue Tous"
            >
              📄 PDF Tous
            </button>
            <button
              onClick={() => genererPdf('analyse')}
              style={{
                padding: '6px 14px', fontSize: 12, fontWeight: 600, borderRadius: 8,
                border: '1px solid #ddd', background: 'white', color: '#333', cursor: 'pointer',
              }}
              title="Exporter le PDF de la vue Analysé (comptable)"
            >
              📄 PDF Comptable
            </button>
            <button
              onClick={() => { setAnneeAnnuelle(annee); setModeAffichage('annuel'); }}
              style={{
                padding: '6px 14px', fontSize: 12, fontWeight: 600, borderRadius: 8,
                border: '1px solid #ddd', background: 'white', color: '#333', cursor: 'pointer',
              }}
              title="Voir le récapitulatif des km par mois sur l'année"
            >
              📆 Vue annuelle (km)
            </button>
            <button
              className="btn"
              onClick={() => setAfficherTotaux(v => !v)}
              style={{ fontSize: 12, color: '#666' }}
            >
              {afficherTotaux ? '▲ Masquer les totaux' : '▼ Afficher les totaux'}
            </button>
          </div>
          <span style={{ fontSize: 13, color: '#888' }}>
            {vue === 'analyse' ? 'Ventes analysées uniquement' : 'Tous les encaissements'}
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <>
            {afficherTotaux && (
              <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
                {vue === 'tous' ? (
                  <>
                    <CarteTotal label="Total" valeur={fmt(totaux.total)} fort />
                    <CarteTotal
                      label="Dépenses" valeur={fmt(totaux.depenses)} couleur="#b91c1c"
                      onClick={ouvrirHistoriqueMois} title="Voir le détail des dépenses dans l'historique du mois"
                    />
                    <CarteTotal label="Cash" valeur={fmt(totaux.cash)} couleur="#16a34a" />
                    <CarteTotal label="Carte" valeur={fmt(totaux.carte)} couleur="#2563eb" />
                    <CarteTotal label="Cash analysé" valeur={fmt(totaux.cashAnalyse)} couleur="#b45309" />
                    {TAUX_TVA.map(taux => (
                      <CarteTotal
                        key={taux}
                        label={'TVA ' + taux + '% (' + pourcentage(totaux.tva[taux]).toFixed(2) + '%)'}
                        valeur={fmt(totaux.tva[taux])}
                      />
                    ))}
                    <CarteTotal label="TVA totale à payer" valeur={fmt(totalTvaApayer(totaux.tva))} couleur="#888" />
                  </>
                ) : (
                  <>
                    <CarteTotal label="Total" valeur={fmt(totaux.carte + totaux.cashAnalyse)} fort />
                    <CarteTotal
                      label="Dépenses" valeur={fmt(totaux.depenses)} couleur="#b91c1c"
                      onClick={ouvrirHistoriqueMois} title="Voir le détail des dépenses dans l'historique du mois"
                    />
                    <CarteTotal label="Carte" valeur={fmt(totaux.carte)} couleur="#2563eb" />
                    <CarteTotal label="Cash analysé" valeur={fmt(totaux.cashAnalyse)} couleur="#b45309" />
                    {TAUX_TVA.map(taux => (
                      <CarteTotal
                        key={taux}
                        label={'TVA ' + taux + '% (' + pourcentage(totaux.tva[taux]).toFixed(2) + '%)'}
                        valeur={fmt(totaux.tva[taux])}
                      />
                    ))}
                    <CarteTotal label="TVA totale à payer" valeur={fmt(totalTvaApayer(totaux.tva))} couleur="#888" />
                  </>
                )}
                <CarteTotal label="Km A/R" valeur={fmt(totalKm)} couleur="#6b7280" />
              </div>
            )}

            {/* Tableau jour par jour */}
            <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto', marginBottom: 20 }}>
              {vue === 'tous' ? (
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, minWidth: 860 }}>
                  <thead>
                    <tr style={{ background: '#fafaf8' }}>
                      <th style={thCell({ textAlign: 'left' })}>Jour</th>
                      <th style={thCell({ textAlign: 'center' })}>Total</th>
                      <th style={thCell({ textAlign: 'center' })} title="Total des ventes analysées (cochées)">Total analysé</th>
                      <th style={thCell({ textAlign: 'center' })}>Dépenses</th>
                      <th style={thCell({ textAlign: 'center' })}>Cash</th>
                      <th style={thCell({ textAlign: 'center' })}>Carte</th>
                      <th style={thCell({ textAlign: 'center' })}>Cash analysé</th>
                      <th style={thCell({ textAlign: 'center' })} title="Somme des 3 TVA : doit être égale au Total">Contrôle</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 6%</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 12%</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 21%</th>
                      <th style={thCell({ textAlign: 'center' })} title="Double-clic : bascule entre 0 et la valeur par défaut">Km A/R</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left' })}>Totaux {MOIS_NOMS[mois - 1]}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.total)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#0f766e' })}>{fmt(totaux.totalAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(totaux.depenses)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#16a34a' })}>{fmt(totaux.cash)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#2563eb' })}>{fmt(totaux.carte)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b45309' })}>{fmt(totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[12])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#6b7280' })}>{fmt(totalKm)}</td>
                    </tr>
                    {jours.map(j => {
                      const d = parJour[j];
                      const aRecette = d.total !== 0;
                      const controleTva = d.tva[6] + d.tva[12] + d.tva[21];
                      const ecartTva = controleTva - d.total;
                      const tvaKo = aRecette && Math.abs(ecartTva) >= 0.01;
                      const ecartPaiement = (d.cash + d.carte) - d.total;
                      const paiementKo = aRecette && Math.abs(ecartPaiement) >= 0.01;
                      return (
                        <tr key={j}>
                          {celluleJour(j, aRecette)}
                          <td style={tdCell({ textAlign: 'right', fontWeight: aRecette ? 700 : 400, color: paiementKo ? '#dc2626' : (aRecette ? '#111' : '#ccc') })}>{fmtZ(d.total)}</td>
                          <td style={tdCell({ textAlign: 'right', color: d.totalAnalyse !== 0 ? '#0f766e' : '#ccc' })}>{fmtZ(d.totalAnalyse)}</td>
                          <td style={tdCell({ textAlign: 'right', color: d.depenses !== 0 ? '#b91c1c' : '#ccc' })}>{fmtZ(d.depenses)}</td>
                          <td style={tdCell({ textAlign: 'right', color: !aRecette ? '#ccc' : (paiementKo ? '#dc2626' : '#16a34a') })}>{fmtZ(d.cash)}</td>
                          <td style={tdCell({ textAlign: 'right', color: !aRecette ? '#ccc' : (paiementKo ? '#dc2626' : '#2563eb') })}>{fmtZ(d.carte)}</td>
                          <td style={tdCell({ textAlign: 'right', color: aRecette ? '#b45309' : '#ccc' })}>{fmtZ(d.cashAnalyse)}</td>
                          <td style={tdCell({ textAlign: 'right', fontWeight: 600, color: !aRecette ? '#ccc' : (tvaKo ? '#dc2626' : '#16a34a') })}>
                            {fmtZ(controleTva)}{aRecette && tvaKo ? ' (' + (ecartTva > 0 ? '+' : '') + fmt(ecartTva) + ')' : ''}
                          </td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[6])}</td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[12])}</td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[21])}</td>
                          <td style={tdCell({ padding: '2px 6px' })}>
                            <input
                              type="number" step="0.1" min="0"
                              className="cell-input" style={{ ...inputStyle, textAlign: 'right' }}
                              defaultValue={fmt(kmDuJour(j))}
                              onBlur={(e) => changerKm(j, e.target.value)}
                              onDoubleClick={(e) => basculerKm(j, e.target)}
                              title="Double-clic : bascule 0 / valeur par défaut"
                            />
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                  <tfoot>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left' })}>Totaux {MOIS_NOMS[mois - 1]}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.total)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#0f766e' })}>{fmt(totaux.totalAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(totaux.depenses)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#16a34a' })}>{fmt(totaux.cash)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#2563eb' })}>{fmt(totaux.carte)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b45309' })}>{fmt(totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[12])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#6b7280' })}>{fmt(totalKm)}</td>
                    </tr>
                    <tr style={{ background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left', color: '#888' })}>TVA à payer</td>
                      <td style={tdCell()} colSpan={7}></td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[6], 6))}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[12], 12))}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[21], 21))}</td>
                      <td style={tdCell()}></td>
                    </tr>
                    <tr style={{ background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left', color: '#888', fontWeight: 700 })}>Somme des 3 TVA</td>
                      <td style={tdCell()} colSpan={9}></td>
                      <td style={tdCell({ textAlign: 'right', color: '#888', fontWeight: 700 })}>{fmt(totalTvaApayer(totaux.tva))}</td>
                      <td style={tdCell()}></td>
                    </tr>
                  </tfoot>
                </table>
              ) : (
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, minWidth: 920 }}>
                  <thead>
                    <tr style={{ background: '#fafaf8' }}>
                      <th style={thCell({ textAlign: 'left' })}>Jour</th>
                      <th style={thCell({ textAlign: 'center' })}>Total</th>
                      <th style={thCell({ textAlign: 'center' })}>Dépenses</th>
                      <th style={thCell({ textAlign: 'center' })}>Carte</th>
                      <th style={thCell({ textAlign: 'center' })}>Cash analysé</th>
                      <th style={thCell({ textAlign: 'center' })} title="Somme des 3 TVA : doit être égale au Total">Contrôle</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 6%</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 12%</th>
                      <th style={thCell({ textAlign: 'center' })}>TVA 21%</th>
                      <th style={thCell({ textAlign: 'center' })} title="Double-clic : bascule entre 0 et la valeur par défaut">Km A/R</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left' })}>Totaux {MOIS_NOMS[mois - 1]}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.carte + totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(totaux.depenses)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#2563eb' })}>{fmt(totaux.carte)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b45309' })}>{fmt(totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[12])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#6b7280' })}>{fmt(totalKm)}</td>
                    </tr>
                    {jours.map(j => {
                      const d = parJour[j];
                      const totalJour = d.carte + d.cashAnalyse;
                      const aRecette = totalJour !== 0;
                      const controleTva = d.tva[6] + d.tva[12] + d.tva[21];
                      const ecartTva = controleTva - totalJour;
                      const tvaKo = aRecette && Math.abs(ecartTva) >= 0.01;
                      return (
                        <tr key={j}>
                          {celluleJour(j, aRecette)}
                          <td style={tdCell({ textAlign: 'right', fontWeight: aRecette ? 700 : 400, color: aRecette ? '#111' : '#ccc' })}>{fmtZ(totalJour)}</td>
                          <td style={tdCell({ textAlign: 'right', color: d.depenses !== 0 ? '#b91c1c' : '#ccc' })}>{fmtZ(d.depenses)}</td>
                          <td style={tdCell({ textAlign: 'right', color: !aRecette ? '#ccc' : '#2563eb' })}>{fmtZ(d.carte)}</td>
                          <td style={tdCell({ textAlign: 'right', color: !aRecette ? '#ccc' : '#b45309' })}>{fmtZ(d.cashAnalyse)}</td>
                          <td style={tdCell({ textAlign: 'right', fontWeight: 600, color: !aRecette ? '#ccc' : (tvaKo ? '#dc2626' : '#16a34a') })}>
                            {fmtZ(controleTva)}{aRecette && tvaKo ? ' (' + (ecartTva > 0 ? '+' : '') + fmt(ecartTva) + ')' : ''}
                          </td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[6])}</td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[12])}</td>
                          <td style={tdCell({ textAlign: 'right', color: tvaKo ? '#dc2626' : '#666' })}>{fmtZ(d.tva[21])}</td>
                          <td style={tdCell({ padding: '2px 6px' })}>
                            <input
                              type="number" step="0.1" min="0"
                              className="cell-input" style={{ ...inputStyle, textAlign: 'right' }}
                              defaultValue={fmt(kmDuJour(j))}
                              onBlur={(e) => changerKm(j, e.target.value)}
                              onDoubleClick={(e) => basculerKm(j, e.target)}
                              title="Double-clic : bascule 0 / valeur par défaut"
                            />
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                  <tfoot>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left' })}>Totaux {MOIS_NOMS[mois - 1]}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.carte + totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b91c1c' })}>{fmt(totaux.depenses)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#2563eb' })}>{fmt(totaux.carte)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#b45309' })}>{fmt(totaux.cashAnalyse)}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6] + totaux.tva[12] + totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[6])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[12])}</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totaux.tva[21])}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#6b7280' })}>{fmt(totalKm)}</td>
                    </tr>
                    <tr style={{ background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left', color: '#888' })}>TVA à payer</td>
                      <td style={tdCell()} colSpan={5}></td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[6], 6))}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[12], 12))}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#888' })}>{fmt(tvaApayer(totaux.tva[21], 21))}</td>
                      <td style={tdCell()}></td>
                    </tr>
                    <tr style={{ background: '#fafaf8' }}>
                      <td style={tdCell({ textAlign: 'left', color: '#888', fontWeight: 700 })}>Somme des 3 TVA</td>
                      <td style={tdCell()} colSpan={7}></td>
                      <td style={tdCell({ textAlign: 'right', color: '#888', fontWeight: 700 })}>{fmt(totalTvaApayer(totaux.tva))}</td>
                      <td style={tdCell()}></td>
                    </tr>
                  </tfoot>
                </table>
              )}
            </div>

            {/* Mémo du mois */}
            <div style={{ marginBottom: 20 }}>
              <label style={{ fontSize: 13, fontWeight: 600, color: '#555', display: 'block', marginBottom: 6 }}>
                Annotations du mois (nettoyage, justifications de km…)
              </label>
              <div style={{ fontSize: 13, color: '#666', marginBottom: 6 }}>
                <strong style={{ color: '#111' }}>{nbJoursFermes}</strong> jour{nbJoursFermes > 1 ? 's' : ''} fermé{nbJoursFermes > 1 ? 's' : ''} ce mois-ci
                {' · '}
                recette moyenne sur <strong style={{ color: '#111' }}>{nbJoursAvecRecette}</strong> jour{nbJoursAvecRecette > 1 ? 's' : ''} d'ouverture : <strong style={{ color: '#111' }}>{fmt(recetteMoyenneParJour)} €</strong>
              </div>
              <textarea
                value={memoLocal}
                onChange={(e) => setMemoLocal(e.target.value)}
                onBlur={sauverMemo}
                rows={5}
                placeholder={'Ex :\n04 ' + MOIS_NOMS[mois - 1] + ' : Nettoyage\n11 ' + MOIS_NOMS[mois - 1] + ' : Nettoyage'}
                style={{
                  width: '100%', padding: '10px 12px', borderRadius: 8,
                  border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box',
                  fontFamily: 'inherit', resize: 'vertical',
                }}
              />
              <div style={{ fontSize: 12, color: '#aaa', marginTop: 4 }}>
                Enregistré automatiquement quand tu cliques en dehors du cadre.
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

function CarteTotal({ label, valeur, couleur, fort, onClick, title }) {
  return (
    <div
      onClick={onClick}
      title={title}
      style={{
        background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110,
        cursor: onClick ? 'pointer' : 'default',
      }}
    >
      <div style={{ fontSize: 11, color: '#888' }}>{label}</div>
      <div style={{ fontSize: fort ? 18 : 16, fontWeight: 700, color: couleur || '#111' }}>{valeur} €</div>
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '2px 6px',
  borderRadius: 5,
  border: '1px solid transparent',
  background: 'transparent',
  fontSize: 12,
  boxSizing: 'border-box',
};