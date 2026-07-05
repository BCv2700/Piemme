import { useState, useEffect } from 'react';
import api from '../api/api';

// Bordure de quadrillage commune à toutes les cellules du tableau (même convention que Articles.jsx)
const BORDURE = '1px solid #e5e5e0';

const ARTICLE_ACHAT_VIDE = {
  nom: '',
  qte: 1,
  prix_achat: '',
  magasin: '',
  a_commander: false,
};

export default function Achats() {
  const [articles, setArticles] = useState([]);
  const [filtreLettre, setFiltreLettre] = useState(null); // null = toutes les lettres, sinon 'A'..'Z'
  const [filtreCochesUniquement, setFiltreCochesUniquement] = useState(false);
  const [creation, setCreation] = useState(null); // null = fermé, sinon = ARTICLE_ACHAT_VIDE en cours de saisie
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);
  const [envoiEnCours, setEnvoiEnCours] = useState(false);

  const load = () => {
    setLoading(true);
    api.get('/articles-achat/')
      .then(r => setArticles(r.data))
      .catch(() => setError('Impossible de charger la liste des achats'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const afficherMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3500);
  };

  // Fournisseurs déjà utilisés, pour l'autocomplétion du champ magasin (datalist)
  const magasinsExistants = [...new Set(articles.map(a => a.magasin).filter(Boolean))]
    .sort((a, b) => a.localeCompare(b, 'fr'));

  const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  const articlesAffiches = articles.filter(a =>
    (!filtreLettre || a.nom.toUpperCase().startsWith(filtreLettre)) &&
    (!filtreCochesUniquement || a.a_commander)
  );

  const sousTotal = (a) => (a.prix_achat != null ? Number(a.prix_achat) * Number(a.qte) : 0);
  const totalGeneral = articlesAffiches.reduce((s, a) => s + sousTotal(a), 0);
  const articlesCoches = articles.filter(a => a.a_commander);
  const totalSelection = articlesCoches.reduce((s, a) => s + sousTotal(a), 0);

  // ───── Édition inline (comme dans Articles.jsx) ──────────────────────────
  const majArticle = async (id, champs) => {
    setError('');
    try {
      const res = await api.patch('/articles-achat/' + id, champs);
      setArticles(prev => prev.map(a => a.id === id ? res.data : a));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la mise à jour');
    }
  };

  const changerQte = (article, valeur) => {
    const n = Number(valeur);
    if (!Number.isFinite(n) || n < 0) return;
    majArticle(article.id, { qte: n });
  };

  const changerPrix = (article, valeur) => {
    const v = String(valeur).replace(',', '.');
    if (v === '') { majArticle(article.id, { prix_achat: null }); return; }
    const n = Number(v);
    if (!Number.isFinite(n) || n < 0) return;
    majArticle(article.id, { prix_achat: n });
  };

  const changerMagasin = (article, valeur) => {
    majArticle(article.id, { magasin: valeur === '' ? null : valeur });
  };

  const basculerCommander = (article) => {
    majArticle(article.id, { a_commander: !article.a_commander });
  };

  // Décoche tous les articles actuellement cochés "à commander". Envoi
  // SÉQUENTIEL (une requête à la fois) pour ne pas saturer les connexions
  // Postgres de Railway comme ça a été le cas avec "tout cocher".
  const toutDecocher = async () => {
    if (articlesCoches.length === 0) return;
    setError('');
    for (const a of articlesCoches) {
      try {
        const res = await api.patch('/articles-achat/' + a.id, { a_commander: false });
        setArticles(prev => prev.map(x => x.id === a.id ? res.data : x));
      } catch (e) {
        setError(e.response?.data?.detail || 'Erreur lors de la mise à jour');
      }
    }
  };

  const supprimer = async (article) => {
    if (!window.confirm('Supprimer définitivement « ' + article.nom + ' » de la liste d\u2019achats ?')) return;
    setError('');
    try {
      await api.delete('/articles-achat/' + article.id);
      setArticles(prev => prev.filter(a => a.id !== article.id));
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la suppression');
    }
  };

  // ───── Création ───────────────────────────────────────────────────────────
  const ouvrirCreation = () => setCreation({ ...ARTICLE_ACHAT_VIDE });
  const fermerCreation = () => setCreation(null);

  const creerArticle = async () => {
    if (!creation.nom.trim()) {
      afficherMsg('error', 'Le nom est requis');
      return;
    }
    setError('');
    try {
      const payload = {
        ...creation,
        qte: Number(creation.qte) || 0,
        prix_achat: creation.prix_achat === '' ? null : Number(String(creation.prix_achat).replace(',', '.')),
        magasin: creation.magasin === '' ? null : creation.magasin,
      };
      const res = await api.post('/articles-achat/', payload);
      setArticles(prev => [...prev, res.data]);
      setCreation(null);
      afficherMsg('success', 'Article ajouté');
    } catch (e) {
      afficherMsg('error', e.response?.data?.detail || "Erreur lors de l'ajout");
    }
  };

  // ───── Impression de la liste (articles cochés, groupés par fournisseur) ──
  const imprimerListe = () => {
    if (articlesCoches.length === 0) {
      afficherMsg('error', 'Aucun article coché à imprimer');
      return;
    }
    const parMagasin = {};
    articlesCoches.forEach(a => {
      const cle = a.magasin || 'Non classé';
      if (!parMagasin[cle]) parMagasin[cle] = [];
      parMagasin[cle].push(a);
    });
    const magasinsTries = Object.keys(parMagasin).sort((a, b) => a.localeCompare(b, 'fr'));

    const escapeHtml = (s) =>
      String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

    let total = 0;
    const blocs = magasinsTries.map(magasin => {
      const lignesHtml = parMagasin[magasin].map(a => {
        const st = sousTotal(a);
        total += st;
        return '<tr>'
          + '<td class="qte">' + a.qte + '</td>'
          + '<td>' + escapeHtml(a.nom) + '</td>'
          + '<td class="montant">' + (a.prix_achat != null ? Number(a.prix_achat).toFixed(2) + ' €' : '—') + '</td>'
          + '<td class="montant">' + (a.prix_achat != null ? st.toFixed(2) + ' €' : '—') + '</td>'
          + '</tr>';
      }).join('');
      return '<h2>' + escapeHtml(magasin) + '</h2>'
        + '<table><thead><tr><th>Qté</th><th>Article</th><th>Prix unit.</th><th>Sous-total</th></tr></thead>'
        + '<tbody>' + lignesHtml + '</tbody></table>';
    }).join('');

    const fenetre = window.open('', '_blank', 'width=700,height=900');
    if (!fenetre) {
      afficherMsg('error', "Impossible d'ouvrir la fenêtre d'impression (pop-up bloqué ?)");
      return;
    }
    fenetre.document.write(`
      <html>
        <head>
          <meta charset="utf-8" />
          <title>Liste d'achats</title>
          <style>
            @page { size: A4; margin: 15mm; }
            body { font-family: Arial, sans-serif; color: #222; }
            h1 { font-size: 20px; margin-bottom: 4px; }
            .date { font-size: 12px; color: #666; margin-bottom: 20px; }
            h2 { font-size: 15px; margin: 18px 0 6px; border-bottom: 1px solid #ccc; padding-bottom: 4px; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 13px; }
            th { text-align: left; padding: 4px 8px; border-bottom: 1px solid #999; }
            td { padding: 3px 8px; border-bottom: 1px solid #eee; }
            .qte { width: 40px; }
            .montant { text-align: right; white-space: nowrap; }
            .total { text-align: right; font-size: 15px; font-weight: bold; margin-top: 16px; }
          </style>
        </head>
        <body>
          <h1>Liste d'achats</h1>
          <div class="date">${new Date().toLocaleDateString('fr-BE', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</div>
          ${blocs}
          <div class="total">Total : ${total.toFixed(2)} €</div>
        </body>
      </html>
    `);
    fenetre.document.close();
    fenetre.focus();
    setTimeout(() => { fenetre.print(); }, 250);
  };

  // ───── Envoi par email (backend, Gmail) ───────────────────────────────────
  const envoyerParMail = async () => {
    if (articlesCoches.length === 0) {
      afficherMsg('error', 'Aucun article coché à envoyer');
      return;
    }
    if (!window.confirm('Envoyer la liste des ' + articlesCoches.length + ' article(s) coché(s) par email ?')) return;
    setEnvoiEnCours(true);
    setError('');
    try {
      const res = await api.post('/articles-achat/envoyer-commande');
      afficherMsg('success', res.data.message || 'Email envoyé');
    } catch (e) {
      afficherMsg('error', e.response?.data?.detail || "Erreur lors de l'envoi de l'email");
    }
    setEnvoiEnCours(false);
  };

  const thCell = (extra = {}) => ({ padding: '6px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });

  return (
    <div>
      <div className="content">

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

        <div style={{
          display: 'flex', alignItems: 'center', gap: 16, marginBottom: 12,
          padding: '10px 16px', borderRadius: 8, background: '#fef3c7', border: '1px solid #fcd34d',
          flexWrap: 'wrap',
        }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: '#92400e' }}>
            {articlesCoches.length} article{articlesCoches.length > 1 ? 's' : ''} coché{articlesCoches.length > 1 ? 's' : ''} — {totalSelection.toFixed(2)} €
          </span>
          <button className="btn" onClick={imprimerListe} disabled={articlesCoches.length === 0}>
            🖨️ Imprimer la liste
          </button>
          <button className="btn" onClick={envoyerParMail} disabled={articlesCoches.length === 0 || envoiEnCours}>
            {envoiEnCours ? 'Envoi en cours…' : '✉️ Envoyer par mail'}
          </button>
          <button className="btn" onClick={toutDecocher} disabled={articlesCoches.length === 0} style={{ color: '#888' }}>
            Tout décocher
          </button>
          <span style={{ marginLeft: 'auto', fontSize: 13, color: '#888' }}>
            Total général (liste affichée) : {totalGeneral.toFixed(2)} €
          </span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          <span style={{ fontSize: 13, color: '#888', fontWeight: 600, whiteSpace: 'nowrap' }}>
            {articles.length} article{articles.length !== 1 ? 's' : ''}
          </span>
          <button className="btn" onClick={ouvrirCreation}>+ Nouvel article</button>
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer', padding: '0 4px' }}>
            <input
              type="checkbox"
              checked={filtreCochesUniquement}
              onChange={(e) => setFiltreCochesUniquement(e.target.checked)}
              style={{ width: 16, height: 16 }}
            />
            Cochés uniquement
          </label>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginBottom: 16, flexWrap: 'wrap' }}>
          <button
            className="btn"
            onClick={() => setFiltreLettre(null)}
            style={{
              fontWeight: 600, padding: '6px 12px',
              background: filtreLettre === null ? '#111' : 'white',
              color: filtreLettre === null ? 'white' : '#333',
            }}
          >
            Tout
          </button>
          {ALPHABET.map(lettre => (
            <button
              key={lettre}
              className="btn"
              onClick={() => setFiltreLettre(lettre)}
              style={{
                padding: '6px 10px', minWidth: 32,
                background: filtreLettre === lettre ? '#111' : 'white',
                color: filtreLettre === lettre ? 'white' : '#333',
              }}
            >
              {lettre}
            </button>
          ))}
        </div>

        <datalist id="magasins-datalist">
          {magasinsExistants.map(m => <option key={m} value={m} />)}
        </datalist>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()} title="À commander">Cmd.</th>
                  <th style={thCell()}></th>
                  <th style={thCell()}>ID</th>
                  <th style={thCell()}>Nom</th>
                  <th style={thCell({ textAlign: 'right' })}>Qté</th>
                  <th style={thCell({ textAlign: 'right' })}>Prix achat</th>
                  <th style={thCell()}>Fournisseur</th>
                  <th style={thCell({ textAlign: 'right' })}>Sous-total</th>
                </tr>
              </thead>
              <tbody>
                {articlesAffiches.map((article, index) => {
                  const fondAlterne = index % 2 === 1 ? '#f0f0ec' : 'transparent';
                  return (
                    <tr key={article.id} style={{ background: article.a_commander ? '#fef9e7' : fondAlterne }}>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <input
                          type="checkbox"
                          checked={article.a_commander}
                          onChange={() => basculerCommander(article)}
                          style={{ width: 16, height: 16, cursor: 'pointer' }}
                        />
                      </td>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <button
                          className="btn"
                          title="Supprimer cet article"
                          style={{ color: '#dc2626', borderColor: '#fca5a5', fontSize: 14, padding: '2px 8px', lineHeight: 1 }}
                          onClick={() => supprimer(article)}
                        >
                          🗑
                        </button>
                      </td>
                      <td style={tdCell({ color: '#aaa' })}>{article.id}</td>
                      <td style={tdCell({ fontWeight: 500 })}>{article.nom}</td>
                      <td style={tdCell({ textAlign: 'right' })}>
                        <input
                          type="number"
                          min="0"
                          defaultValue={article.qte}
                          onBlur={(e) => changerQte(article, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{ width: 56, padding: '3px 6px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12, textAlign: 'right' }}
                        />
                      </td>
                      <td style={tdCell({ textAlign: 'right' })}>
                        <input
                          type="number"
                          step="0.01"
                          min="0"
                          defaultValue={article.prix_achat ?? ''}
                          placeholder="—"
                          onBlur={(e) => changerPrix(article, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{ width: 72, padding: '3px 6px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12, textAlign: 'right' }}
                        />
                      </td>
                      <td style={tdCell()}>
                        <input
                          type="text"
                          list="magasins-datalist"
                          defaultValue={article.magasin || ''}
                          placeholder="—"
                          onBlur={(e) => changerMagasin(article, e.target.value)}
                          onKeyDown={(e) => { if (e.key === 'Enter') e.target.blur(); }}
                          style={{ width: 140, padding: '3px 6px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12 }}
                        />
                      </td>
                      <td style={tdCell({ textAlign: 'right', whiteSpace: 'nowrap' })}>
                        {article.prix_achat != null ? sousTotal(article).toFixed(2) + ' €' : '—'}
                      </td>
                    </tr>
                  );
                })}
                {articlesAffiches.length === 0 && (
                  <tr>
                    <td colSpan={8} style={{ padding: 20, textAlign: 'center', color: '#888', border: BORDURE }}>
                      Aucun article ne correspond à la recherche
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {creation && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 340 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 16 }}>Nouvel article d'achat</div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Nom</label>
            <input
              type="text"
              autoFocus
              value={creation.nom}
              onChange={(e) => setCreation({ ...creation, nom: e.target.value })}
              placeholder="Ex: Farine"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 12, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 10, marginBottom: 12 }}>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Quantité</label>
                <input
                  type="number"
                  min="0"
                  value={creation.qte}
                  onChange={(e) => setCreation({ ...creation, qte: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Prix achat</label>
                <input
                  type="number"
                  step="0.01"
                  min="0"
                  value={creation.prix_achat}
                  onChange={(e) => setCreation({ ...creation, prix_achat: e.target.value })}
                  placeholder="—"
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Fournisseur</label>
            <input
              type="text"
              list="magasins-datalist"
              value={creation.magasin}
              onChange={(e) => setCreation({ ...creation, magasin: e.target.value })}
              placeholder="Ex: COLRUYT"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={fermerCreation}>Annuler</button>
              <button className="btn" style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }} onClick={creerArticle}>Ajouter</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}