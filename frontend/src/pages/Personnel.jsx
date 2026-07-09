import { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';
const TAUX_PAR_DEFAUT = '15';

const MOIS_NOMS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function addDays(dateKey, delta) {
  const d = new Date(dateKey + 'T00:00:00');
  d.setDate(d.getDate() + delta);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function pad2(n) {
  return String(n).padStart(2, '0');
}

function joursDansMois(annee, mois) {
  return new Date(annee, mois, 0).getDate();
}

function dateKey(annee, mois, jour) {
  return annee + '-' + pad2(mois) + '-' + pad2(jour);
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
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();
  const [vue, setVue] = useState('jour'); // 'jour' | 'mois'
  const [dateUnique, setDateUnique] = useState(searchParams.get('date') || todayKey());
  const [services, setServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  // Vue mensuelle : mois/année affichés, indépendants du jour ci-dessus
  const dateRefMois = searchParams.get('date') || todayKey();
  const [anneeMois, setAnneeMois] = useState(Number(dateRefMois.split('-')[0]));
  const [moisMois, setMoisMois] = useState(Number(dateRefMois.split('-')[1]));
  const [servicesMois, setServicesMois] = useState([]);
  const [loadingMois, setLoadingMois] = useState(false);

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

  const loadMois = () => {
    setLoadingMois(true);
    const debut = dateKey(anneeMois, moisMois, 1);
    const fin = dateKey(anneeMois, moisMois, joursDansMois(anneeMois, moisMois));
    api.get('/service-personnel/', { params: { date_debut: debut, date_fin: fin } })
      .then(res => setServicesMois(res.data))
      .catch(() => showMsg('error', "Impossible de charger la vue mensuelle"))
      .finally(() => setLoadingMois(false));
  };

  useEffect(() => {
    if (vue === 'mois') loadMois();
  }, [vue, anneeMois, moisMois]);

  // Ouverture directe depuis l'écran Encaissements (lien "?date=...&service=ID") :
  // on récupère ce service précis, on se place sur son jour, et on ouvre
  // directement sa fiche en modification.
  useEffect(() => {
    const serviceId = searchParams.get('service');
    if (!serviceId) return;
    api.get('/service-personnel/' + serviceId)
      .then(res => {
        const service = res.data;
        const retourVers = searchParams.get('retour') === 'mois' ? 'mois' : 'jour';
        setDateUnique(service.date_service);
        setVue('jour');
        ouvrirEdition(service, retourVers);
        setSearchParams({}, { replace: true });
      })
      .catch(() => showMsg('error', 'Service introuvable'));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const ouvrirCreation = () => {
    setModale({ ...formVide, date_service: dateUnique });
    setMontantModifieManuellement(false);
  };

  const ouvrirEdition = (service, retourVers = null) => {
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
      // D'où vient la demande d'édition : null = ouvert normalement depuis
      // Personnel (on y reste après fermeture) ; 'jour' ou 'mois' = ouvert
      // depuis Encaissements (jour) ou Encaissements (mois) — à la fermeture,
      // on y retourne directement à la bonne date, sans avoir à la rechercher.
      retourVers,
    });
    setMontantModifieManuellement(true); // on ne réécrase pas un montant déjà validé
  };

  const urlRetour = (dateRetour, retourVers) =>
    retourVers === 'mois'
      ? '/encaissements-mois?date=' + dateRetour
      : '/encaissements?date=' + dateRetour;

  // Ferme la fiche en cours. Si elle a été ouverte depuis un écran
  // d'encaissements (bouton "⋯" ou migration temporaire "🔧"), on y retourne
  // directement à la bonne date au lieu de rester sur Personnel — évite
  // d'avoir à rechercher la date à chaque correction.
  const fermerModale = () => {
    if (modale && modale.retourVers) {
      const dateRetour = modale.date_service;
      const retourVers = modale.retourVers;
      setModale(null);
      navigate(urlRetour(dateRetour, retourVers));
    } else {
      setModale(null);
    }
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

  const rechargerVueActive = () => {
    load();
    if (vue === 'mois') loadMois();
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
      if (modale.retourVers) {
        const dateRetour = modale.date_service;
        const retourVers = modale.retourVers;
        setModale(null);
        navigate(urlRetour(dateRetour, retourVers));
      } else {
        setModale(null);
        rechargerVueActive();
      }
    } catch (e) {
      showMsg('error', errMsg(e, "Erreur lors de l'enregistrement"));
    }
  };

  const supprimer = async (service) => {
    if (!window.confirm('Supprimer ce service et la dépense associée ? Action irréversible.')) return;
    try {
      await api.delete('/service-personnel/' + service.id);
      showMsg('success', 'Service supprimé');
      rechargerVueActive();
    } catch (e) {
      showMsg('error', errMsg(e, 'Erreur lors de la suppression'));
    }
  };

  const servicesTries = [...services].sort((a, b) => a.heure_debut.localeCompare(b.heure_debut));
  const totalJour = services.reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalCash = services.filter(x => x.type_paiement === 'cash').reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalTiers = services.filter(x => x.type_paiement === 'tiers').reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalDu = services.filter(x => x.type_paiement === 'du').reduce((s, x) => s + Number(x.montant || 0), 0);

  // ───── Vue mensuelle : tri chronologique + totaux par personne ──────────
  const servicesMoisTries = [...servicesMois].sort((a, b) =>
    a.date_service === b.date_service
      ? a.heure_debut.localeCompare(b.heure_debut)
      : a.date_service.localeCompare(b.date_service)
  );
  const totalMois = servicesMois.reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalMoisCash = servicesMois.filter(x => x.type_paiement === 'cash').reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalMoisTiers = servicesMois.filter(x => x.type_paiement === 'tiers').reduce((s, x) => s + Number(x.montant || 0), 0);
  const totalMoisDu = servicesMois.filter(x => x.type_paiement === 'du').reduce((s, x) => s + Number(x.montant || 0), 0);

  const totauxParPersonne = (() => {
    const map = {};
    servicesMois.forEach(s => {
      if (!map[s.nom]) map[s.nom] = { nom: s.nom, heures: 0, montant: 0 };
      map[s.nom].heures += heuresEntre(s.heure_debut.slice(0, 5), s.heure_fin.slice(0, 5));
      map[s.nom].montant += Number(s.montant || 0);
    });
    return Object.values(map).sort((a, b) => b.montant - a.montant);
  })();

  const moisPrecedent = () => {
    let a = anneeMois, m = moisMois - 1;
    if (m < 1) { m = 12; a -= 1; }
    setAnneeMois(a);
    setMoisMois(m);
  };
  const moisSuivant = () => {
    let a = anneeMois, m = moisMois + 1;
    if (m > 12) { m = 1; a += 1; }
    setAnneeMois(a);
    setMoisMois(m);
  };

  const thCell = (extra = {}) => ({ padding: '6px 10px', border: BORDURE, ...extra });
  const tdCell = (extra = {}) => ({ padding: '5px 10px', border: BORDURE, ...extra });

  const badgePaiement = (typePaiement) => {
    const config = {
      cash: { label: 'Cash', color: '#16a34a', bg: '#dcfce7' },
      tiers: { label: 'Via tiers', color: '#2563eb', bg: '#dbeafe' },
      du: { label: 'Dû', color: '#b45309', bg: '#fef3c7' },
    }[typePaiement] || { label: typePaiement, color: '#666', bg: '#f0f0ee' };
    return (
      <span style={{
        fontSize: 11, fontWeight: 600, padding: '2px 8px', borderRadius: 12,
        color: config.color, background: config.bg,
      }}>
        {config.label}
      </span>
    );
  };

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

        {/* Bascule Vue jour / Vue mensuelle */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16, flexWrap: 'wrap' }}>
          <div style={{ display: 'flex', gap: 0, border: '1px solid #ddd', borderRadius: 8, overflow: 'hidden' }}>
            <button
              onClick={() => setVue('jour')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'jour' ? '#111' : 'white',
                color: vue === 'jour' ? 'white' : '#333',
              }}
            >
              Vue jour
            </button>
            <button
              onClick={() => setVue('mois')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'mois' ? '#111' : 'white',
                color: vue === 'mois' ? 'white' : '#333',
              }}
            >
              Vue mensuelle
            </button>
          </div>

          {vue === 'jour' ? (
            <>
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, -1))}>−</button>
              <input
                type="date"
                value={dateUnique}
                onChange={(e) => setDateUnique(e.target.value)}
                style={{ padding: '4px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <button className="btn" onClick={() => setDateUnique(d => addDays(d, 1))}>+</button>
              <button className="btn" onClick={() => setDateUnique(todayKey())} style={{ color: '#888' }}>Aujourd'hui</button>
            </>
          ) : (
            <>
              <button className="btn" onClick={moisPrecedent}>−</button>
              <span style={{ fontSize: 16, fontWeight: 700, textTransform: 'capitalize' }}>
                {MOIS_NOMS[moisMois - 1]} {anneeMois}
              </span>
              <button className="btn" onClick={moisSuivant}>+</button>
            </>
          )}

          <button
            className="btn"
            style={{ marginLeft: 'auto', background: '#111', color: 'white', fontWeight: 600 }}
            onClick={ouvrirCreation}
          >
            + Ajouter un service
          </button>
        </div>

        {vue === 'jour' ? (
          <>
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
              <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>dont Dû</div>
                <div style={{ fontSize: 16, fontWeight: 700, color: '#b45309' }}>{totalDu.toFixed(2)} €</div>
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
                          <td style={tdCell({ textAlign: 'center' })}>{badgePaiement(s.type_paiement)}</td>
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
          </>
        ) : (
          <>
            {/* Totaux du mois */}
            <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
              <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>Total du mois</div>
                <div style={{ fontSize: 16, fontWeight: 700 }}>{totalMois.toFixed(2)} €</div>
              </div>
              <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>dont Cash</div>
                <div style={{ fontSize: 16, fontWeight: 700, color: '#16a34a' }}>{totalMoisCash.toFixed(2)} €</div>
              </div>
              <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>dont Via tiers</div>
                <div style={{ fontSize: 16, fontWeight: 700, color: '#2563eb' }}>{totalMoisTiers.toFixed(2)} €</div>
              </div>
              <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
                <div style={{ fontSize: 11, color: '#888' }}>dont Dû</div>
                <div style={{ fontSize: 16, fontWeight: 700, color: '#b45309' }}>{totalMoisDu.toFixed(2)} €</div>
              </div>
            </div>

            {loadingMois ? (
              <div style={{ color: '#888' }}>Chargement...</div>
            ) : (
              <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start', flexWrap: 'wrap' }}>
                {/* Détail chronologique du mois */}
                <div style={{ flex: '2 1 500px', background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
                  {servicesMoisTries.length === 0 ? (
                    <div style={{ color: '#888', textAlign: 'center', padding: '40px 0' }}>Aucun service ce mois</div>
                  ) : (
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                      <thead>
                        <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                          <th style={thCell()}>Date</th>
                          <th style={thCell()}>Nom</th>
                          <th style={thCell({ textAlign: 'right' })}>Heures</th>
                          <th style={thCell({ textAlign: 'right' })}>Montant</th>
                          <th style={thCell({ textAlign: 'center' })}>Paiement</th>
                          <th style={thCell()}></th>
                        </tr>
                      </thead>
                      <tbody>
                        {servicesMoisTries.map(s => {
                          const heures = heuresEntre(s.heure_debut.slice(0, 5), s.heure_fin.slice(0, 5));
                          const d = new Date(s.date_service + 'T00:00:00');
                          return (
                            <tr key={s.id} style={{ cursor: 'pointer' }} onClick={() => ouvrirEdition(s)}>
                              <td style={tdCell({ color: '#666', whiteSpace: 'nowrap' })}>
                                {pad2(d.getDate())}/{pad2(d.getMonth() + 1)}
                              </td>
                              <td style={tdCell({ fontWeight: 600 })}>{s.nom}</td>
                              <td style={tdCell({ textAlign: 'right', color: '#666' })}>{heures.toFixed(2)} h</td>
                              <td style={tdCell({ textAlign: 'right', fontWeight: 700 })}>{Number(s.montant).toFixed(2)} €</td>
                              <td style={tdCell({ textAlign: 'center' })}>{badgePaiement(s.type_paiement)}</td>
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
                      <tfoot>
                        <tr style={{ fontWeight: 700, background: '#fafaf8' }}>
                          <td style={tdCell()} colSpan={3}>Total {MOIS_NOMS[moisMois - 1]}</td>
                          <td style={tdCell({ textAlign: 'right' })}>{totalMois.toFixed(2)} €</td>
                          <td style={tdCell()} colSpan={2}></td>
                        </tr>
                      </tfoot>
                    </table>
                  )}
                </div>

                {/* Totaux par personne */}
                <div style={{ flex: '1 1 260px', background: 'white', border: BORDURE, borderRadius: 10, overflow: 'hidden' }}>
                  <div style={{ padding: '10px 14px', fontSize: 12, fontWeight: 600, color: '#888', textTransform: 'uppercase', letterSpacing: 0.4, borderBottom: BORDURE }}>
                    Totaux par personne
                  </div>
                  {totauxParPersonne.length === 0 ? (
                    <div style={{ color: '#888', padding: 14, fontSize: 13 }}>—</div>
                  ) : (
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
                      <tbody>
                        {totauxParPersonne.map(p => (
                          <tr key={p.nom}>
                            <td style={tdCell({ fontWeight: 600 })}>{p.nom}</td>
                            <td style={tdCell({ textAlign: 'right', color: '#666' })}>{p.heures.toFixed(2)} h</td>
                            <td style={tdCell({ textAlign: 'right', fontWeight: 700 })}>{p.montant.toFixed(2)} €</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  )}
                </div>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modale d'ajout / édition */}
      {modale && (
        <div
          style={{
            position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
          }}
          onClick={fermerModale}
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
            <div style={{ display: 'flex', gap: 8, marginBottom: 14 }}>
              <button
                className="btn"
                style={{
                  flex: 1, padding: '10px 0',
                  background: modale.type_paiement === 'cash' ? '#16a34a' : 'white',
                  color: modale.type_paiement === 'cash' ? 'white' : '#333',
                  borderColor: modale.type_paiement === 'cash' ? '#16a34a' : '#ddd',
                  fontWeight: 600, fontSize: 13,
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
                  fontWeight: 600, fontSize: 13,
                }}
                onClick={() => majModale('type_paiement', 'tiers')}
              >
                🏦 Tiers
              </button>
              <button
                className="btn"
                style={{
                  flex: 1, padding: '10px 0',
                  background: modale.type_paiement === 'du' ? '#b45309' : 'white',
                  color: modale.type_paiement === 'du' ? 'white' : '#333',
                  borderColor: modale.type_paiement === 'du' ? '#b45309' : '#ddd',
                  fontWeight: 600, fontSize: 13,
                }}
                onClick={() => majModale('type_paiement', 'du')}
              >
                🕒 Dû
              </button>
            </div>
            {modale.type_paiement === 'du' && (
              <div style={{ fontSize: 11, color: '#b45309', marginBottom: 14, marginTop: -8 }}>
                Ce service reste enregistré, mais n'apparaîtra pas comme dépense en caisse tant qu'il n'est pas repassé en Cash ou Tiers.
              </div>
            )}

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Remarque (optionnel)</label>
            <input
              type="text"
              value={modale.remarque}
              onChange={(e) => majModale('remarque', e.target.value)}
              placeholder="Ex: remplacement week-end"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 20, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={fermerModale}>Annuler</button>
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