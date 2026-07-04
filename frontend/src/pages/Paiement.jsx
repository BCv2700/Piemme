import { useState, useEffect } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import api from '../api/api';
import TicketImprimable from '../components/TicketImprimable';
import { genererDonneesTicket, genererPdfTicket } from '../utils/ticket';

export default function Paiement() {
  const { tableId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const retourDate = searchParams.get('retourDate');
  const urlRetourPlan = retourDate ? '/?date=' + retourDate : '/';
  const urlRetourCaddy = '/caddy/' + tableId + (retourDate ? '?retourDate=' + retourDate : '');

  const [table, setTable] = useState(null);
  const [lignes, setLignes] = useState([]);
  const [articles, setArticles] = useState([]);
  const [nomReservation, setNomReservation] = useState(null);
  const [montantCarte, setMontantCarte] = useState('');
  const [montantCash, setMontantCash] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const [enregistrement, setEnregistrement] = useState(false);
  const [ticketData, setTicketData] = useState(null);

  const todayKey = (() => {
    const d = new Date();
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  })();

  const dateEncodage = retourDate || todayKey;

  const load = async () => {
    try {
      const [tableRes, lignesRes, articlesRes, reservationsRes] = await Promise.all([
        api.get('/tables/' + tableId),
        api.get('/commandes/', { params: { table_id: tableId } }),
        api.get('/articles/'),
        api.get('/reservations/', { params: { date_reservation: dateEncodage } }),
      ]);
      setTable(tableRes.data);
      setLignes(lignesRes.data);
      setArticles(articlesRes.data);
      const resa = reservationsRes.data.find(r => r.table_id === Number(tableId) && r.statut !== 'annulee');
      setNomReservation(resa ? resa.nom_client : null);
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

  const cliquerCarte = () => { setMontantCarte(total.toFixed(2)); setMontantCash(''); };
  const cliquerCash = () => { setMontantCash(total.toFixed(2)); setMontantCarte(''); };

  const verifierAvantEnregistrement = () => {
    setError('');
    if (lignes.length === 0) {
      setError('Aucun article à payer pour cette table');
      return false;
    }
    if (ecart !== 0) {
      setError('Le total Carte + Cash (' + totalSaisi.toFixed(2) + ' €) ne correspond pas au total à payer (' + total.toFixed(2) + ' €)');
      return false;
    }
    return true;
  };

  const enregistrerEncaissement = async () => {
    const res = await api.post('/encaissements/', {
      table_nom: table.nom,
      montant_carte: carte,
      montant_cash: cash,
      montant_total: total,
      nb_personnes: 1,
      emporte: lignes.some(l => l.emporte),
      nom_reservation_archive: nomReservation,
      date_encaissement: dateEncodage + 'T12:00:00',
      lignes: lignes.map(l => ({
        article_id: l.article_id,
        article_nom: nomArticle(l.article_id),
        quantite: l.quantite,
        prix_vente: l.prix_unitaire,
        tva: l.tva,
      })),
    });
    return res.data;
  };

  const construireTicket = (encaissementCree) => genererDonneesTicket({
    encaissementId: encaissementCree.id,
    dateEncaissement: dateEncodage + 'T12:00:00',
    tableNom: table.nom,
    nomReservation,
    lignes: lignes.map(l => ({
      article_nom: nomArticle(l.article_id),
      quantite: l.quantite,
      prix_vente: l.prix_unitaire,
      tva: l.tva,
    })),
    montantCash: cash,
    montantCarte: carte,
    montantTotal: total,
  });

  const validerEtImprimer = async () => {
    if (!verifierAvantEnregistrement()) return;
    setEnregistrement(true);
    try {
      const encaissementCree = await enregistrerEncaissement();
      setTicketData(construireTicket(encaissementCree));
      setTimeout(() => {
        window.print();
        navigate(urlRetourPlan);
      }, 200);
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement du paiement");
      setEnregistrement(false);
    }
  };

  const validerSansTicket = async () => {
    if (!verifierAvantEnregistrement()) return;
    setEnregistrement(true);
    try {
      await enregistrerEncaissement();
      navigate(urlRetourPlan);
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement du paiement");
      setEnregistrement(false);
    }
  };

  const validerEtPdf = async () => {
    if (!verifierAvantEnregistrement()) return;
    setEnregistrement(true);
    try {
      const encaissementCree = await enregistrerEncaissement();
      genererPdfTicket(construireTicket(encaissementCree));
      navigate(urlRetourPlan);
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement du paiement");
      setEnregistrement(false);
    }
  };

  if (loading) {
    return <div><div className="content">Chargement...</div></div>;
  }

  return (
    <div>
      <div className="content">
        {error && <div style={{ color: '#dc2626', fontSize: 13, marginBottom: 12, fontWeight: 500 }}>{error}</div>}

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
          <button className="btn" onClick={() => navigate(urlRetourCaddy)}>← Retour au caddy</button>
          <span style={{ fontSize: 13, fontWeight: 700, color: '#111', background: '#f0f0ee', borderRadius: 6, padding: '6px 12px' }}>
            {table ? table.nom : 'Table'}
          </span>
        </div>

        <div style={{ maxWidth: 480, margin: '0 auto' }}>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, padding: 20, marginBottom: 20 }}>
            <div style={{ background: '#15803d', color: 'white', borderRadius: 8, padding: '16px 20px', marginBottom: 20, display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <span style={{ fontSize: 16, fontWeight: 600 }}>À payer</span>
              <span style={{ fontSize: 28, fontWeight: 700 }}>{total.toFixed(2)} €</span>
            </div>

            <div style={{ fontSize: 13, color: '#888', marginBottom: 8 }}>Payer avec</div>
            <div style={{ display: 'flex', gap: 10, marginBottom: 16 }}>
              <button className="btn" style={{ flex: 1, padding: '12px 0' }} onClick={cliquerCarte}>💳 Carte</button>
              <button className="btn" style={{ flex: 1, padding: '12px 0' }} onClick={cliquerCash}>💶 Cash</button>
            </div>

            <div style={{ display: 'flex', gap: 12, marginBottom: 16 }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>Carte</div>
                <input type="number" step="0.01" value={montantCarte} onChange={(e) => setMontantCarte(e.target.value)} style={inputStyle} placeholder="0.00" />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>Cash</div>
                <input type="number" step="0.01" value={montantCash} onChange={(e) => setMontantCash(e.target.value)} style={inputStyle} placeholder="0.00" />
              </div>
            </div>

            {ecart !== 0 && (totalSaisi > 0) && (
              <div style={{ fontSize: 13, color: ecart > 0 ? '#16a34a' : '#dc2626', marginBottom: 16, fontWeight: 500 }}>
                {ecart > 0 ? 'Excédent de ' + ecart.toFixed(2) + ' € — à rendre si cash' : 'Manque ' + Math.abs(ecart).toFixed(2) + ' €'}
              </div>
            )}

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              <button className="btn" style={{ padding: '14px 0', background: '#111', color: 'white', fontWeight: 600, fontSize: 15, opacity: enregistrement ? 0.6 : 1 }} onClick={validerEtImprimer} disabled={enregistrement}>
                {enregistrement ? 'Enregistrement...' : '🖨️ Valider + Imprimer le ticket'}
              </button>
              <button className="btn" style={{ padding: '12px 0', fontWeight: 500, fontSize: 14, opacity: enregistrement ? 0.6 : 1 }} onClick={validerSansTicket} disabled={enregistrement}>
                Valider sans ticket
              </button>
              <button className="btn" style={{ padding: '12px 0', fontWeight: 500, fontSize: 14, opacity: enregistrement ? 0.6 : 1 }} onClick={validerEtPdf} disabled={enregistrement}>
                📄 Valider + PDF
              </button>
            </div>
          </div>

          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'hidden' }}>
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
                  <tr><td colSpan={4} style={{ padding: 20, textAlign: 'center', color: '#888' }}>Aucun article commandé pour cette table</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <TicketImprimable data={ticketData} />
    </div>
  );
}

const inputStyle = {
  width: '100%', padding: '10px 12px', borderRadius: 8, border: '1px solid #ddd',
  fontSize: 16, textAlign: 'right', boxSizing: 'border-box',
};