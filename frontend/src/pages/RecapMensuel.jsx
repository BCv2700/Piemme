import { useState, useEffect, useMemo } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api/api';

// Ordre d'affichage des taux de TVA : 6, 12, 21 (comme le PDF Access)
const TAUX_TVA = [6, 12, 21];

const MOIS_NOMS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

// Jours d'ouverture (repère visuel rouge) : 4 = jeudi, 5 = vendredi, 6 = samedi
// (getDay() : 0 = dimanche, 1 = lundi, ... 6 = samedi)
const JOURS_OUVERTURE = [4, 5, 6];

function todayKey() {
  const d = new Date();
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

export default function RecapMensuel() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [vue, setVue] = useState('analyse'); // 'analyse' (par défaut, en premier) ou 'tous'
  const dateRef = searchParams.get('date') || todayKey();
  const [anneeStr, moisStr] = dateRef.split('-');
  const annee = Number(anneeStr);
  const mois = Number(moisStr); // 1..12

  const [encaissements, setEncaissements] = useState([]);
  const [recap, setRecap] = useState(null); // { memo, km_defaut, km_par_jour }
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);

  const showMsg = (type, text) => {
    setMsg({ type, text });
    setTimeout(() => setMsg(null), 3000);
  };

  const load = () => {
    setLoading(true);
    setError('');
    const nbJours = joursDansMois(annee, mois);
    const dateDebut = dateKey(annee, mois, 1);
    const dateFin = dateKey(annee, mois, nbJours);
    Promise.all([
      api.get('/encaissements/', { params: { date_debut: dateDebut, date_fin: dateFin } }),
      api.get('/recap-mensuel/' + annee + '/' + mois),
    ])
      .then(([encRes, recapRes]) => {
        setEncaissements(encRes.data);
        setRecap(recapRes.data);
      })
      .catch(() => setError('Impossible de charger le récap mensuel'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); }, [annee, mois]);

  // Recettes = encaissements qui ne sont pas des dépenses
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Regroupement par jour (1..nbJours)
  const parJour = useMemo(() => {
    const map = {};
    const nbJours = joursDansMois(annee, mois);
    for (let j = 1; j <= nbJours; j++) {
      map[j] = {
        total: 0, cash: 0, carte: 0, cashAnalyse: 0, depenses: 0,
        tva: { 6: 0, 12: 0, 21: 0, autre: 0 },          // toutes les lignes (vue Tous)
        totalAnalyse: 0,
        tvaAnalyse: { 6: 0, 12: 0, 21: 0, autre: 0 },    // lignes analysées (vue Analysé)
      };
    }
    encaissements.forEach(enc => {
      const d = new Date(enc.date_encaissement);
      if (d.getFullYear() !== annee || (d.getMonth() + 1) !== mois) return;
      const j = d.getDate();
      if (!map[j]) return;

      if (enc.depenses) {
        // Dépense : on cumule le montant total (déjà négatif) dans la colonne dépenses
        map[j].depenses += Number(enc.montant_total || 0);
        return; // une dépense ne compte pas dans les recettes / TVA
      }

      // Recette
      map[j].total += Number(enc.montant_total || 0);
      map[j].cash += Number(enc.montant_cash || 0);
      map[j].carte += Number(enc.montant_carte || 0);
      map[j].cashAnalyse += Number(enc.cash_analyse || 0);
      (enc.lignes || []).forEach(ligne => {
        const montant = Number(ligne.prix_vente) * Number(ligne.quantite);
        const taux = Math.round(Number(ligne.tva));
        if (map[j].tva[taux] !== undefined) map[j].tva[taux] += montant;
        else map[j].tva.autre += montant;
        if (ligne.vente_analysee) {
          map[j].totalAnalyse += montant;
          if (map[j].tvaAnalyse[taux] !== undefined) map[j].tvaAnalyse[taux] += montant;
          else map[j].tvaAnalyse.autre += montant;
        }
      });
    });
    return map;
  }, [encaissements, annee, mois]);

  // Totaux du mois
  const totaux = useMemo(() => {
    const t = {
      total: 0, cash: 0, carte: 0, cashAnalyse: 0, depenses: 0,
      tva: { 6: 0, 12: 0, 21: 0, autre: 0 },
      totalAnalyse: 0,
      tvaAnalyse: { 6: 0, 12: 0, 21: 0, autre: 0 },
    };
    Object.values(parJour).forEach(j => {
      t.total += j.total;
      t.cash += j.cash;
      t.carte += j.carte;
      t.cashAnalyse += j.cashAnalyse;
      t.depenses += j.depenses;
      t.totalAnalyse += j.totalAnalyse;
      [6, 12, 21, 'autre'].forEach(k => {
        t.tva[k] += j.tva[k];
        t.tvaAnalyse[k] += j.tvaAnalyse[k];
      });
    });
    return t;
  }, [parJour]);

  const tvaActive = vue === 'analyse' ? totaux.tvaAnalyse : totaux.tva;
  const baseTva = tvaActive[6] + tvaActive[12] + tvaActive[21];
  const pourcentage = (montant) => (baseTva > 0 ? (montant / baseTva) * 100 : 0);

  // TVA à payer par taux : base × taux / (100 + taux)
  const tvaApayer = (base, taux) => base * taux / (100 + taux);

  // ───── km (par défaut + exceptions par jour) ─────────────────────────────
  const kmDefaut = recap ? Number(recap.km_defaut) : 53.4;
  const kmDuJour = (jour) => {
    if (recap && recap.km_par_jour && recap.km_par_jour[String(jour)] !== undefined) {
      return Number(recap.km_par_jour[String(jour)]);
    }
    return kmDefaut;
  };
  const totalKm = useMemo(() => {
    const nbJours = joursDansMois(annee, mois);
    let s = 0;
    for (let j = 1; j <= nbJours; j++) s += kmDuJour(j);
    return s;
  }, [recap, annee, mois]);

  const changerKm = async (jour, valeurStr) => {
    const valeur = Number(String(valeurStr).replace(',', '.'));
    if (!Number.isFinite(valeur) || valeur < 0) return;
    const nouvelles = { ...(recap?.km_par_jour || {}) };
    nouvelles[String(jour)] = valeur;
    setRecap(prev => ({ ...prev, km_par_jour: nouvelles }));
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { km_par_jour: nouvelles });
      setRecap(res.data);
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement des km');
      load();
    }
  };

  // ───── mémo ──────────────────────────────────────────────────────────────
  const [memoLocal, setMemoLocal] = useState('');
  useEffect(() => { setMemoLocal(recap ? (recap.memo || '') : ''); }, [recap?.memo]);

  const sauverMemo = async () => {
    if (!recap) return;
    if (memoLocal === (recap.memo || '')) return;
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { memo: memoLocal });
      setRecap(res.data);
      showMsg('success', 'Mémo enregistré');
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement du mémo');
    }
  };

  const nbJours = joursDansMois(annee, mois);
  const jours = Array.from({ length: nbJours }, (_, i) => i + 1);

  const nomJourSemaine = (jour) => {
    const d = new Date(annee, mois - 1, jour);
    return d.toLocaleDateString('fr-BE', { weekday: 'long' });
  };
  const estJourOuverture = (jour) => {
    const d = new Date(annee, mois - 1, jour);
    return JOURS_OUVERTURE.includes(d.getDay());
  };

  const fmt = (n) => Number(n).toFixed(2);

  const ouvrirJour = (jour) => {
    navigate('/encaissements?date=' + dateKey(annee, mois, jour));
  };

  // Styles tableau
  const thStyle = { padding: '8px 10px', borderBottom: '2px solid #e5e5e0', whiteSpace: 'nowrap' };
  const tdStyle = { padding: '4px 10px', borderBottom: '1px solid #f0f0ee' };

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16, flexWrap: 'wrap' }}>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0, textTransform: 'capitalize' }}>
            {MOIS_NOMS[mois - 1]} {annee}
          </h2>
          <div style={{ display: 'flex', border: '1px solid #ddd', borderRadius: 8, overflow: 'hidden' }}>
            <button
              onClick={() => setVue('analyse')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'analyse' ? '#111' : 'white',
                color: vue === 'analyse' ? 'white' : '#333',
              }}
            >
              Analysé
            </button>
            <button
              onClick={() => setVue('tous')}
              style={{
                padding: '6px 16px', fontSize: 13, fontWeight: 600, border: 'none', cursor: 'pointer',
                background: vue === 'tous' ? '#111' : 'white',
                color: vue === 'tous' ? 'white' : '#333',
              }}
            >
              Tous
            </button>
          </div>
          <span style={{ fontSize: 13, color: '#888' }}>
            {vue === 'analyse' ? 'Ventes analysées' : 'Tous les encaissements'}
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <>
            {/* Bandeau de totaux */}
            <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
              {vue === 'analyse' ? (
                <>
                  <CarteTotal label="Total analysé" valeur={fmt(totaux.totalAnalyse)} fort />
                  <CarteTotal label="Cash analysé" valeur={fmt(totaux.cashAnalyse)} couleur="#b45309" />
                  <CarteTotal label="Carte" valeur={fmt(totaux.carte)} couleur="#2563eb" />
                  {TAUX_TVA.map(taux => (
                    <CarteTotal key={taux}
                      label={'TVA ' + taux + '% (' + pourcentage(totaux.tvaAnalyse[taux]).toFixed(2) + '%)'}
                      valeur={fmt(totaux.tvaAnalyse[taux])} />
                  ))}
                </>
              ) : (
                <>
                  <CarteTotal label="Total" valeur={fmt(totaux.total)} fort />
                  <CarteTotal label="Cash" valeur={fmt(totaux.cash)} couleur="#16a34a" />
                  <CarteTotal label="Carte" valeur={fmt(totaux.carte)} couleur="#2563eb" />
                  <CarteTotal label="Cash analysé" valeur={fmt(totaux.cashAnalyse)} couleur="#b45309" />
                  <CarteTotal label="Dépenses" valeur={fmt(totaux.depenses)} couleur="#dc2626" />
                  {TAUX_TVA.map(taux => (
                    <CarteTotal key={taux}
                      label={'TVA ' + taux + '% (' + pourcentage(totaux.tva[taux]).toFixed(2) + '%)'}
                      valeur={fmt(totaux.tva[taux])} />
                  ))}
                </>
              )}
              <CarteTotal label="Km A/R" valeur={fmt(totalKm)} couleur="#6b7280" />
            </div>

            {/* Tableau */}
            <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'auto', marginBottom: 20 }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, minWidth: 900 }}>
                <thead>
                  <tr style={{ background: '#fafaf8', textAlign: 'right' }}>
                    <th style={{ ...thStyle, textAlign: 'center' }}>Fermé</th>
                    <th style={{ ...thStyle, textAlign: 'left' }}>Jour</th>
                    <th style={thStyle}>{vue === 'analyse' ? 'Total analysé' : 'Total'}</th>
                    {vue === 'tous' && <th style={thStyle}>Cash</th>}
                    <th style={thStyle}>Cash analysé</th>
                    <th style={thStyle}>Carte</th>
                    {vue === 'tous' && <th style={thStyle}>Dépenses</th>}
                    <th style={thStyle}>TVA 6%</th>
                    <th style={thStyle}>TVA 12%</th>
                    <th style={thStyle}>TVA 21%</th>
                    <th style={thStyle}>Ctl</th>
                    <th style={thStyle}>Km A/R</th>
                  </tr>
                </thead>
                <tbody>
                  {jours.map(j => {
                    const d = parJour[j];
                    const tvaJour = vue === 'analyse' ? d.tvaAnalyse : d.tva;
                    const totalJour = vue === 'analyse' ? d.totalAnalyse : d.total;
                    const ctl = tvaJour[6] + tvaJour[12] + tvaJour[21];
                    const ecart = ctl - totalJour;
                    const ecartImportant = Math.abs(ecart) >= 0.01;
                    const ouverture = estJourOuverture(j);
                    const actif = totalJour !== 0 || d.cashAnalyse !== 0 || d.carte !== 0 || d.depenses !== 0;
                    return (
                      <tr key={j} style={{ textAlign: 'right' }}>
                        <td style={{ ...tdStyle, textAlign: 'center' }}>
                          <input type="checkbox" disabled title="Mémorisation à venir" style={{ width: 14, height: 14, opacity: 0.4 }} />
                        </td>
                        <td
                          style={{ ...tdStyle, textAlign: 'left', whiteSpace: 'nowrap', cursor: 'pointer', textDecoration: 'underline dotted',
                                   color: ouverture ? '#dc2626' : (actif ? '#111' : '#aaa'),
                                   fontWeight: ouverture ? 700 : 400 }}
                          title="Ouvrir les encaissements de ce jour"
                          onClick={() => ouvrirJour(j)}
                        >
                          {pad2(j)} <span style={{ textTransform: 'capitalize' }}>{nomJourSemaine(j)}</span>
                        </td>
                        <td style={{ ...tdStyle, fontWeight: actif ? 700 : 400, color: actif ? '#111' : '#ccc' }}>{fmt(totalJour)}</td>
                        {vue === 'tous' && <td style={{ ...tdStyle, color: actif ? '#16a34a' : '#ccc' }}>{fmt(d.cash)}</td>}
                        <td style={{ ...tdStyle, color: actif ? '#b45309' : '#ccc' }}>{fmt(d.cashAnalyse)}</td>
                        <td style={{ ...tdStyle, color: actif ? '#2563eb' : '#ccc' }}>{fmt(d.carte)}</td>
                        {vue === 'tous' && <td style={{ ...tdStyle, color: d.depenses !== 0 ? '#dc2626' : '#ccc' }}>{fmt(d.depenses)}</td>}
                        <td style={{ ...tdStyle, color: '#666' }}>{fmt(tvaJour[6])}</td>
                        <td style={{ ...tdStyle, color: '#666' }}>{fmt(tvaJour[12])}</td>
                        <td style={{ ...tdStyle, color: '#666' }}>{fmt(tvaJour[21])}</td>
                        <td style={{ ...tdStyle, fontWeight: 600, color: !actif ? '#ccc' : (ecartImportant ? '#dc2626' : '#16a34a') }}>
                          {fmt(ctl)}
                        </td>
                        <td style={{ padding: '2px 6px', borderBottom: '1px solid #f0f0ee' }}>
                          <input
                            type="number" step="0.1" min="0"
                            defaultValue={fmt(kmDuJour(j))}
                            onBlur={(e) => changerKm(j, e.target.value)}
                            style={{ width: 60, padding: '2px 6px', borderRadius: 5, border: '1px solid #ddd', fontSize: 12, textAlign: 'right' }}
                          />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
                <tfoot>
                  <tr style={{ textAlign: 'right', fontWeight: 700, background: '#fafaf8', borderTop: '2px solid #e5e5e0' }}>
                    <td style={{ padding: '8px 10px' }}></td>
                    <td style={{ padding: '8px 10px', textAlign: 'left' }}>Totaux {MOIS_NOMS[mois - 1]}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(vue === 'analyse' ? totaux.totalAnalyse : totaux.total)}</td>
                    {vue === 'tous' && <td style={{ padding: '8px 10px', color: '#16a34a' }}>{fmt(totaux.cash)}</td>}
                    <td style={{ padding: '8px 10px', color: '#b45309' }}>{fmt(totaux.cashAnalyse)}</td>
                    <td style={{ padding: '8px 10px', color: '#2563eb' }}>{fmt(totaux.carte)}</td>
                    {vue === 'tous' && <td style={{ padding: '8px 10px', color: '#dc2626' }}>{fmt(totaux.depenses)}</td>}
                    <td style={{ padding: '8px 10px' }}>{fmt(tvaActive[6])}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(tvaActive[12])}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(tvaActive[21])}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(tvaActive[6] + tvaActive[12] + tvaActive[21])}</td>
                    <td style={{ padding: '8px 10px', color: '#6b7280' }}>{fmt(totalKm)}</td>
                  </tr>
                  <tr style={{ textAlign: 'right', background: '#fafaf8' }}>
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px', textAlign: 'left', color: '#888' }}>TVA à payer</td>
                    <td style={{ padding: '6px 10px' }}></td>
                    {vue === 'tous' && <td style={{ padding: '6px 10px' }}></td>}
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px' }}></td>
                    {vue === 'tous' && <td style={{ padding: '6px 10px' }}></td>}
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(tvaActive[6], 6))}</td>
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(tvaActive[12], 12))}</td>
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(tvaActive[21], 21))}</td>
                    <td style={{ padding: '6px 10px', fontWeight: 700, color: '#555' }}>
                      {fmt(tvaApayer(tvaActive[6], 6) + tvaApayer(tvaActive[12], 12) + tvaApayer(tvaActive[21], 21))}
                    </td>
                    <td style={{ padding: '6px 10px' }}></td>
                  </tr>
                </tfoot>
              </table>
            </div>

            {/* Mémo du mois */}
            <div style={{ marginBottom: 20 }}>
              <label style={{ fontSize: 13, fontWeight: 600, color: '#555', display: 'block', marginBottom: 6 }}>
                Annotations du mois (nettoyage, justifications de km…)
              </label>
              <textarea
                value={memoLocal}
                onChange={(e) => setMemoLocal(e.target.value)}
                onBlur={sauverMemo}
                rows={5}
                placeholder={'Ex :\n04 ' + MOIS_NOMS[mois - 1] + ' : Nettoyage\n11 ' + MOIS_NOMS[mois - 1] + ' : Nettoyage'}
                style={{
                  width: '100%', padding: '10px 12px', borderRadius: 8,
                  border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box',
                  fontFamily: 'inherit', resize: 'vertical',
                }}
              />
              <div style={{ fontSize: 12, color: '#aaa', marginTop: 4 }}>
                Enregistré automatiquement quand tu cliques en dehors du cadre.
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

function CarteTotal({ label, valeur, couleur, fort }) {
  return (
    <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 8, padding: '8px 14px', minWidth: 110 }}>
      <div style={{ fontSize: 11, color: '#888' }}>{label}</div>
      <div style={{ fontSize: fort ? 18 : 16, fontWeight: 700, color: couleur || '#111' }}>{valeur} €</div>
    </div>
  );
}