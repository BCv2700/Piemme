import { useState, useEffect } from 'react';
import api from '../api/api';

const BORDURE = '1px solid #e5e5e0';

const CLIENT_VIDE = {
  nom: '',
  telephone_mobile: '',
  telephone_fixe: '',
  email: '',
  adresse: '',
  cp: '',
  localite: '',
  date_anniversaire: '',
  derniere_visite: '',
  a_recontacter: false,
  remarques: '',
  actif: true,
};

export default function Clients() {
  const [clients, setClients] = useState([]);
  const [recherche, setRecherche] = useState('');
  const [filtreActifUniquement, setFiltreActifUniquement] = useState(false);
  const [edition, setEdition] = useState(null);
  const [historique, setHistorique] = useState([]);
  const [historiqueChargement, setHistoriqueChargement] = useState(false);
  const [filtreAnnee, setFiltreAnnee] = useState(null);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [loading, setLoading] = useState(true);

  const load = () => {
    setLoading(true);
    api.get('/clients/')
      .then(r => setClients(r.data))
      .catch(() => setError('Impossible de charger les clients'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, []);

  const afficherMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const clientsAffiches = clients.filter(c =>
    (c.nom.toLowerCase().includes(recherche.toLowerCase()) ||
      (c.telephone_mobile || '').includes(recherche) ||
      (c.telephone_fixe || '').includes(recherche)) &&
    (!filtreActifUniquement || c.actif)
  );

  const ouvrirCreation = () => setEdition({ ...CLIENT_VIDE });

  const ouvrirEdition = async (client) => {
    setEdition({ ...client });
    setHistorique([]);
    setFiltreAnnee(null);
    setHistoriqueChargement(true);
    try {
      const res = await api.get('/encaissements/', { params: { client_id: client.id } });
      setHistorique(res.data);
    } catch (e) {
      // Silencieux : l'historique est secondaire, ne bloque pas l'édition de la fiche
    } finally {
      setHistoriqueChargement(false);
    }
  };

  const fermerFormulaire = () => { setEdition(null); setHistorique([]); setFiltreAnnee(null); };

  const majChamp = (champ, valeur) => setEdition(prev => ({ ...prev, [champ]: valeur }));

  const enregistrer = async () => {
    if (!edition.nom.trim()) {
      afficherMsg('error', 'Le nom est requis');
      return;
    }
    setError('');
    const payload = {
      ...edition,
      date_anniversaire: edition.date_anniversaire || null,
      derniere_visite: edition.derniere_visite || null,
    };
    try {
      if (edition.id) {
        const res = await api.patch('/clients/' + edition.id, payload);
        setClients(prev => prev.map(c => c.id === edition.id ? res.data : c));
        afficherMsg('success', 'Client mis à jour');
      } else {
        const res = await api.post('/clients/', payload);
        setClients(prev => [...prev, res.data]);
        afficherMsg('success', 'Client créé');
      }
      setEdition(null);
      setHistorique([]);
    } catch (e) {
      setError(e.response?.data?.detail || "Erreur lors de l'enregistrement");
    }
  };

  const supprimer = async (client) => {
    if (!window.confirm('Supprimer définitivement « ' + client.nom + ' » ?')) return;
    setError('');
    try {
      await api.delete('/clients/' + client.id);
      setClients(prev => prev.filter(c => c.id !== client.id));
      setEdition(null);
      afficherMsg('success', 'Client supprimé');
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors de la suppression');
    }
  };

  const thCell = (extra = {}) => ({ padding: '6px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });
  const tdCell = (extra = {}) => ({ padding: '4px 14px', border: BORDURE, whiteSpace: 'nowrap', ...extra });

  const inputStyle = {
    width: '100%', padding: '7px 10px', borderRadius: 6, border: '1px solid #ddd',
    fontSize: 14, boxSizing: 'border-box',
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

        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
          <span style={{ fontSize: 13, color: '#888', fontWeight: 600, whiteSpace: 'nowrap' }}>
            {clients.length} client{clients.length !== 1 ? 's' : ''}
          </span>
          <button className="btn" onClick={ouvrirCreation}>+ Nouveau client</button>
          <input
            type="text"
            placeholder="Rechercher par nom ou téléphone..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
            style={{ flex: 1, minWidth: 200, padding: '10px 14px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14 }}
          />
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, cursor: 'pointer', padding: '0 4px' }}>
            <input
              type="checkbox"
              checked={filtreActifUniquement}
              onChange={(e) => setFiltreActifUniquement(e.target.checked)}
              style={{ width: 16, height: 16 }}
            />
            Actifs uniquement
          </label>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <div style={{ background: 'white', border: BORDURE, borderRadius: 10, overflow: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
              <thead>
                <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                  <th style={thCell()}>Nom</th>
                  <th style={thCell()}>Mobile</th>
                  <th style={thCell()}>Fixe</th>
                  <th style={thCell()}>Email</th>
                  <th style={thCell()}>Localité</th>
                  <th style={thCell()}>À recontacter</th>
                  <th style={thCell()}>Dernière visite</th>
                  <th style={thCell()}>Actif</th>
                </tr>
              </thead>
              <tbody>
                {clientsAffiches.map((client, index) => {
                  const fondAlterne = index % 2 === 1 ? '#f0f0ec' : 'transparent';
                  return (
                    <tr key={client.id} onClick={() => ouvrirEdition(client)} style={{ cursor: 'pointer', background: fondAlterne }}>
                      <td style={tdCell({ fontWeight: 500 })}>{client.nom}</td>
                      <td style={tdCell({ color: '#666' })}>{client.telephone_mobile || '—'}</td>
                      <td style={tdCell({ color: '#666' })}>{client.telephone_fixe || '—'}</td>
                      <td style={tdCell({ color: '#666' })}>{client.email || '—'}</td>
                      <td style={tdCell({ color: '#666' })}>{client.localite || '—'}</td>
                      <td style={tdCell()}>{client.a_recontacter ? '✓' : ''}</td>
                      <td style={tdCell({ color: '#666' })}>{client.derniere_visite || '—'}</td>
                      <td style={tdCell()}>
                        <span style={{
                          display: 'inline-block', width: 10, height: 10, borderRadius: '50%',
                          background: client.actif ? '#22c55e' : '#9ca3af',
                        }} />
                      </td>
                    </tr>
                  );
                })}
                {clientsAffiches.length === 0 && (
                  <tr>
                    <td colSpan={8} style={{ padding: 20, textAlign: 'center', color: '#888', border: BORDURE }}>
                      Aucun client ne correspond à la recherche
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {edition && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
          padding: 20,
        }}>
          <div style={{
            background: 'white', borderRadius: 10, width: 900, maxWidth: '95vw', maxHeight: '90vh',
            display: 'flex', flexDirection: 'column', overflow: 'hidden',
          }}>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 16,
              padding: '14px 22px', borderBottom: '1px solid #e5e5e0', flexShrink: 0,
            }}>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" onClick={enregistrer}>{edition.id ? 'Enregistrer' : 'Créer'}</button>
                {edition.id && (
                  <button className="btn" style={{ color: '#dc2626', borderColor: '#fca5a5' }} onClick={() => supprimer(edition)}>
                    Supprimer
                  </button>
                )}
                <button className="btn" onClick={fermerFormulaire}>Annuler</button>
              </div>
              <div style={{ fontWeight: 600, fontSize: 16 }}>
                {edition.id ? 'Modifier le client' : 'Nouveau client'}
              </div>
            </div>

            <div style={{ padding: 20, overflowY: 'auto', display: 'flex', gap: 24 }}>

              {/* Colonne gauche : fiche client */}
              <div style={{ flex: 1, minWidth: 320, display: 'flex', flexDirection: 'column', gap: 10 }}>
                <Champ label="Nom">
                  <input style={inputStyle} value={edition.nom} onChange={e => majChamp('nom', e.target.value)} />
                </Champ>

                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Téléphone mobile" style={{ flex: 1 }}>
                    <input style={inputStyle} value={edition.telephone_mobile || ''} onChange={e => majChamp('telephone_mobile', e.target.value)} />
                  </Champ>
                  <Champ label="Téléphone fixe" style={{ flex: 1 }}>
                    <input style={inputStyle} value={edition.telephone_fixe || ''} onChange={e => majChamp('telephone_fixe', e.target.value)} />
                  </Champ>
                </div>

                <Champ label="Email">
                  <input type="email" style={inputStyle} value={edition.email || ''} onChange={e => majChamp('email', e.target.value)} />
                </Champ>

                <Champ label="Adresse">
                  <input style={inputStyle} value={edition.adresse || ''} onChange={e => majChamp('adresse', e.target.value)} />
                </Champ>

                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Code postal" style={{ width: 110 }}>
                    <input style={inputStyle} value={edition.cp || ''} onChange={e => majChamp('cp', e.target.value)} />
                  </Champ>
                  <Champ label="Localité" style={{ flex: 1 }}>
                    <input style={inputStyle} value={edition.localite || ''} onChange={e => majChamp('localite', e.target.value)} />
                  </Champ>
                </div>

                <div style={{ display: 'flex', gap: 10 }}>
                  <Champ label="Date d'anniversaire" style={{ flex: 1 }}>
                    <input type="date" style={inputStyle} value={edition.date_anniversaire || ''} onChange={e => majChamp('date_anniversaire', e.target.value)} />
                  </Champ>
                  <Champ label="Dernière visite" style={{ flex: 1 }}>
                    <input type="date" style={inputStyle} value={edition.derniere_visite || ''} onChange={e => majChamp('derniere_visite', e.target.value)} />
                  </Champ>
                </div>

                <Champ label="Remarques">
                  <textarea
                    style={{ ...inputStyle, minHeight: 70, resize: 'vertical', fontFamily: 'inherit' }}
                    value={edition.remarques || ''}
                    onChange={e => majChamp('remarques', e.target.value)}
                  />
                </Champ>

                <div style={{ display: 'flex', gap: 8, marginTop: 4 }}>
                  <label style={{
                    display: 'flex', alignItems: 'center', gap: 6, fontSize: 13,
                    padding: '6px 12px', borderRadius: 20, border: '1px solid #ddd', cursor: 'pointer',
                    background: edition.actif ? '#dcfce7' : 'white',
                    borderColor: edition.actif ? '#86efac' : '#ddd',
                  }}>
                    <input type="checkbox" checked={edition.actif} onChange={e => majChamp('actif', e.target.checked)} style={{ width: 14, height: 14 }} />
                    Actif
                  </label>
                  <label style={{
                    display: 'flex', alignItems: 'center', gap: 6, fontSize: 13,
                    padding: '6px 12px', borderRadius: 20, border: '1px solid #ddd', cursor: 'pointer',
                    background: edition.a_recontacter ? '#fef3c7' : 'white',
                    borderColor: edition.a_recontacter ? '#fcd34d' : '#ddd',
                  }}>
                    <input type="checkbox" checked={edition.a_recontacter || false} onChange={e => majChamp('a_recontacter', e.target.checked)} style={{ width: 14, height: 14 }} />
                    À recontacter
                  </label>
                </div>
              </div>

              {/* Colonne droite : historique des encaissements (uniquement en édition) */}
              {edition.id && (
                <div style={{ flex: 1, minWidth: 320, display: 'flex', flexDirection: 'column' }}>
                  <div style={{ fontSize: 12, color: '#888', fontWeight: 600, marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.4 }}>
                    Historique des encaissements
                  </div>

                  {/* Totaux des 3 dernières années, cliquables pour filtrer la liste en dessous */}
                  {!historiqueChargement && historique.length > 0 && (() => {
                    const anneeActuelle = new Date().getFullYear();
                    const annees = [anneeActuelle, anneeActuelle - 1, anneeActuelle - 2];
                    return (
                      <div style={{ display: 'flex', gap: 8, marginBottom: 10 }}>
                        {annees.map(annee => {
                          const totalAnnee = historique
                            .filter(enc => new Date(enc.date_encaissement).getFullYear() === annee)
                            .reduce((s, enc) => s + Number(enc.montant_total), 0);
                          const actif = filtreAnnee === annee;
                          return (
                            <button
                              key={annee}
                              onClick={() => setFiltreAnnee(actif ? null : annee)}
                              style={{
                                flex: 1, padding: '6px 10px', borderRadius: 8, cursor: 'pointer',
                                border: '1px solid ' + (actif ? '#111' : '#ddd'),
                                background: actif ? '#111' : 'white',
                                color: actif ? 'white' : '#333',
                                fontSize: 12, textAlign: 'left',
                              }}
                            >
                              <div style={{ fontWeight: 600 }}>{annee}</div>
                              <div style={{ fontWeight: 700 }}>{totalAnnee.toFixed(2)} €</div>
                            </button>
                          );
                        })}
                      </div>
                    );
                  })()}

                  <div style={{ border: BORDURE, borderRadius: 8, overflow: 'hidden', flex: 1 }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
                      <thead>
                        <tr style={{ background: '#fafaf8', textAlign: 'left' }}>
                          <th style={thCell()}>Date</th>
                          <th style={thCell()}>Table</th>
                          <th style={thCell({ textAlign: 'right' })}>Total</th>
                        </tr>
                      </thead>
                      <tbody>
                        {historiqueChargement && (
                          <tr><td colSpan={3} style={{ padding: 12, textAlign: 'center', color: '#888' }}>Chargement...</td></tr>
                        )}
                        {!historiqueChargement && historique.length === 0 && (
                          <tr><td colSpan={3} style={{ padding: 12, textAlign: 'center', color: '#888' }}>Aucun encaissement</td></tr>
                        )}
                        {!historiqueChargement && historique
                          .filter(enc => !filtreAnnee || new Date(enc.date_encaissement).getFullYear() === filtreAnnee)
                          .map(enc => (
                            <tr key={enc.id}>
                              <td style={tdCell()}>{new Date(enc.date_encaissement).toLocaleDateString('fr-BE')}</td>
                              <td style={tdCell()}>{enc.table_nom || '—'}</td>
                              <td style={tdCell({ textAlign: 'right' })}>{Number(enc.montant_total).toFixed(2)} €</td>
                            </tr>
                          ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function Champ({ label, children, style }) {
  return (
    <div style={style}>
      <div style={{ fontSize: 12, color: '#888', marginBottom: 4 }}>{label}</div>
      {children}
    </div>
  );
}