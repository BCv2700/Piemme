import { useState, useEffect, useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import api from '../api/api';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

const TAUX_TVA = [6, 12, 21];

export default function Encaissements() {
  const [searchParams] = useSearchParams();
  // Lit la date transmise par le Plan de salle (NavBar) au montage du composant.
  // S'il n'y en a pas (accès direct à /encaissements), on retombe sur aujourd'hui.
  const dateInitiale = searchParams.get('date') || todayKey();

  const [dateUnique, setDateUnique] = useState(dateInitiale);
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  const load = () => {
    setLoading(true);
    api.get('/encaissements/', { params: { date_debut: dateUnique, date_fin: dateUnique } })
      .then(r => setEncaissements(r.data))
      .catch(() => setError('Impossible de charger les encaissements'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateUnique]);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const errMsg = (e, fallback) => {
    const detail = e.response?.data?.detail;
    if (!detail) return fallback;
    if (typeof detail === 'string') return detail;
    if (Array.isArray(detail)) return detail.map(d => d.msg || JSON.stringify(d)).join(' · ');
    return fallback;
  };

  // Répartition par taux de TVA, calculée à partir des lignes de tous les encaissements du jour
  const repartitionTva = useMemo(() => {
    const totaux = { 6: 0, 12: 0, 21: 0, autre: 0 };
    encaissements.forEach(enc => {
      (enc.lignes || []).forEach(ligne => {
        const montant = Number(ligne.prix_vente) * Number(ligne.quantite);
        const taux = Math.round(Number(ligne.tva));
        if (totaux[taux] !== undefined) {
          totaux[taux] += montant;
        } else {
          totaux.autre += montant;
        }
      });
    });
    return totaux;
  }, [encaissements]);

  const totalJour = encaissements.reduce((s, e) => s + Number(e.montant_total || 0), 0);
  const totalCash = encaissements.reduce((s, e) => s + Number(e.montant_cash || 0), 0);
  const totalCarte = encaissements.reduce((s, e) => s + Number(e.montant_carte || 0), 0);
  const totalCashAnalyse = encaissements.reduce((s, e) => s + Number(e.cash_analyse || 0), 0);

  const majLocal = (encId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => e.id === encId ? { ...e, [champ]: valeur } : e));
  };

  const saveEncaissement = async (enc) => {
    try {
      await api.patch('/encaissements/' + enc.id, {
        table_nom: enc.table_nom,
        montant_carte: Number(enc.montant_carte),
        montant_cash: Number(enc.montant_cash),
        montant_total: Number(enc.montant_total),
        cash_analyse: Number(enc.cash_analyse || 0),
        serveur: enc.serveur,
        remarque: enc.remarque,
        depenses: !!enc.depenses,
        emporte: !!enc.emporte,
        nb_personnes: Number(enc.nb_personnes) || 1,
      });
      showMsg('success', 'Encaissement mis à jour');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  const toggleBool = async (enc, champ) => {
    const nouvelleValeur = !enc[champ];
    majLocal(enc.id, champ, nouvelleValeur);
    try {
      await api.patch('/encaissements/' + enc.id, { [champ]: nouvelleValeur });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  const deleteEncaissement = async (encId) => {
    if (!window.confirm('Supprimer cet encaissement et toutes ses lignes ? Action irréversible.')) return;
    try {
      await api.delete('/encaissements/' + encId);
      showMsg('success', 'Encaissement supprimé');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const encaissementsTries = [...encaissements].sort((a, b) => new Date(a.date_encaissement) - new Date(b.date_encaissement));

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

        {/* Navigation jour par jour */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
          <span style={{ marginLeft: 'auto', fontSize: 14, fontWeight: 700 }}>{totalJour.toFixed(2)} €</span>
        </div>

        {/* Répartition par TVA et paiement */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          {TAUX_TVA.map(taux => (
            <div key={taux} style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
              <div style={{ fontSize: 11, color: '#888' }}>TVA {taux}%</div>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{repartitionTva[taux].toFixed(2)} €</div>
            </div>
          ))}
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Cash</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#16a34a' }}>{totalCash.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Carte</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#2563eb' }}>{totalCarte.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 90 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Cash analysé</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#b45309' }}>{totalCashAnalyse.toFixed(2)} €</div>
          </div>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : encaissementsTries.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun encaissement ce jour</div>
        ) : (
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'hidden' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={{ padding: '8px 10px' }}>Réf</th>
                  <th style={{ padding: '8px 10px' }}>Heure</th>
                  <th style={{ padding: '8px 10px' }}>Ticket</th>
                  <th style={{ padding: '8px 10px' }}>Réservation</th>
                  <th style={{ padding: '8px 10px', textAlign: 'center' }}>Emporté</th>
                  <th style={{ padding: '8px 10px', textAlign: 'center' }}>Dépenses</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Cash</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Carte</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Total</th>
                  <th style={{ padding: '8px 10px', textAlign: 'right' }}>Cash analysé</th>
                  <th style={{ padding: '8px 10px' }}></th>
                </tr>
              </thead>
              <tbody>
                {encaissementsTries.map(enc => (
                  <tr key={enc.id} style={{ borderTop: '1px solid #f0f0ee' }}>
                    <td style={{ padding: '6px 10px', color: '#aaa' }}>{enc.id}</td>
                    <td style={{ padding: '6px 10px', whiteSpace: 'nowrap', color: '#666' }}>
                      {new Date(enc.date_encaissement).toLocaleTimeString('fr-BE', { hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        style={{ ...inputStyle, width: 60 }}
                        value={enc.table_nom || ''}
                        onChange={(e) => majLocal(enc.id, 'table_nom', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={{ padding: '6px 10px', color: '#666' }}>{enc.nom_reservation_archive || '—'}</td>
                    <td style={{ padding: '6px 10px', textAlign: 'center' }}>
                      <input type="checkbox" checked={!!enc.emporte} onChange={() => toggleBool(enc, 'emporte')} style={{ width: 15, height: 15, cursor: 'pointer' }} />
                    </td>
                    <td style={{ padding: '6px 10px', textAlign: 'center' }}>
                      <input type="checkbox" checked={!!enc.depenses} onChange={() => toggleBool(enc, 'depenses')} style={{ width: 15, height: 15, cursor: 'pointer' }} />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 75, textAlign: 'right' }}
                        value={enc.montant_cash}
                        onChange={(e) => majLocal(enc.id, 'montant_cash', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 75, textAlign: 'right' }}
                        value={enc.montant_carte}
                        onChange={(e) => majLocal(enc.id, 'montant_carte', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 80, textAlign: 'right', fontWeight: 700 }}
                        value={enc.montant_total}
                        onChange={(e) => majLocal(enc.id, 'montant_total', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={{ padding: '4px 6px' }}>
                      <input
                        type="number" step="0.01"
                        style={{ ...inputStyle, width: 80, textAlign: 'right', color: Number(enc.cash_analyse) > 0 ? '#16a34a' : '#888' }}
                        value={enc.cash_analyse || 0}
                        onChange={(e) => majLocal(enc.id, 'cash_analyse', e.target.value)}
                        onBlur={() => saveEncaissement(enc)}
                      />
                    </td>
                    <td style={{ padding: '6px 10px' }}>
                      <button
                        className="btn"
                        style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                        onClick={() => deleteEncaissement(enc.id)}
                      >✕</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

const inputStyle = {
  width: '100%',
  padding: '4px 6px',
  borderRadius: 5,
  border: '1px solid #ddd',
  fontSize: 12,
  boxSizing: 'border-box',
};
