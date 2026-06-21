import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../api/api';

export default function Paiement() {
  const { tableId } = useParams();
  const navigate = useNavigate();

  const [table, setTable] = useState(null);
  const [lignes, setLignes] = useState([]);
  const [articles, setArticles] = useState([]);
  const [montantCarte, setMontantCarte] = useState('');
  const [montantCash, setMontantCash] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const [enregistrement, setEnregistrement] = useState(false);

  const load = async () => {
    try {
      const [tableRes, lignesRes, articlesRes] = await Promise.all([
        api.get('/tables/' + tableId),
        api.get('/commandes/', { params: { table_id: tableId } }),
        api.get('/articles/'),
      ]);
      setTable(tableRes.data);
      setLignes(lignesRes.data);
      setArticles(articlesRes.data);
    } catch (e) {
      setError(e.response?.data?.detail || 'Impossible de charger la commande');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, [tableId]);

  const nomArticle = (articleId) => {
    const a = articles.find(a => a.id === articleId);
    return a ? a.nom : 'Article #' + articleId;
  };

  const total = lignes.reduce((sum, l) => sum + Number(l.prix_unitaire) * Number(l.quantite), 0);

  const carte = Number(montantCarte) || 0;
  const cash = Number(montantCash) || 0;
  const totalSaisi = carte + cash;
  const ecart = Math.round((totalSaisi - total) * 100) / 100;

  const cliquerCarte = () => {
    setMontantCarte(total.toFixed(2));
    setMontantCash('');
  };

  const cliquerCash = () => {
    setMontantCash(total.toFixed(2));
    setMontantCarte('');
  };

  const validerPaiement = async () => {
    setError('');

    if (lignes.length === 0) {
      setError('Aucun article à payer pour cette table');
      return;
    }
    if (ecart !== 0) {
      setError('Le total Carte + Cash (' + totalSaisi.toFixed(2) + ' €) ne correspond pas au total à payer (' + total.toFixed(2) + ' €)');
      return;
    }

    setEnregistrement(true);
    try {
      await api.post('/encaissements/', {
        table_nom: table.nom,
        montant_carte: carte,
        montant_cash: cash,
        montant_total: total,
        nb_personnes: 1,
        emporte: lignes.some(l => l.emporte),
        lignes: lignes.map(l => ({
          article_id: l.article_id,
          article_nom: nomArticle(l.article_id),
          quantite: l.quantite,
          prix_vente: l.prix_unitaire,
          tva: l.tva,
        })),
      });
      navigate('/');
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement du paiement");
      setEnregistrement(false);
    }
  };

  if (loading) {
    return (
      <div>
        <div className="topbar"><h1>Paiement</h1></div>
        <div className="content">Chargement...</div>
      </div>
    );
  }

  return (
    <div>
      <div className="topbar">
        <h1>{table ? table.nom : 'Table'} — Paiement</h1>
      </div>
      <div className="content">

        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12, fontWeight: 500 }}>{error}</div>}

        <button className="btn" onClick={() => navigate('/caddy/' + tableId)} style={{ marginBottom: 16 }}>
          ← Retour au caddy
        </button>

        <div style={{ maxWidth: 480, margin: '0 auto' }}>

          {/* Bloc paiement */}
          <div style={{
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 20,
            marginBottom: 20,
          }}>
            <div style={{
              background: '#15803d',
              color: 'white',
              borderRadius: 8,
              padding: '16px 20px',
              marginBottom: 20,
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'baseline',
            }}>
              <span style={{ fontSize: 16, fontWeight: 600 }}>À payer</span>
              <span style={{ fontSize: 28, fontWeight: 700 }}>{total.toFixed(2)} €</span>
            </div>

            <div style={{ fontSize: 13, color: '#888', marginBottom: 8 }}>Payer avec</div>

            <div style={{ display: 'flex', gap: 10, marginBottom: 16 }}>
              <button className="btn" style={{ flex: 1, padding: '12px 0' }} onClick={cliquerCarte}>
                💳 Carte
              </button>
              <button className="btn" style={{ flex: 1, padding: '12px 0' }} onClick={cliquerCash}>
                💶 Cash
              </button>
            </div>

            <div style={{ display: 'flex', gap: 12, marginBottom: 16 }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>Carte</div>
                <input
                  type="number"
                  step="0.01"
                  value={montantCarte}
                  onChange={(e) => setMontantCarte(e.target.value)}
                  style={inputStyle}
                  placeholder="0.00"
                />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>Cash</div>
                <input
                  type="number"
                  step="0.01"
                  value={montantCash}
                  onChange={(e) => setMontantCash(e.target.value)}
                  style={inputStyle}
                  placeholder="0.00"
                />
              </div>
            </div>

            {ecart !== 0 && (totalSaisi > 0) && (
              <div style={{
                fontSize: 13,
                color: ecart > 0 ? '#16a34a' : '#dc2626',
                marginBottom: 16,
                fontWeight: 500,
              }}>
                {ecart > 0
                  ? 'Excédent de ' + ecart.toFixed(2) + ' € — à rendre si cash'
                  : 'Manque ' + Math.abs(ecart).toFixed(2) + ' €'}
              </div>
            )}

            <button
              className="btn"
              style={{
                width: '100%',
                padding: '14px 0',
                background: '#111',
                color: 'white',
                fontWeight: 600,
                fontSize: 15,
                opacity: enregistrement ? 0.6 : 1,
              }}
              onClick={validerPaiement}
              disabled={enregistrement}
            >
              {enregistrement ? 'Enregistrement...' : 'Valider le paiement'}
            </button>
          </div>

          {/* Tableau récapitulatif des articles, en confirmation du montant ci-dessus */}
          <div style={{
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            overflow: 'hidden',
          }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={{ padding: '10px 14px' }}>Article</th>
                  <th style={{ padding: '10px 14px', textAlign: 'right' }}>Qté</th>
                  <th style={{ padding: '10px 14px', textAlign: 'right' }}>Px vente</th>
                  <th style={{ padding: '10px 14px', textAlign: 'right' }}>Total</th>
                </tr>
              </thead>
              <tbody>
                {lignes.map(ligne => (
                  <tr key={ligne.id} style={{ borderTop: '1px solid #f0f0ee' }}>
                    <td style={{ padding: '10px 14px', fontWeight: 500 }}>
                      {nomArticle(ligne.article_id)}
                      {ligne.emporte && <span style={{ fontSize: 11, color: '#888' }}> (emporté)</span>}
                    </td>
                    <td style={{ padding: '10px 14px', textAlign: 'right' }}>{Number(ligne.quantite)}</td>
                    <td style={{ padding: '10px 14px', textAlign: 'right' }}>{Number(ligne.prix_unitaire).toFixed(2)} €</td>
                    <td style={{ padding: '10px 14px', textAlign: 'right', fontWeight: 500 }}>
                      {(Number(ligne.prix_unitaire) * Number(ligne.quantite)).toFixed(2)} €
                    </td>
                  </tr>
                ))}
                {lignes.length === 0 && (
                  <tr>
                    <td colSpan={4} style={{ padding: 20, textAlign: 'center', color: '#888' }}>
                      Aucun article commandé pour cette table
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

        </div>
      </div>
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '10px 12px',
  borderRadius: 8,
  border: '1px solid #ddd',
  fontSize: 16,
  textAlign: 'right',
  boxSizing: 'border-box',
};
