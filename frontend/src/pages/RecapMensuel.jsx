import { useState, useEffect, useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import api from '../api/api';

const TAUX_TVA = [21, 6, 12];

const MOIS_NOMS = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

function todayKey() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}

function pad2(n) {
  return String(n).padStart(2, '0');
}

// Nombre de jours dans un mois (mois = 1..12)
function joursDansMois(annee, mois) {
  return new Date(annee, mois, 0).getDate();
}

// Clé AAAA-MM-JJ pour un jour donné
function dateKey(annee, mois, jour) {
  return annee + '-' + pad2(mois) + '-' + pad2(jour);
}

export default function RecapMensuel() {
  const [searchParams] = useSearchParams();
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

  // Recettes uniquement (on exclut les dépenses), comme dans l'écran Encaissements
  const recettes = useMemo(() => encaissements.filter(e => !e.depenses), [encaissements]);

  // Regroupe les recettes par jour du mois (1..31)
  const parJour = useMemo(() => {
    const map = {}; // jour -> { total, cash, carte, cashAnalyse, tva: {6,12,21,autre} }
    const nbJours = joursDansMois(annee, mois);
    for (let j = 1; j <= nbJours; j++) {
      map[j] = { total: 0, cash: 0, carte: 0, cashAnalyse: 0, tva: { 6: 0, 12: 0, 21: 0, autre: 0 } };
    }
    recettes.forEach(enc => {
      const d = new Date(enc.date_encaissement);
      // On se base sur l'année/mois/jour locaux de la date d'encaissement
      if (d.getFullYear() !== annee || (d.getMonth() + 1) !== mois) return;
      const j = d.getDate();
      if (!map[j]) return;
      map[j].total += Number(enc.montant_total || 0);
      map[j].cash += Number(enc.montant_cash || 0);
      map[j].carte += Number(enc.montant_carte || 0);
      map[j].cashAnalyse += Number(enc.cash_analyse || 0);
      (enc.lignes || []).forEach(ligne => {
        const montant = Number(ligne.prix_vente) * Number(ligne.quantite);
        const taux = Math.round(Number(ligne.tva));
        if (map[j].tva[taux] !== undefined) map[j].tva[taux] += montant;
        else map[j].tva.autre += montant;
      });
    });
    return map;
  }, [recettes, annee, mois]);

  // Totaux du mois
  const totaux = useMemo(() => {
    const t = { total: 0, cash: 0, carte: 0, cashAnalyse: 0, tva: { 6: 0, 12: 0, 21: 0, autre: 0 } };
    Object.values(parJour).forEach(j => {
      t.total += j.total;
      t.cash += j.cash;
      t.carte += j.carte;
      t.cashAnalyse += j.cashAnalyse;
      t.tva[6] += j.tva[6];
      t.tva[12] += j.tva[12];
      t.tva[21] += j.tva[21];
      t.tva.autre += j.tva.autre;
    });
    return t;
  }, [parJour]);

  // Base totale ventilée (somme des 3 taux) pour le calcul des pourcentages
  const baseTva = totaux.tva[6] + totaux.tva[12] + totaux.tva[21];
  const pourcentage = (montant) => (baseTva > 0 ? (montant / baseTva) * 100 : 0);

  // TVA à payer par taux = base × taux / (100 + taux)
  const tvaApayer = (base, taux) => base * taux / (100 + taux);

  // ───── km : valeur par défaut + exceptions par jour ──────────────────────
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

  // Enregistre une exception de km pour un jour
  const changerKm = async (jour, valeurStr) => {
    const valeur = Number(String(valeurStr).replace(',', '.'));
    if (!Number.isFinite(valeur) || valeur < 0) return;
    const nouvellesExceptions = { ...(recap?.km_par_jour || {}) };
    nouvellesExceptions[String(jour)] = valeur;
    // Mise à jour locale immédiate
    setRecap(prev => ({ ...prev, km_par_jour: nouvellesExceptions }));
    try {
      const res = await api.patch('/recap-mensuel/' + annee + '/' + mois, { km_par_jour: nouvellesExceptions });
      setRecap(res.data);
    } catch (e) {
      showMsg('error', 'Erreur lors de l\'enregistrement des km');
      load();
    }
  };

  // Enregistre le mémo (au blur)
  const [memoLocal, setMemoLocal] = useState('');
  useEffect(() => { setMemoLocal(recap ? (recap.memo || '') : ''); }, [recap?.memo]);

  const sauverMemo = async () => {
    if (!recap) return;
    if (memoLocal === (recap.memo || '')) return; // rien changé
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

  const fmt = (n) => Number(n).toFixed(2);

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

        <div style={{ display: 'flex', alignItems: 'baseline', gap: 12, marginBottom: 16 }}>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: 0, textTransform: 'capitalize' }}>
            {MOIS_NOMS[mois - 1]} {annee}
          </h2>
          <span style={{ fontSize: 13, color: '#888' }}>
            (mois suivant la date du plan de salle)
          </span>
        </div>

        {loading ? (
          <div style={{ color: '#888' }}>Chargement...</div>
        ) : (
          <>
            {/* Bandeau de totaux du mois */}
            <div style={{ display: 'flex', gap: 10, marginBottom: 16, flexWrap: 'wrap' }}>
              <CarteTotal label="Total" valeur={fmt(totaux.total)} fort />
              <CarteTotal label="Cash" valeur={fmt(totaux.cash)} couleur="#16a34a" />
              <CarteTotal label="Carte" valeur={fmt(totaux.carte)} couleur="#2563eb" />
              <CarteTotal label="Cash analysé" valeur={fmt(totaux.cashAnalyse)} couleur="#b45309" />
              {TAUX_TVA.map(taux => (
                <CarteTotal
                  key={taux}
                  label={'TVA ' + taux + '% (' + pourcentage(totaux.tva[taux]).toFixed(2) + '%)'}
                  valeur={fmt(totaux.tva[taux])}
                />
              ))}
              <CarteTotal label="Km A/R" valeur={fmt(totalKm)} couleur="#6b7280" />
            </div>

            {/* Tableau jour par jour */}
            <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, overflow: 'auto', marginBottom: 20 }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, minWidth: 760 }}>
                <thead>
                  <tr style={{ background: '#fafaf8', textAlign: 'right' }}>
                    <th style={{ padding: '8px 10px', textAlign: 'left' }}>Jour</th>
                    <th style={{ padding: '8px 10px' }}>Total</th>
                    <th style={{ padding: '8px 10px' }}>Cash</th>
                    <th style={{ padding: '8px 10px' }}>Carte</th>
                    <th style={{ padding: '8px 10px' }}>Cash analysé</th>
                    <th style={{ padding: '8px 10px' }}>TVA 21%</th>
                    <th style={{ padding: '8px 10px' }}>TVA 6%</th>
                    <th style={{ padding: '8px 10px' }}>TVA 12%</th>
                    <th style={{ padding: '8px 10px' }}>Km A/R</th>
                  </tr>
                </thead>
                <tbody>
                  {jours.map(j => {
                    const d = parJour[j];
                    const aRecette = d.total !== 0;
                    return (
                      <tr key={j} style={{ borderTop: '1px solid #f0f0ee', textAlign: 'right' }}>
                        <td style={{ padding: '4px 10px', textAlign: 'left', whiteSpace: 'nowrap', color: aRecette ? '#111' : '#aaa' }}>
                          {pad2(j)} <span style={{ color: '#999', textTransform: 'capitalize' }}>{nomJourSemaine(j)}</span>
                        </td>
                        <td style={{ padding: '4px 10px', fontWeight: aRecette ? 700 : 400, color: aRecette ? '#111' : '#ccc' }}>{fmt(d.total)}</td>
                        <td style={{ padding: '4px 10px', color: aRecette ? '#16a34a' : '#ccc' }}>{fmt(d.cash)}</td>
                        <td style={{ padding: '4px 10px', color: aRecette ? '#2563eb' : '#ccc' }}>{fmt(d.carte)}</td>
                        <td style={{ padding: '4px 10px', color: aRecette ? '#b45309' : '#ccc' }}>{fmt(d.cashAnalyse)}</td>
                        <td style={{ padding: '4px 10px', color: '#666' }}>{fmt(d.tva[21])}</td>
                        <td style={{ padding: '4px 10px', color: '#666' }}>{fmt(d.tva[6])}</td>
                        <td style={{ padding: '4px 10px', color: '#666' }}>{fmt(d.tva[12])}</td>
                        <td style={{ padding: '2px 6px' }}>
                          <input
                            type="number" step="0.1" min="0"
                            defaultValue={fmt(kmDuJour(j))}
                            onBlur={(e) => changerKm(j, e.target.value)}
                            style={{ width: 64, padding: '2px 6px', borderRadius: 5, border: '1px solid #ddd', fontSize: 12, textAlign: 'right' }}
                          />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
                <tfoot>
                  <tr style={{ borderTop: '2px solid #e5e5e0', textAlign: 'right', fontWeight: 700, background: '#fafaf8' }}>
                    <td style={{ padding: '8px 10px', textAlign: 'left' }}>Totaux {MOIS_NOMS[mois - 1]}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(totaux.total)}</td>
                    <td style={{ padding: '8px 10px', color: '#16a34a' }}>{fmt(totaux.cash)}</td>
                    <td style={{ padding: '8px 10px', color: '#2563eb' }}>{fmt(totaux.carte)}</td>
                    <td style={{ padding: '8px 10px', color: '#b45309' }}>{fmt(totaux.cashAnalyse)}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(totaux.tva[21])}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(totaux.tva[6])}</td>
                    <td style={{ padding: '8px 10px' }}>{fmt(totaux.tva[12])}</td>
                    <td style={{ padding: '8px 10px', color: '#6b7280' }}>{fmt(totalKm)}</td>
                  </tr>
                  <tr style={{ textAlign: 'right', background: '#fafaf8' }}>
                    <td style={{ padding: '6px 10px', textAlign: 'left', color: '#888' }}>TVA à payer</td>
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px' }}></td>
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(totaux.tva[21], 21))}</td>
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(totaux.tva[6], 6))}</td>
                    <td style={{ padding: '6px 10px', color: '#888' }}>{fmt(tvaApayer(totaux.tva[12], 12))}</td>
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