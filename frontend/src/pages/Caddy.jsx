import { useState, useEffect } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import jsPDF from 'jspdf';
import api from '../api/api';
import { genererDonneesTicket, genererPdfTicket } from '../utils/ticket';

const CODE_VENTE_DEPENSE = 9001;
const ESPACE_HAUT_TICKET_CUISINE_MM = 30;
const BORDURE = '1px solid #e5e5e0';

const normaliser = (s) =>
  (s || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim();

const errMsg = (e, fallback) => {
  const detail = e.response?.data?.detail;
  if (!detail) return fallback;
  if (typeof detail === 'string') return detail;
  if (Array.isArray(detail)) return detail.map(d => d.msg || JSON.stringify(d)).join(' · ');
  return fallback;
};

export default function Caddy() {
  const { tableId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const retourDate = searchParams.get('retourDate');
  const urlRetourPlan = retourDate ? '/?date=' + retourDate : '/';

  const [table, setTable] = useState(null);
  const [toutesLesTables, setToutesLesTables] = useState([]);
  const [articles, setArticles] = useState([]);
  const [lignes, setLignes] = useState([]);
  const [heureArrivee, setHeureArrivee] = useState(null);
  const [codeVente, setCodeVente] = useState(null);
  const [categorie, setCategorie] = useState(null);
  const [emporte, setEmporte] = useState(false);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saisieDepense, setSaisieDepense] = useState(null);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 2500);
  };

  const load = async () => {
    if (!tableId || tableId === 'undefined') {
      setError('Aucune table sélectionnée (identifiant manquant).');
      setLoading(false);
      return;
    }
    const todayKey = (() => {
      const d = new Date();
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${y}-${m}-${day}`;
    })();
    const dateAUtiliser = retourDate || todayKey;
    try {
      const [tableRes, toutesTablesRes, articlesRes, lignesRes, positionsRes] = await Promise.all([
        api.get('/tables/' + tableId),
        api.get('/tables/'),
        api.get('/articles/', { params: { actif: true } }),
        api.get('/commandes/', { params: { table_id: tableId } }),
        api.get('/table-positions-jour/', { params: { date_jour: dateAUtiliser } }),
      ]);
      setTable(tableRes.data);
      setToutesLesTables(toutesTablesRes.data);
      setArticles(articlesRes.data);
      setLignes(lignesRes.data);
      const positionJour = positionsRes.data.find(p => p.table_id === Number(tableId));
      setHeureArrivee(positionJour && positionJour.heure_arrivee ? positionJour.heure_arrivee.slice(0, 5) : null);
    } catch (e) {
      setError(errMsg(e, 'Impossible de charger le caddy'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, [tableId]);

  const LIBELLES_CODE_VENTE = {
    7001: 'Boissons Alcools',
    7002: 'Nourriture',
    7003: 'Boissons Softs',
    7004: 'Boissons Vins',
    7005: 'Divers',
    9001: 'Dépenses',
  };

  const estEcranDepense = table != null && normaliser(table.nom) === 'depenses';

  const codesVente = [...new Set(articles.map(a => a.code_vente))]
    .filter(c => c != null)
    .sort((a, b) => a - b);

  useEffect(() => {
    if (!codeVente && codesVente.length > 0) setCodeVente(codesVente[0]);
  }, [codesVente, codeVente]);

  const articlesDepense = articles.filter(a => a.code_vente === CODE_VENTE_DEPENSE);

  const categorieDe = (article) => {
    const c = (article.categorie || '').trim();
    return c === '' ? 'Non classé' : c;
  };

  const categoriesDepense = (() => {
    const presentes = [...new Set(articlesDepense.map(a => categorieDe(a)))];
    const sansNonClasse = presentes.filter(c => c !== 'Non classé')
      .sort((a, b) => a.localeCompare(b, 'fr'));
    if (presentes.includes('Non classé')) sansNonClasse.push('Non classé');
    return sansNonClasse;
  })();

  const typesNiveau2 = [...new Set(
    articles
      .filter(a => a.code_vente === codeVente)
      .map(a => a.type_article || 'Sans type')
  )].sort((a, b) => a.localeCompare(b, 'fr', { numeric: true }));

  useEffect(() => {
    if (estEcranDepense) {
      if (categoriesDepense.length > 0 && !categoriesDepense.includes(categorie)) {
        setCategorie(categoriesDepense[0]);
      }
    } else {
      if (typesNiveau2.length > 0 && !typesNiveau2.includes(categorie)) {
        setCategorie(typesNiveau2[0]);
      }
    }
  }, [estEcranDepense, typesNiveau2, categoriesDepense, categorie]);

  const articlesAffiches = estEcranDepense
    ? articlesDepense.filter(a => categorieDe(a) === categorie)
        .sort((a, b) => a.nom.localeCompare(b.nom, 'fr', { numeric: true }))
    : articles.filter(a =>
        a.code_vente === codeVente &&
        (a.type_article || 'Sans type') === categorie
      );

  const ajouterArticle = async (article) => {
    setError('');
    const prix = emporte && article.prix_vente_away != null ? article.prix_vente_away : article.prix_vente;
    const tva = emporte && article.tva_away != null ? article.tva_away : article.tva;

    const ligneExistante = lignes.find(l => l.article_id === article.id && l.emporte === emporte);

    try {
      if (ligneExistante) {
        const nouvelleQuantite = Number(ligneExistante.quantite) + 1;
        const res = await api.patch('/commandes/' + ligneExistante.id, { quantite: nouvelleQuantite });
        setLignes(prev => prev.map(l => l.id === ligneExistante.id ? res.data : l));
      } else {
        const res = await api.post('/commandes/', {
          table_id: Number(tableId),
          article_id: article.id,
          quantite: 1,
          prix_unitaire: prix,
          tva: tva,
          emporte: emporte,
        });
        setLignes(prev => [...prev, res.data]);
      }
    } catch (e) {
      setError(errMsg(e, "Erreur lors de l'ajout"));
    }
  };

  const ouvrirSaisieDepense = (article) => {
    setSaisieDepense({ article, montant: '' });
  };

const validerSaisieDepense = async () => {
    if (!saisieDepense) return;
    const montant = Number(String(saisieDepense.montant).replace(',', '.'));
    if (!Number.isFinite(montant) || montant <= 0) {
      setError('Montant invalide');
      return;
    }
    setError('');
    const todayStr = (() => {
      const d = new Date();
      return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    })();
    const dateEncodage = retourDate || todayStr;
    try {
      await api.post('/encaissements/', {
        table_nom: table ? table.nom : 'DÉPENSES',
        client_id: null,
        montant_carte: montant,
        montant_cash: 0,
        montant_total: montant,
        cash_analyse: 0,
        nb_personnes: 1,
        emporte: false,
        nom_reservation_archive: null,
        date_encaissement: dateEncodage + 'T12:00:00',
        depenses: true,
        lignes: [{
          article_id: saisieDepense.article.id,
          article_nom: saisieDepense.article.nom,
          quantite: -1,
          prix_vente: montant,
          tva: saisieDepense.article.tva,
          vente_analysee: true,
        }],
      });
      setSaisieDepense(null);
      navigate(urlRetourPlan);
    } catch (e) {
      setError(errMsg(e, "Erreur lors de l'enregistrement de la dépense"));
    }
  };

  const modifierMontantLigne = async (ligne, nouveauMontantStr) => {
    const montant = Number(String(nouveauMontantStr).replace(',', '.'));
    if (!Number.isFinite(montant) || montant < 0) return;
    setError('');
    try {
      const res = await api.patch('/commandes/' + ligne.id, { prix_unitaire: montant });
      setLignes(prev => prev.map(l => l.id === ligne.id ? res.data : l));
    } catch (e) {
      setError(errMsg(e, 'Erreur lors de la mise à jour du montant'));
    }
  };

  const changerQuantite = async (ligne, delta) => {
    const nouvelleQuantite = Number(ligne.quantite) + delta;
    setError('');
    try {
      if (nouvelleQuantite <= 0) {
        await api.delete('/commandes/' + ligne.id);
        setLignes(prev => prev.filter(l => l.id !== ligne.id));
      } else {
        const res = await api.patch('/commandes/' + ligne.id, { quantite: nouvelleQuantite });
        setLignes(prev => prev.map(l => l.id === ligne.id ? res.data : l));
      }
    } catch (e) {
      setError(errMsg(e, 'Erreur lors de la mise à jour'));
    }
  };

  const supprimerLigne = async (ligne) => {
    setError('');
    try {
      await api.delete('/commandes/' + ligne.id);
      setLignes(prev => prev.filter(l => l.id !== ligne.id));
    } catch (e) {
      setError(errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const viderCaddy = async () => {
    if (lignes.length === 0) return;
    if (!window.confirm('Vider tout le caddy de cette table ? Cette action est irréversible.')) return;
    setError('');
    try {
      await Promise.all(lignes.map(l => api.delete('/commandes/' + l.id)));
      setLignes([]);
      showMsg('success', 'Caddy vidé');
    } catch (e) {
      setError(errMsg(e, 'Erreur lors du vidage du caddy'));
      load();
    }
  };

  const changerTableLigne = async (ligne, nouveauTableIdStr) => {
    const nouveauTableId = Number(nouveauTableIdStr);
    if (!nouveauTableId || nouveauTableId === Number(tableId)) return;
    setError('');
    try {
      await api.patch('/commandes/' + ligne.id, { table_id: nouveauTableId });
      setLignes(prev => prev.filter(l => l.id !== ligne.id));
      const nomCible = toutesLesTables.find(t => t.id === nouveauTableId)?.nom || 'la table choisie';
      showMsg('success', 'Article déplacé vers ' + nomCible);
    } catch (e) {
      setError(errMsg(e, "Erreur lors du changement de table (le backend accepte-t-il de modifier table_id sur une commande ?)"));
      load();
    }
  };

  const nomArticle = (articleId) => {
    const a = articles.find(a => a.id === articleId);
    return a ? a.nom : 'Article #' + articleId;
  };

  const estArticleCuisine = (articleId) => {
    const a = articles.find(a => a.id === articleId);
    return !!(a && a.imprimer_cuisine);
  };

  const lignesCuisineTotales = estEcranDepense ? [] : lignes.filter(l => estArticleCuisine(l.article_id));
  const lignesCuisineNonImprimees = lignesCuisineTotales.filter(l => !l.imprime);

  const construireContenuTicket = (lignesTicket) => {
    const items = lignesTicket.map(l => ({
      nom: nomArticle(l.article_id),
      quantite: Number(l.quantite),
    }));
    return {
      table: table ? table.nom : '',
      reservation: table ? (table.nom_reservation || '') : '',
      heureArrivee: heureArrivee,
      items,
    };
  };

  const imprimerTicketCuisine = (contenu) => {
    const fenetre = window.open('', '_blank', 'width=400,height=600');
    if (!fenetre) {
      setError("Impossible d'ouvrir la fenêtre d'impression (pop-up bloqué ?)");
      return;
    }
    const ligneItems = contenu.items.map(it =>
      '<div class="item"><span class="qte">' + it.quantite + ' ×</span> <span class="nom">' + escapeHtml(it.nom) + '</span></div>'
    ).join('');
    fenetre.document.write(`
      <html>
        <head>
          <meta charset="utf-8" />
          <title>Ticket cuisine</title>
          <style>
            @page { size: 72mm auto; margin: 2mm; }
            body { font-family: 'Courier New', monospace; width: 68mm; margin: 0; padding: 4px; }
            .espace-haut { height: ${ESPACE_HAUT_TICKET_CUISINE_MM}mm; }
            h1 { font-size: 16px; text-align: center; margin: 0 0 8px; }
            .table { font-size: 15px; font-weight: bold; text-align: center; margin-bottom: 4px; }
            .reservation { font-size: 13px; text-align: center; margin-bottom: 10px; }
            hr { border: none; border-top: 1px dashed #000; margin: 8px 0; }
            .item { font-size: 14px; margin-bottom: 6px; }
            .qte { font-weight: bold; }
            .heure-arrivee { font-size: 12px; text-align: center; margin-bottom: 8px; color: #333; }
          </style>
        </head>
        <body>
          <div class="espace-haut"></div>
          <h1>🍳 CUISINE</h1>
          <div class="table">${escapeHtml(contenu.table)}</div>
          ${contenu.reservation ? '<div class="reservation">' + escapeHtml(contenu.reservation) + '</div>' : ''}
          ${contenu.heureArrivee ? '<div class="heure-arrivee">Arrivée : ' + escapeHtml(contenu.heureArrivee) + '</div>' : ''}
          <hr />
          ${ligneItems || '<div class="item">(aucun article)</div>'}
        </body>
      </html>
    `);
    fenetre.document.close();
    fenetre.focus();
    setTimeout(() => { fenetre.print(); }, 250);
  };

  const escapeHtml = (s) =>
    String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  const marquerImprimees = async (lignesAMarquer) => {
    try {
      await Promise.all(lignesAMarquer.map(l => api.patch('/commandes/' + l.id, { imprime: true })));
      setLignes(prev => prev.map(l =>
        lignesAMarquer.some(m => m.id === l.id) ? { ...l, imprime: true } : l
      ));
    } catch (e) {
      setError("Erreur lors de la mise à jour du statut d'impression");
    }
  };

  const handleImprimerCuisine = async () => {
    if (lignesCuisineNonImprimees.length === 0) {
      setError('Aucun nouvel article à envoyer en cuisine');
      return;
    }
    setError('');
    imprimerTicketCuisine(construireContenuTicket(lignesCuisineNonImprimees));
    await marquerImprimees(lignesCuisineNonImprimees);
  };

  const handleReimprimerComplet = () => {
    if (lignesCuisineTotales.length === 0) {
      setError('Aucun article cuisine sur cette commande');
      return;
    }
    setError('');
    imprimerTicketCuisine(construireContenuTicket(lignesCuisineTotales));
  };

  const handleVoirPdf = () => {
    if (lignesCuisineTotales.length === 0) {
      setError('Aucun article cuisine sur cette commande');
      return;
    }
    setError('');
    const contenu = construireContenuTicket(lignesCuisineTotales);
    const hauteurMm = 40 + ESPACE_HAUT_TICKET_CUISINE_MM + (contenu.heureArrivee ? 6 : 0) + contenu.items.length * 8;
    const doc = new jsPDF({ unit: 'mm', format: [72, hauteurMm] });
    let y = 10 + ESPACE_HAUT_TICKET_CUISINE_MM;
    doc.setFontSize(13);
    doc.setFont(undefined, 'bold');
    doc.text('CUISINE', 36, y, { align: 'center' });
    y += 7;
    doc.setFontSize(12);
    doc.text(contenu.table, 36, y, { align: 'center' });
    y += 6;
    if (contenu.reservation) {
      doc.setFontSize(10);
      doc.setFont(undefined, 'normal');
      doc.text(contenu.reservation, 36, y, { align: 'center' });
      y += 6;
    }
    if (contenu.heureArrivee) {
      doc.setFontSize(10);
      doc.setFont(undefined, 'normal');
      doc.text('Arrivée : ' + contenu.heureArrivee, 36, y, { align: 'center' });
      y += 6;
    }
    doc.setLineDashPattern([1, 1], 0);
    doc.line(4, y, 68, y);
    y += 6;
    doc.setFontSize(11);
    contenu.items.forEach(it => {
      doc.setFont(undefined, 'bold');
      const prefixe = it.quantite + ' x ';
      doc.text(prefixe, 4, y);
      doc.setFont(undefined, 'normal');
      doc.text(it.nom, 4 + doc.getTextWidth(prefixe), y);
      y += 6;
    });
    const blobUrl = doc.output('bloburl');
    window.open(blobUrl, '_blank');
  };

  const handleImprimerAddition = () => {
    if (lignes.length === 0) {
      setError('Aucun article dans la commande');
      return;
    }
    setError('');
    const lignesPourTicket = lignes.map(l => ({
      article_nom: nomArticle(l.article_id),
      quantite: Number(l.quantite),
      prix_vente: Number(l.prix_unitaire),
      tva: Number(l.tva),
    }));
    const data = genererDonneesTicket({
      encaissementId: 'Provisoire',
      dateEncaissement: new Date().toISOString(),
      tableNom: table ? table.nom : '',
      lignes: lignesPourTicket,
      montantCash: 0,
      montantCarte: 0,
      montantTotal: total,
      nbPersonnes: 1,
      estTicketFinal: false,
    });
    genererPdfTicket(data);
  };

  const total = lignes.reduce((sum, l) => sum + Number(l.prix_unitaire) * Number(l.quantite), 0);

  // Paiement express pour les dépenses : crée l'encaissement automatiquement
  // (tout en carte, sans ticket, sans passer par l'écran Paiement) puis
  // retour au plan de salle.
  const payerDepenseExpress = async () => {
    if (lignes.length === 0) {
      setError('Aucune dépense à enregistrer');
      return;
    }
    setError('');
    const todayStr = (() => {
      const d = new Date();
      return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    })();
    const dateEncodage = retourDate || todayStr;
    try {
      await api.post('/encaissements/', {
        table_nom: table.nom,
        client_id: null,
        montant_carte: total,
        montant_cash: 0,
        montant_total: total,
        cash_analyse: 0,
        nb_personnes: 1,
        emporte: false,
        nom_reservation_archive: null,
        date_encaissement: dateEncodage + 'T12:00:00',
        depenses: true,
        lignes: lignes.map(l => ({
          article_id: l.article_id,
          article_nom: nomArticle(l.article_id),
          quantite: l.quantite,
          prix_vente: l.prix_unitaire,
          tva: l.tva,
          vente_analysee: true,
        })),
      });
      navigate(urlRetourPlan);
    } catch (e) {
      setError(errMsg(e, "Erreur lors de l'enregistrement de la dépense"));
    }
  };

  const thCell = (extra = {}) => ({ padding: '5px 6px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '3px 6px', border: BORDURE, ...extra });

  if (loading) {
    return (
      <div>
        <div className="content">Chargement...</div>
      </div>
    );
  }

  return (
    <div>
      <div className="content">

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}
        {msg && (
          <div style={{
            padding: '8px 14px', borderRadius: 8, marginBottom: 12, fontSize: 13, fontWeight: 500,
            background: msg.type === 'success' ? '#dcfce7' : '#fee2e2',
            color: msg.type === 'success' ? '#16a34a' : '#dc2626',
          }}>
            {msg.text}
          </div>
        )}

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button className="btn" onClick={() => navigate(urlRetourPlan)}>← Retour au plan de salle</button>
            <span style={{
              fontSize: 13, fontWeight: 700, color: '#111',
              background: '#f0f0ee', borderRadius: 6, padding: '6px 12px',
            }}>
              {table ? table.nom : 'Table'}
            </span>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            {!estEcranDepense && (
              <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer' }}>
                <input
                  type="checkbox"
                  checked={emporte}
                  onChange={(e) => setEmporte(e.target.checked)}
                  style={{ width: 16, height: 16 }}
                />
                À emporter
              </label>
            )}
            {!estEcranDepense && (
              <button
                className="btn"
                onClick={handleImprimerAddition}
                title="Imprime l'addition avant paiement (sans mode de paiement)"
              >
                🧾 Imprimer l'addition
              </button>
            )}
            <button
              className="btn"
              style={{ background: '#15803d', color: 'white', fontWeight: 600 }}
              onClick={estEcranDepense
                ? payerDepenseExpress
                : () => navigate('/paiement/' + tableId + (retourDate ? '?retourDate=' + retourDate : ''))
              }
            >
              {estEcranDepense ? '✓ Enregistrer' : 'Payer →'}
            </button>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 16 }}>

          {!estEcranDepense && (
            <div style={{ width: 130, flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {codesVente.filter(c => c !== CODE_VENTE_DEPENSE).map(code => (
                <button
                  key={code}
                  className="btn"
                  style={{
                    background: codeVente === code ? '#111' : 'white',
                    color: codeVente === code ? 'white' : '#333',
                    fontWeight: 600,
                    padding: '12px 8px',
                    fontSize: 13,
                  }}
                  onClick={() => setCodeVente(code)}
                >
                  {LIBELLES_CODE_VENTE[code] || code}
                </button>
              ))}
            </div>
          )}

          <div style={{
            width: 150,
            flexShrink: 0,
            display: 'flex',
            flexDirection: 'column',
            gap: 4,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 8,
            height: 'fit-content',
            maxHeight: 560,
            overflowY: 'auto',
          }}>
            {(estEcranDepense ? categoriesDepense : typesNiveau2).map(t => (
              <button
                key={t}
                onClick={() => setCategorie(t)}
                style={{
                  textAlign: 'left',
                  padding: '10px 12px',
                  borderRadius: 6,
                  border: 'none',
                  fontSize: 13,
                  fontWeight: categorie === t ? 600 : 400,
                  background: categorie === t ? '#f0f0ee' : 'transparent',
                  color: '#222',
                  cursor: 'pointer',
                }}
              >
                {t}
              </button>
            ))}
            {(estEcranDepense ? categoriesDepense : typesNiveau2).length === 0 && (
              <div style={{ color: '#888', fontSize: 13, padding: 8 }}>
                {estEcranDepense ? 'Aucune dépense' : 'Aucun type'}
              </div>
            )}
          </div>

          <div style={{ flex: '1 1 0%', minWidth: 0 }}>
            <div style={{
              display: 'flex',
              flexWrap: 'wrap',
              gap: 8,
            }}>
              {articlesAffiches.map(article => {
                const prix = emporte && article.prix_vente_away != null ? article.prix_vente_away : article.prix_vente;
                return (
                  <button
                    key={article.id}
                    className="btn"
                    onClick={() => estEcranDepense ? ouvrirSaisieDepense(article) : ajouterArticle(article)}
                    title={article.nom}
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'flex-start',
                      justifyContent: 'space-between',
                      textAlign: 'left',
                      height: 64,
                      width: 130,
                      flexShrink: 0,
                      padding: '6px 10px',
                      overflow: 'hidden',
                    }}
                  >
                    <span style={{
                      fontSize: 12,
                      fontWeight: 600,
                      lineHeight: 1.25,
                      display: '-webkit-box',
                      WebkitLineClamp: 2,
                      WebkitBoxOrient: 'vertical',
                      overflow: 'hidden',
                    }}>{article.nom}</span>
                    {estEcranDepense
                      ? <span style={{ fontSize: 11, color: '#888', flexShrink: 0 }}>Saisir un montant</span>
                      : <span style={{ fontSize: 11, color: '#888', flexShrink: 0 }}>{Number(prix).toFixed(2)} €</span>
                    }
                  </button>
                );
              })}
              {articlesAffiches.length === 0 && (
                <div style={{ color: '#888', fontSize: 13 }}>Aucun article dans cette catégorie</div>
              )}
            </div>
          </div>

          <div style={{
            width: estEcranDepense ? 420 : 480,
            flexShrink: 0,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 16,
            height: 'fit-content',
            position: 'sticky',
            top: 16,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
              <div style={{ fontWeight: 600, fontSize: 15 }}>
                {estEcranDepense ? 'Dépenses en cours' : 'Commande en cours'}
              </div>
              {lignes.length > 0 && (
                <button
                  className="btn"
                  style={{ fontSize: 12, color: '#dc2626', borderColor: '#fca5a5' }}
                  onClick={viderCaddy}
                  title="Supprime toutes les lignes de ce caddy"
                >
                  🗑️ Vider tout
                </button>
              )}
            </div>

            {!estEcranDepense && lignesCuisineTotales.length > 0 && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginBottom: 16 }}>
                <button
                  className="btn"
                  style={{
                    background: lignesCuisineNonImprimees.length > 0 ? '#b91c1c' : '#e5e5e0',
                    color: lignesCuisineNonImprimees.length > 0 ? 'white' : '#888',
                    fontWeight: 600, fontSize: 13,
                  }}
                  onClick={handleImprimerCuisine}
                  disabled={lignesCuisineNonImprimees.length === 0}
                  title="Imprime uniquement les articles cuisine pas encore envoyés"
                >
                  🍳 Imprimer cuisine{lignesCuisineNonImprimees.length > 0 ? ' (' + lignesCuisineNonImprimees.length + ')' : ''}
                </button>
                <div style={{ display: 'flex', gap: 6 }}>
                  <button
                    className="btn"
                    style={{ flex: 1, fontSize: 12, color: '#666' }}
                    onClick={handleReimprimerComplet}
                    title="Réimprime tout le ticket cuisine, sans tenir compte du statut déjà imprimé"
                  >
                    ↻ Réimprimer tout
                  </button>
                  <button
                    className="btn"
                    style={{ flex: 1, fontSize: 12, color: '#666' }}
                    onClick={handleVoirPdf}
                    title="Génère un PDF du ticket cuisine (test ou secours si l'imprimante ne fonctionne pas)"
                  >
                    📄 Voir en PDF
                  </button>
                </div>
              </div>
            )}

            {lignes.length === 0 ? (
              <div style={{ color: '#888', fontSize: 13, marginBottom: 12 }}>
                {estEcranDepense ? 'Aucune dépense saisie' : 'Aucun article commandé'}
              </div>
            ) : (
              <div style={{ border: BORDURE, borderRadius: 8, overflow: 'auto', marginBottom: 16 }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, tableLayout: 'fixed' }}>
                  <colgroup>
                    <col style={{ width: 'auto' }} />
                    {!estEcranDepense && <col style={{ width: 78 }} />}
                    <col style={{ width: 66 }} />
                    {!estEcranDepense && <col style={{ width: 66 }} />}
                    {!estEcranDepense && <col style={{ width: 52 }} />}
                    <col style={{ width: 30 }} />
                  </colgroup>
                  <thead>
                    <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                      <th style={thCell()}>Article</th>
                      {!estEcranDepense && <th style={thCell({ textAlign: 'center' })}>Qté</th>}
                      <th style={thCell({ textAlign: 'right' })}>{estEcranDepense ? 'Montant' : 'Prix u.'}</th>
                      {!estEcranDepense && <th style={thCell({ textAlign: 'right' })}>Total</th>}
                      {!estEcranDepense && <th style={thCell()}>Table</th>}
                      <th style={thCell()}></th>
                    </tr>
                  </thead>
                  <tbody>
                    {lignes.map(ligne => (
                      <tr key={ligne.id}>
                        <td style={tdCell({ maxWidth: 140 })}>
                          <div style={{ fontWeight: 500 }}>
                            {nomArticle(ligne.article_id)}
                            {ligne.emporte && <span style={{ fontSize: 11, color: '#888' }}> (emporté)</span>}
                          </div>
                        </td>

                        {!estEcranDepense && (
                          <td style={tdCell({ textAlign: 'center' })}>
                            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 4 }}>
                              <button
                                className="btn"
                                style={{ width: 22, height: 22, padding: 0, fontSize: 13, lineHeight: 1 }}
                                onClick={() => changerQuantite(ligne, -1)}
                              >−</button>
                              <span style={{ minWidth: 16, textAlign: 'center' }}>{Number(ligne.quantite)}</span>
                              <button
                                className="btn"
                                style={{ width: 22, height: 22, padding: 0, fontSize: 13, lineHeight: 1 }}
                                onClick={() => changerQuantite(ligne, 1)}
                              >+</button>
                            </div>
                          </td>
                        )}

                        <td style={tdCell({ padding: '2px 4px' })}>
                          <input
                            type="number"
                            step="0.01"
                            min="0"
                            defaultValue={Number(ligne.prix_unitaire).toFixed(2)}
                            onBlur={(e) => modifierMontantLigne(ligne, e.target.value)}
                            style={{
                              width: estEcranDepense ? 80 : 60, padding: '4px 6px', borderRadius: 6,
                              border: '1px solid #ddd', fontSize: 12, textAlign: 'right', boxSizing: 'border-box',
                            }}
                          />
                        </td>

                        {!estEcranDepense && (
                          <td style={tdCell({ textAlign: 'right', fontWeight: 600, whiteSpace: 'nowrap' })}>
                            {(Number(ligne.prix_unitaire) * Number(ligne.quantite)).toFixed(2)} €
                          </td>
                        )}

                        {!estEcranDepense && (
                          <td style={tdCell({ padding: '2px 4px' })}>
                            <select
                              value={ligne.table_id ?? Number(tableId)}
                              onChange={(e) => changerTableLigne(ligne, e.target.value)}
                              style={{ width: '100%', padding: '3px 4px', borderRadius: 5, border: '1px solid #ddd', fontSize: 11 }}
                              title="Déplacer cet article vers une autre table"
                            >
                              {[...toutesLesTables]
                                .sort((a, b) => a.nom.localeCompare(b.nom, 'fr', { numeric: true }))
                                .map(t => (
                                  <option key={t.id} value={t.id}>{t.nom}</option>
                                ))}
                            </select>
                          </td>
                        )}

                        <td style={tdCell()}>
                          <button
                            className="btn"
                            style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                            onClick={() => supprimerLigne(ligne)}
                            title="Supprimer cette ligne"
                          >✕</button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}

            <div style={{
              borderTop: '1px solid #e5e5e0',
              paddingTop: 12,
              display: 'flex',
              justifyContent: 'space-between',
              fontSize: 16,
              fontWeight: 700,
            }}>
              <span>Total</span>
              <span>{total.toFixed(2)} €</span>
            </div>
          </div>

        </div>
      </div>

      {saisieDepense && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}
          onClick={() => setSaisieDepense(null)}
        >
          <div
            style={{ background: 'white', borderRadius: 10, padding: 24, width: 320 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 4 }}>{saisieDepense.article.nom}</div>
            <div style={{ fontSize: 12, color: '#888', marginBottom: 16 }}>Montant de la dépense</div>

            <input
              type="number"
              step="0.01"
              min="0"
              autoFocus
              value={saisieDepense.montant}
              onChange={(e) => setSaisieDepense({ ...saisieDepense, montant: e.target.value })}
              onKeyDown={(e) => { if (e.key === 'Enter') validerSaisieDepense(); }}
              placeholder="Ex: 47.30"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 15, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={() => setSaisieDepense(null)}>Annuler</button>
              <button
                className="btn"
                style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }}
                onClick={validerSaisieDepense}
              >Ajouter</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
