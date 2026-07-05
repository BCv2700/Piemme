import { useState, useEffect, useMemo } from 'react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';

const LIBELLES_CODE_VENTE = {
  7001: 'Boissons Alcools',
  7002: 'Nourriture',
  7003: 'Boissons Softs',
  7004: 'Boissons Vins',
  7005: 'Divers',
};
const ORDRE_CODE_VENTE = [7001, 7002, 7003, 7004, 7005];

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

export default function CoutMatiere() {
  const [dateUnique, setDateUnique] = useState(todayKey());
  const [encaissements, setEncaissements] = useState([]);
  const [articles, setArticles] = useState([]);
  const [composants, setComposants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const load = () => {
    setLoading(true);
    setError('');
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateUnique, date_fin: dateUnique } }),
      api.get('/articles/'),
      api.get('/articles-composants/'),
    ])
      .then(([encRes, artRes, compRes]) => {
        setEncaissements(encRes.data);
        setArticles(artRes.data);
        setComposants(compRes.data);
      })
      .catch(() => setError('Impossible de charger les données du jour'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateUnique]);

  const articlesParId = useMemo(() => {
    const map = {};
    articles.forEach(a => { map[a.id] = a; });
    return map;
  }, [articles]);

  const composantsParArticle = useMemo(() => {
    const map = {};
    composants.forEach(c => {
      if (!map[c.article_id]) map[c.article_id] = [];
      map[c.article_id].push(c);
    });
    return map;
  }, [composants]);

  // Recettes du jour uniquement (les dépenses n'ont pas de "coût matière")
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Explose chaque ligne vendue en ses composants (ou en elle-même si aucun
  // composant défini, en utilisant Prix d'achat de l'article), regroupés par
  // catégorie (code de vente du plat vendu).
  const { categories, totalCout, totalCa, totalCarte, totalCash } = useMemo(() => {
    const parCategorie = {}; // code_vente -> Map("description|prixUnitaire" -> {description, qteVendue, prixUnitaire, total})
    let coutCumule = 0;
    let caCumule = 0;
    let carteCumule = 0;
    let cashCumule = 0;

    recettes.forEach(enc => {
      carteCumule += Number(enc.montant_carte || 0);
      cashCumule += Number(enc.montant_cash || 0);
      (enc.lignes || []).forEach(ligne => {
        const qte = Number(ligne.quantite);
        caCumule += qte * Number(ligne.prix_vente);
        const article = articlesParId[ligne.article_id];
        const codeVente = article ? article.code_vente : null;
        const compos = article ? (composantsParArticle[article.id] || []) : [];

        const lignesCout = compos.length > 0
          ? compos.map(c => ({ description: c.description, prixUnitaire: Number(c.prix), type: 'composant', id: c.id }))
          : [{ description: article ? article.nom : ligne.article_nom, prixUnitaire: article ? Number(article.prix_achat || 0) : 0, type: 'article', id: article ? article.id : null }];

        lignesCout.forEach(lc => {
          const total = qte * lc.prixUnitaire;
          coutCumule += total;
          const cle = codeVente || 'autre';
          if (!parCategorie[cle]) parCategorie[cle] = new Map();
          // Regroupe les lignes identiques (même description + même prix) au
          // sein d'une catégorie, plutôt que de répéter une ligne par vente :
          // ex. "Tapas" vendu sur 2 commandes séparées => une seule ligne
          // "Qté vendue: 2" au lieu de deux lignes "Qté vendue: 1".
          const cleLigne = lc.description + '|' + lc.prixUnitaire;
          const existante = parCategorie[cle].get(cleLigne);
          if (existante) {
            existante.qteVendue += qte;
            existante.total += total;
            if (lc.id != null && !existante.ids.includes(lc.id)) existante.ids.push(lc.id);
          } else {
            parCategorie[cle].set(cleLigne, {
              description: lc.description,
              qteVendue: qte,
              prixUnitaire: lc.prixUnitaire,
              total,
              type: lc.type,
              ids: lc.id != null ? [lc.id] : [],
            });
          }
        });
      });
    });

    const ordreClefs = [...ORDRE_CODE_VENTE, 'autre'].filter(k => parCategorie[k]);
    const categoriesTriees = ordreClefs.map(cle => ({
      cle,
      libelle: LIBELLES_CODE_VENTE[cle] || 'Non classé',
      lignes: Array.from(parCategorie[cle].values()),
    }));

    return { categories: categoriesTriees, totalCout: coutCumule, totalCa: caCumule, totalCarte: carteCumule, totalCash: cashCumule };
  }, [recettes, articlesParId, composantsParArticle]);

  const pourcentage = totalCa > 0 ? (totalCout / totalCa) * 100 : 0;
  const fmt = (n) => Number(n).toFixed(2);

  // Corrige le prix d'une ligne directement depuis le rapport. Comme une
  // ligne peut regrouper plusieurs composants identiques (même description +
  // même prix, potentiellement sur des plats différents), on met à jour TOUS
  // les composants sous-jacents avec la nouvelle valeur — cohérent puisqu'ils
  // partageaient déjà le même prix avant regroupement. Pour un article sans
  // recette (coût = Prix d'achat), on met à jour l'article directement.
  const corrigerPrix = async (ligne, valeurStr) => {
    const nouveauPrix = Number(String(valeurStr).replace(',', '.'));
    if (!Number.isFinite(nouveauPrix) || nouveauPrix < 0) return;
    if (nouveauPrix === ligne.prixUnitaire) return;
    setError('');
    try {
      if (ligne.type === 'composant') {
        await Promise.all(ligne.ids.map(id => api.patch('/articles-composants/' + id, { prix: nouveauPrix })));
      } else if (ligne.type === 'article' && ligne.ids[0] != null) {
        await api.patch('/articles/' + ligne.ids[0], { prix_achat: nouveauPrix });
      }
      load();
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la mise à jour du prix');
    }
  };

  // ───── Export PDF ─────────────────────────────────────────────────────
  const genererPdf = () => {
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    const dateAffichee = new Date(dateUnique + 'T00:00:00').toLocaleDateString('fr-BE', {
      weekday: 'long', day: 'numeric', month: 'long', year: 'numeric',
    });

    doc.setFontSize(16);
    doc.setFont(undefined, 'bold');
    doc.text('Coût matière', 14, 15);
    doc.setFontSize(11);
    doc.setFont(undefined, 'normal');
    doc.text(dateAffichee, 14, 22);

    doc.setFontSize(9);
    const ligneInfo = '% Coût matière : ' + pourcentage.toFixed(2) + '%'
      + '    Coût matière : ' + fmt(totalCout)
      + '    CA : ' + fmt(totalCa)
      + '    Carte : ' + fmt(totalCarte)
      + '    Cash : ' + fmt(totalCash);
    doc.text(ligneInfo, 14, 29);

    const body = [];
    categories.forEach(cat => {
      body.push([{ content: cat.libelle, colSpan: 4, styles: { fontStyle: 'bold', fillColor: [240, 240, 236] } }]);
      cat.lignes.forEach(l => {
        body.push([l.description, String(l.qteVendue), fmt(l.prixUnitaire), fmt(l.total)]);
      });
    });
    body.push([{ content: 'Total coût matière', colSpan: 3, styles: { fontStyle: 'bold', fillColor: [250, 250, 248] } }, { content: fmt(totalCout), styles: { fontStyle: 'bold', fillColor: [250, 250, 248] } }]);

    autoTable(doc, {
      startY: 34,
      head: [['Composant', 'Qté vendue', 'Prix', 'Total']],
      body,
      styles: { fontSize: 8, cellPadding: 1.5, lineColor: [229, 229, 224], lineWidth: 0.1 },
      headStyles: { fillColor: [250, 250, 248], textColor: [40, 40, 40], fontStyle: 'bold' },
      columnStyles: {
        0: { halign: 'left', cellWidth: 100 },
        1: { halign: 'right' },
        2: { halign: 'right' },
        3: { halign: 'right' },
      },
      margin: { left: 14, right: 14 },
    });

    const nomFichier = 'cout-matiere-' + dateUnique + '.pdf';
    doc.setProperties({ title: nomFichier });
    const blobUrl = doc.output('bloburl');
    window.open(blobUrl, '_blank');
  };

  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, ...extra });

  return (
    <div>
      <div className="content">
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>Coût matière</h2>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
          <button
            onClick={genererPdf}
            style={{
              padding: '6px 14px', fontSize: 12, fontWeight: 600, borderRadius: 8,
              border: '1px solid #ddd', background: 'white', color: '#333', cursor: 'pointer',
            }}
          >
            📄 PDF
          </button>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <>
            <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>% Coût matière</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: pourcentage > 33 ? '#dc2626' : '#16a34a' }}>{pourcentage.toFixed(2)}%</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Coût matière</div>
                <div style={{ fontSize: 18, fontWeight: 700 }}>{fmt(totalCout)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Chiffre d'affaires</div>
                <div style={{ fontSize: 18, fontWeight: 700 }}>{fmt(totalCa)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Carte</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: '#2563eb' }}>{fmt(totalCarte)} €</div>
              </div>
              <div style={{ background: 'white', border: BORDURE, borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Cash</div>
                <div style={{ fontSize: 18, fontWeight: 700, color: '#16a34a' }}>{fmt(totalCash)} €</div>
              </div>
            </div>

            {categories.length === 0 ? (
              <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucune vente ce jour</div>
            ) : (
              <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden', maxWidth: 700 }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                  <thead>
                    <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                      <th style={thCell()}>Composant</th>
                      <th style={thCell({ textAlign: 'right' })}>Qté vendue</th>
                      <th style={thCell({ textAlign: 'right' })}>Prix</th>
                      <th style={thCell({ textAlign: 'right' })}>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {categories.map(cat => (
                      <>
                        <tr key={'cat-' + cat.cle} style={{ background: '#f0f0ec' }}>
                          <td style={tdCell({ fontWeight: 700 })} colSpan={4}>{cat.libelle}</td>
                        </tr>
                        {cat.lignes.map((l, i) => (
                          <tr key={cat.cle + '-' + i}>
                            <td style={tdCell({ paddingLeft: 24 })}>{l.description}</td>
                            <td style={tdCell({ textAlign: 'right' })}>{l.qteVendue}</td>
                            <td style={tdCell({ padding: '2px 6px' })}>
                              <input
                                type="number"
                                step="0.01"
                                min="0"
                                defaultValue={fmt(l.prixUnitaire)}
                                onBlur={(e) => corrigerPrix(l, e.target.value)}
                                onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                                title="Corriger ce prix (mis à jour partout où il est utilisé)"
                                style={{
                                  width: 80, padding: '4px 6px', borderRadius: 5,
                                  border: '1px solid #ddd', fontSize: 13, textAlign: 'right',
                                }}
                              />
                            </td>
                            <td style={tdCell({ textAlign: 'right', fontWeight: 600 })}>{fmt(l.total)}</td>
                          </tr>
                        ))}
                      </>
                    ))}
                  </tbody>
                  <tfoot>
                    <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                      <td style={tdCell()} colSpan={3}>Total coût matière</td>
                      <td style={tdCell({ textAlign: 'right' })}>{fmt(totalCout)}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}