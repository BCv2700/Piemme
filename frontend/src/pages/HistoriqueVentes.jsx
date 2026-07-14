import { useState, useEffect, useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import api from '../api/api';
import DetailEncaissementModal from '../components/DetailEncaissementModal';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

// Bordure de quadrillage commune à toutes les cellules du tableau
const BORDURE = '1px solid #e5e5e0';

export default function HistoriqueVentes() {
  const [searchParams] = useSearchParams();
  const dateInitiale = searchParams.get('date') || todayKey();
  const debutInitial = searchParams.get('debut');
  const finInitial = searchParams.get('fin');
  const modePlageInitial = !!(debutInitial && finInitial);
  const fournisseurInitial = searchParams.get('fournisseur') || '';

  const [modePlage, setModePlage] = useState(modePlageInitial);
  const [dateUnique, setDateUnique] = useState(dateInitiale);
  const [dateDebut, setDateDebut] = useState(debutInitial || dateInitiale);
  const [dateFin, setDateFin] = useState(finInitial || dateInitiale);
  const [filtreDepenses, setFiltreDepenses] = useState(searchParams.get('depenses') === '1');
  const [filtreFournisseur, setFiltreFournisseur] = useState(fournisseurInitial);
  const [encaissements, setEncaissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [detailOuvert, setDetailOuvert] = useState(null);

  const effectiveDebut = modePlage ? dateDebut : dateUnique;
  const effectiveFin = modePlage ? dateFin : dateUnique;

  const load = () => {
    setLoading(true);
    api.get('/encaissements/', { params: { date_debut: effectiveDebut, date_fin: effectiveFin } })
      .then(r => setEncaissements(r.data))
      .catch(() => setError('Impossible de charger l\'historique'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [effectiveDebut, effectiveFin]);

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

  const lignesAPlat = useMemo(() => {
    const rows = [];
    encaissements.forEach(enc => {
      if (filtreDepenses && !enc.depenses) return;
      (enc.lignes || []).forEach(ligne => {
        // Filtre par fournisseur (nom d'article) si actif
        if (filtreFournisseur && (ligne.article_nom || '').trim() !== filtreFournisseur) return;
        rows.push({ enc, ligne });
      });
    });
    rows.sort((a, b) => {
      const dA = new Date(a.enc.date_encaissement).getTime();
      const dB = new Date(b.enc.date_encaissement).getTime();
      if (dA !== dB) return dA - dB;
      return a.ligne.id - b.ligne.id;
    });
    return rows;
  }, [encaissements, filtreDepenses, filtreFournisseur]);

  const majLigneLocal = (encId, ligneId, champ, valeur) => {
    setEncaissements(prev => prev.map(e => {
      if (e.id !== encId) return e;
      return { ...e, lignes: e.lignes.map(l => l.id === ligneId ? { ...l, [champ]: valeur } : l) };
    }));
  };

  const saveLigne = async (ligne) => {
    try {
      await api.patch('/encaissements/lignes/' + ligne.id, {
        article_nom: ligne.article_nom,
        quantite: Number(ligne.quantite),
        prix_vente: Number(ligne.prix_vente),
        tva: Number(ligne.tva),
        vente_analysee: !!ligne.vente_analysee,
      });
      showMsg('success', 'Ligne mise à jour');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour'));
      load();
    }
  };

  const syncCashAnalyse = async (encId, lignesMaj, montantCash) => {
    const sommeAnalysee = lignesMaj.reduce(
      (s, l) => s + (l.vente_analysee ? Number(l.prix_vente) * Number(l.quantite) : 0), 0
    );
    const cash = Number(montantCash) || 0;
    const nouveauCashAnalyse = Math.max(0, Math.min(sommeAnalysee, cash));
    setEncaissements(prev => prev.map(e => e.id === encId ? { ...e, cash_analyse: nouveauCashAnalyse } : e));
    try {
      await api.patch('/encaissements/' + encId, { cash_analyse: nouveauCashAnalyse });
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la mise à jour du cash analysé'));
      load();
    }
  };

  const toggleAnalysee = async (encId, ligne) => {
    const nouvelleValeur = !ligne.vente_analysee;
    majLigneLocal(encId, ligne.id, 'vente_analysee', nouvelleValeur);
    try {
      await api.patch('/encaissements/lignes/' + ligne.id, { vente_analysee: nouvelleValeur });
      const enc = encaissements.find(e => e.id === encId);
      const lignesMaj = enc.lignes.map(l => l.id === ligne.id ? { ...l, vente_analysee: nouvelleValeur } : l);
      await syncCashAnalyse(encId, lignesMaj, enc.montant_cash);
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur'));
      load();
    }
  };

  const deleteLigne = async (encId, ligneId) => {
    if (!window.confirm('Supprimer cette ligne ?')) return;
    try {
      await api.delete('/encaissements/lignes/' + ligneId);
      setEncaissements(prev => prev.map(e => {
        if (e.id !== encId) return e;
        return { ...e, lignes: e.lignes.filter(l => l.id !== ligneId) };
      }));
      showMsg('success', 'Ligne supprimée');
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const totalPeriode = lignesAPlat.reduce((s, { ligne }) => s + Number(ligne.prix_vente) * Number(ligne.quantite), 0);

  // Styles de cellules avec quadrillage
  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 10px', border: BORDURE, ...extra });

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12, flexWrap: 'wrap' }}>
          {!modePlage ? (
            <>
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
              <input
                type="date"
                value={dateUnique}
                onChange={(e) => setDateUnique(e.target.value)}
                style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
            </>
          ) : (
            <>
              <label style={{ fontSize: 13, color: '#888' }}>Du</label>
              <input
                type="date"
                value={dateDebut}
                onChange={(e) => setDateDebut(e.target.value)}
                style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <label style={{ fontSize: 13, color: '#888' }}>au</label>
              <input
                type="date"
                value={dateFin}
                onChange={(e) => setDateFin(e.target.value)}
                style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
            </>
          )}
          <button className="btn" onClick={() => setModePlage(m => !m)} style={{ color: '#888' }}>
            {modePlage ? 'Revenir à un jour précis' : 'Filtrer sur une plage de dates'}
          </button>
          <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, color: '#b91c1c', cursor: 'pointer' }}>
            <input
              type="checkbox"
              checked={filtreDepenses}
              onChange={(e) => setFiltreDepenses(e.target.checked)}
              style={{ cursor: 'pointer' }}
            />
            Dépenses uniquement
          </label>
          {filtreFournisseur && (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6, fontSize: 13, color: '#b45309', background: '#fef3c7', padding: '3px 10px', borderRadius: 6 }}>
              {filtreFournisseur}
              <button
                onClick={() => setFiltreFournisseur('')}
                style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 14, color: '#b45309', fontWeight: 700, padding: 0 }}
                title="Retirer le filtre fournisseur"
              >✕</button>
            </span>
          )}
          <span style={{ marginLeft: 'auto', fontSize: 13, color: '#888' }}>
            {lignesAPlat.length} ligne{lignesAPlat.length !== 1 ? 's' : ''} · Total : <strong style={{ color: '#111' }}>{totalPeriode.toFixed(2)} €</strong>
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : lignesAPlat.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucune vente sur cette période</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}>Réf enc.</th>
                  <th style={thCell()}></th>
                  <th style={thCell()}>Date</th>
                  <th style={thCell()}>Article</th>
                  <th style={thCell({ textAlign: 'center' })}>Qté</th>
                  <th style={thCell({ textAlign: 'center' })}>Px vente</th>
                  <th style={thCell({ textAlign: 'center' })}>TVA %</th>
                  <th style={thCell({ textAlign: 'right' })}>Prix payé</th>
                  <th style={thCell({ textAlign: 'center' })}>Analysée</th>
                  <th style={thCell()}>Ticket</th>
                  <th style={thCell()}>Réservation</th>
                </tr>
              </thead>
              <tbody>
                {lignesAPlat.map(({ enc, ligne }) => (
                  <tr key={ligne.id}>
                    <td
                      style={tdCell({ color: '#2563eb', cursor: 'pointer', textDecoration: 'underline', textDecorationStyle: 'dotted' })}
                      onClick={() => setDetailOuvert(enc.id)}
                      title="Voir / corriger le détail de cet encaissement"
                    >
                      {enc.id}
                    </td>
                    <td style={tdCell()}>
                      <button
                        className="btn"
                        style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                        onClick={() => deleteLigne(enc.id, ligne.id)}
                      >✕</button>
                    </td>
                    <td style={tdCell({ whiteSpace: 'nowrap', color: '#666' })}>
                      {new Date(enc.date_encaissement).toLocaleString('fr-BE', { day: '2-digit', month: '2-digit', year: '2-digit', hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        className="cell-input"
                        style={inputStyle}
                        value={ligne.article_nom}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'article_nom', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input"
                        style={{ ...inputStyle, textAlign: 'right' }}
                        value={ligne.quantite}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'quantite', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        type="number" step="0.01"
                        className="cell-input"
                        style={{ ...inputStyle, textAlign: 'right' }}
                        value={ligne.prix_vente}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'prix_vente', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={tdCell({ padding: '2px 6px' })}>
                      <input
                        type="number" step="1"
                        className="cell-input"
                        style={{ ...inputStyle, textAlign: 'right' }}
                        value={Math.round(ligne.tva)}
                        onChange={(e) => majLigneLocal(enc.id, ligne.id, 'tva', e.target.value)}
                        onBlur={() => saveLigne(ligne)}
                      />
                    </td>
                    <td style={tdCell({ textAlign: 'right', fontWeight: 600 })}>
                      {(Number(ligne.prix_vente) * Number(ligne.quantite)).toFixed(2)} €
                    </td>
                    <td style={tdCell({ textAlign: 'center' })}>
                      <input
                        type="checkbox"
                        checked={!!ligne.vente_analysee}
                        onChange={() => toggleAnalysee(enc.id, ligne)}
                        style={{ width: 15, height: 15, cursor: 'pointer' }}
                      />
                    </td>
                    <td style={tdCell({ color: '#666' })}>{enc.table_nom || '—'}</td>
                    <td style={tdCell({ color: '#666' })}>{enc.nom_reservation_archive || '—'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {detailOuvert && (
        <DetailEncaissementModal
          encaissementId={detailOuvert}
          onClose={() => setDetailOuvert(null)}
          onChanged={load}
        />
      )}
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
