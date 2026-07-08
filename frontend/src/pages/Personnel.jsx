import { useState, useEffect } from 'react';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';
const TAUX_PAR_DEFAUT = '15';

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

// Nombre d'heures (décimal) entre deux heures "HH:MM". Si l'heure de fin est
// plus petite que le début, on considère que le service passe minuit.
function heuresEntre(debut, fin) {
  if (!debut || !fin) return 0;
  const [h1, m1] = debut.split(':').map(Number);
  const [h2, m2] = fin.split(':').map(Number);
  let minutes = (h2 * 60 + m2) - (h1 * 60 + m1);
  if (minutes < 0) minutes += 24 * 60;
  return minutes / 60;
}

function montantCalcule(debut, fin, taux) {
  const heures = heuresEntre(debut, fin);
  const t = Number(taux) || 0;
  return Math.round(heures * t * 100) / 100;
}

const formVide = {
  nom: '',
  date_service: todayKey(),
  heure_debut: '12:00',
  heure_fin: '15:00',
  taux_horaire: TAUX_PAR_DEFAUT,
  montant: '',
  type_paiement: 'cash',
  remarque: '',
};

export default function Personnel() {
  const [dateUnique, setDateUnique] = useState(todayKey());
  const [services, setServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  // null = fermé, formVide = création, un objet service = édition
  const [modale, setModale] = useState(null);
  const [montantModifieManuellement, setMontantModifieManuellement] = useState(false);

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

  const load = () => {
    setLoading(true);
    api.get('/service-personnel/', { params: { date_debut: dateUnique, date_fin: dateUnique } })
      .then(res => setServices(res.data))
      .catch(() => setError('Impossible de charger les services du personnel'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [dateUnique]);

  const ouvrirCreation = () => {
    setModale({ ...formVide, date_service: dateUnique });
    setMontantModifieManuellement(false);
  };

  const ouvrirEdition = (service) => {
    setModale({
      id: service.id,
      nom: service.nom,
      date_service: service.date_service,
      heure_debut: service.heure_debut.slice(0, 5),
      heure_fin: service.heure_fin.slice(0, 5),
      taux_horaire: String(service.taux_horaire),
      montant: String(service.montant),
      type_paiement: service.type_paiement,
      remarque: service.remarque || '',
    });
    setMontantModifieManuellement(true); // on ne réécrase pas un montant déjà validé
  };

  // Recalcule le montant suggéré tant que l'utilisateur n'a pas modifié le
  // champ montant lui-même (ex: pour arrondir le total à payer).
  useEffect(() => {
    if (!modale || montantModifieManuellement) return;
    const suggestion = montantCalcule(modale.heure_debut, modale.heure_fin, modale.taux_horaire);
    setModale(prev => (prev ? { ...prev, montant: String(suggestion) } : prev));
  }, [modale?.heure_debut, modale?.heure_fin, modale?.taux_horaire, montantModifieManuellement]);

  const majModale = (champ, valeur) => {
    setModale(prev => ({ ...prev, [champ]: valeur }));
    if (champ === 'montant') setMontantModifieManuellement(true);
  };

  const enregistrerModale = async () => {
    if (!modale.nom.trim()) {
      showMsg('error', 'Le nom est requis');
      return;
    }
    const montant = Number(modale.montant);
    if (!Number.isFinite(montant) || montant <= 0) {
      showMsg('error', 'Montant invalide');
      return;
    }
    const payload = {
      nom: modale.nom.trim(),
      date_service: modale.date_service,
      heure_debut: modale.heure_debut,
      heure_fin: modale.heure_fin,
      taux_horaire: Number(modale.taux_horaire) || 0,
      montant,
      type_paiement: modale.type_paiement,
      remarque: modale.remarque || null,
    };
    try {
      if (modale.id) {
        await api.patch('/service-personnel/' + modale.id, payload);
        showMsg('success', 'Service mis à jour');
      } else {
        await api.post('/service-personnel/', payload);
        showMsg('success', 'Service enregistré');
      }
      setModale(null);
      load();
    } catch (e) {
      showMsg('error', errMsg(e, "Erreur lors de l'enregistrement"));
    }
  };

  const supprimer = async (service) => {
    if (!window.confirm('Supprimer ce service et la dépense associée ? Action irréversible.')) return;
    try {
      await api.delete('/service-personnel/' + service.id);
      showMsg('success', 'Service supprimé');
      load();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const servicesTries = [...services].sort((a, b) => a.heure_debut.localeCompare(b.heure_debut));
  const totalJour = services.reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalCash = services.filter(x => x.type_paiement === 'cash').reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalTiers = services.filter(x => x.type_paiement === 'tiers').reduce((s, x) => s + Number(x.montant || 0), 0);

  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '5px 10px', border: BORDURE, ...extra });

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

        {/* Navigation jour par jour, comme l'écran Encaissements */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
          <input
            type="date"
            value={dateUnique}
            onChange={(e) => setDateUnique(e.target.value)}
            style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
          <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
          <button
            className="btn"
            style={{ marginLeft: 'auto', background: '#111', color: 'white', fontWeight: 600 }}
            onClick={ouvrirCreation}
          >
            + Ajouter un service
          </button>
        </div>

        {/* Totaux du jour */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
            <div style={{ fontSize: 11, color: '#888' }}>Total personnel</div>
            <div style={{ fontSize: 16, fontWeight: 700 }}>{totalJour.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
            <div style={{ fontSize: 11, color: '#888' }}>dont Cash</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#16a34a' }}>{totalCash.toFixed(2)} €</div>
          </div>
          <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
            <div style={{ fontSize: 11, color: '#888' }}>dont Via tiers</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#2563eb' }}>{totalTiers.toFixed(2)} €</div>
          </div>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : servicesTries.length === 0 ? (
          <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun service ce jour</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}>Nom</th>
                  <th style={thCell({ textAlign: 'center' })}>Début</th>
                  <th style={thCell({ textAlign: 'center' })}>Fin</th>
                  <th style={thCell({ textAlign: 'right' })}>Heures</th>
                  <th style={thCell({ textAlign: 'right' })}>Taux</th>
                  <th style={thCell({ textAlign: 'right' })}>Montant</th>
                  <th style={thCell({ textAlign: 'center' })}>Paiement</th>
                  <th style={thCell()}>Remarque</th>
                  <th style={thCell()}></th>
                </tr>
              </thead>
              <tbody>
                {servicesTries.map(s => {
                  const heures = heuresEntre(s.heure_debut.slice(0, 5), s.heure_fin.slice(0, 5));
                  return (
                    <tr key={s.id} style={{ cursor: 'pointer' }} onClick={() => ouvrirEdition(s)}>
                      <td style={tdCell({ fontWeight: 600 })}>{s.nom}</td>
                      <td style={tdCell({ textAlign: 'center', color: '#666' })}>{s.heure_debut.slice(0, 5)}</td>
                      <td style={tdCell({ textAlign: 'center', color: '#666' })}>{s.heure_fin.slice(0, 5)}</td>
                      <td style={tdCell({ textAlign: 'right', color: '#666' })}>{heures.toFixed(2)} h</td>
                      <td style={tdCell({ textAlign: 'right', color: '#666' })}>{Number(s.taux_horaire).toFixed(2)} €/h</td>
                      <td style={tdCell({ textAlign: 'right', fontWeight: 700 })}>{Number(s.montant).toFixed(2)} €</td>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <span style={{
                          fontSize: 11, fontWeight: 600, padding: '2px 8px', borderRadius: 12,
                          color: s.type_paiement === 'cash' ? '#16a34a' : '#2563eb',
                          background: s.type_paiement === 'cash' ? '#dcfce7' : '#dbeafe',
                        }}>
                          {s.type_paiement === 'cash' ? 'Cash' : 'Via tiers'}
                        </span>
                      </td>
                      <td style={tdCell({ color: '#888', maxWidth: 160, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' })}>
                        {s.remarque || '—'}
                      </td>
                      <td style={tdCell({ textAlign: 'center' })}>
                        <button
                          className="btn"
                          style={{ width: 22, height: 22, padding: 0, fontSize: 11, color: '#dc2626', borderColor: '#fca5a5' }}
                          onClick={(e) => { e.stopPropagation(); supprimer(s); }}
                        >✕</button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modale d'ajout / édition */}
      {modale && (
        <div
          style={{
            position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
          }}
          onClick={() => setModale(null)}
        >
          <div
            style={{ background: 'white', borderRadius: 10, padding: 24, width: 380 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 16 }}>
              {modale.id ? 'Modifier le service' : 'Nouveau service'}
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Nom</label>
            <input
              type="text"
              autoFocus
              value={modale.nom}
              onChange={(e) => majModale('nom', e.target.value)}
              placeholder="Ex: Anton"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Date</label>
            <input
              type="date"
              value={modale.date_service}
              onChange={(e) => majModale('date_service', e.target.value)}
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Début</label>
                <input
                  type="time"
                  value={modale.heure_debut}
                  onChange={(e) => majModale('heure_debut', e.target.value)}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Fin</label>
                <input
                  type="time"
                  value={modale.heure_fin}
                  onChange={(e) => majModale('heure_fin', e.target.value)}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: 10, marginBottom: 4 }}>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Taux (€/h)</label>
                <input
                  type="number" step="0.5" min="0"
                  value={modale.taux_horaire}
                  onChange={(e) => majModale('taux_horaire', e.target.value)}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Montant (€)</label>
                <input
                  type="number" step="0.01" min="0"
                  value={modale.montant}
                  onChange={(e) => majModale('montant', e.target.value)}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
            </div>
            <div style={{ fontSize: 11, color: '#aaa', marginBottom: 14 }}>
              Calculé automatiquement ({heuresEntre(modale.heure_debut, modale.heure_fin).toFixed(2)} h) — modifiable pour arrondir.
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 6 }}>Paiement</label>
            <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
              <button
                className="btn"
                style={{
                  flex: 1, padding: '10px 0',
                  background: modale.type_paiement === 'cash' ? '#16a34a' : 'white',
                  color: modale.type_paiement === 'cash' ? 'white' : '#333',
                  borderColor: modale.type_paiement === 'cash' ? '#16a34a' : '#ddd',
                  fontWeight: 600,
                }}
                onClick={() => majModale('type_paiement', 'cash')}
              >
                💶 Cash
              </button>
              <button
                className="btn"
                style={{
                  flex: 1, padding: '10px 0',
                  background: modale.type_paiement === 'tiers' ? '#2563eb' : 'white',
                  color: modale.type_paiement === 'tiers' ? 'white' : '#333',
                  borderColor: modale.type_paiement === 'tiers' ? '#2563eb' : '#ddd',
                  fontWeight: 600,
                }}
                onClick={() => majModale('type_paiement', 'tiers')}
              >
                🏦 Via tiers
              </button>
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Remarque (optionnel)</label>
            <input
              type="text"
              value={modale.remarque}
              onChange={(e) => majModale('remarque', e.target.value)}
              placeholder="Ex: remplacement week-end"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={() => setModale(null)}>Annuler</button>
              <button
                className="btn"
                style={{ flex: 1, background: '#111', color: 'white', fontWeight: 600 }}
                onClick={enregistrerModale}
              >
                {modale.id ? 'Enregistrer' : 'Ajouter'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}