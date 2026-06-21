import { useState, useEffect, useMemo } from 'react';
import api from '../api/api';

const STATUT_LABEL = {
  confirmee: 'Confirmée',
  annulee: 'Annulée',
};

const STATUT_COLOR = {
  confirmee: '#16a34a',
  annulee: '#dc2626',
};

const JOURS_SEMAINE = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
const MOIS_LABEL = [
  'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
];

function toDateKey(date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function emptyForm(dateKey) {
  return {
    id: null,
    nom_client: '',
    date_reservation: dateKey,
    heure: '12:00',
    nb_personnes: 2,
    table_id: '',
    remarque: '',
    statut: 'confirmee',
  };
}

export default function Reservations() {
  const today = new Date();
  const [viewYear, setViewYear] = useState(today.getFullYear());
  const [viewMonth, setViewMonth] = useState(today.getMonth());
  const [selectedDate, setSelectedDate] = useState(toDateKey(today));
  const [reservationsByDate, setReservationsByDate] = useState({});
  const [monthCounts, setMonthCounts] = useState({});
  const [tables, setTables] = useState([]);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [form, setForm] = useState(null);
  const [loadingDay, setLoadingDay] = useState(false);

  useEffect(() => {
    api.get('/tables/').then(r => setTables(r.data)).catch(() => {});
  }, []);

  // Charge le nombre de réservations par jour pour tout le mois affiché (pour les pastilles du calendrier)
  useEffect(() => {
    const start = new Date(viewYear, viewMonth, 1);
    const end = new Date(viewYear, viewMonth + 1, 0);
    const daysInMonth = end.getDate();
    const promises = [];
    for (let d = 1; d <= daysInMonth; d++) {
      const dateKey = toDateKey(new Date(viewYear, viewMonth, d));
      promises.push(
        api.get('/reservations/', { params: { date_reservation: dateKey } })
          .then(r => ({ dateKey, count: r.data.length }))
          .catch(() => ({ dateKey, count: 0 }))
      );
    }
    Promise.all(promises).then(results => {
      const counts = {};
      results.forEach(({ dateKey, count }) => { counts[dateKey] = count; });
      setMonthCounts(counts);
    });
  }, [viewYear, viewMonth]);

  const loadDay = (dateKey) => {
    setLoadingDay(true);
    api.get('/reservations/', { params: { date_reservation: dateKey } })
      .then(r => {
        setReservationsByDate(prev => ({ ...prev, [dateKey]: r.data }));
        setMonthCounts(prev => ({ ...prev, [dateKey]: r.data.length }));
      })
      .catch(() => setError('Impossible de charger les réservations'))
      .finally(() => setLoadingDay(false));
  };

  useEffect(() => { loadDay(selectedDate); }, [selectedDate]);

  const calendarDays = useMemo(() => {
    const firstOfMonth = new Date(viewYear, viewMonth, 1);
    // Lundi = 0 ... Dimanche = 6
    const startOffset = (firstOfMonth.getDay() + 6) % 7;
    const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
    const cells = [];
    for (let i = 0; i < startOffset; i++) cells.push(null);
    for (let d = 1; d <= daysInMonth; d++) cells.push(new Date(viewYear, viewMonth, d));
    return cells;
  }, [viewYear, viewMonth]);

  const changeMonth = (delta) => {
    let m = viewMonth + delta;
    let y = viewYear;
    if (m < 0) { m = 11; y -= 1; }
    if (m > 11) { m = 0; y += 1; }
    setViewMonth(m);
    setViewYear(y);
  };

  const openCreate = () => setForm(emptyForm(selectedDate));
  const openEdit = (resa) => setForm({
    id: resa.id,
    nom_client: resa.nom_client,
    date_reservation: resa.date_reservation,
    heure: resa.heure.slice(0, 5),
    nb_personnes: resa.nb_personnes,
    table_id: resa.table_id || '',
    remarque: resa.remarque || '',
    statut: resa.statut,
  });

  const saveForm = async () => {
    if (!form.nom_client.trim()) {
      setMsg({ type: 'error', text: 'Le nom du client est requis' });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    const payload = {
      nom_client: form.nom_client,
      date_reservation: form.date_reservation,
      heure: form.heure,
      nb_personnes: Number(form.nb_personnes),
      table_id: form.table_id ? Number(form.table_id) : null,
      remarque: form.remarque || null,
      statut: form.statut,
    };
    try {
      if (form.id) {
        await api.patch('/reservations/' + form.id, payload);
      } else {
        await api.post('/reservations/', payload);
      }
      setMsg({ type: 'success', text: 'Réservation enregistrée' });
      setForm(null);
      loadDay(payload.date_reservation);
      if (payload.date_reservation !== selectedDate) setSelectedDate(payload.date_reservation);
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur lors de l\'enregistrement' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const deleteReservation = async (id) => {
    if (!window.confirm('Supprimer cette réservation ?')) return;
    try {
      await api.delete('/reservations/' + id);
      setMsg({ type: 'success', text: 'Réservation supprimée' });
      loadDay(selectedDate);
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const dayReservations = (reservationsByDate[selectedDate] || []).slice().sort((a, b) => a.heure.localeCompare(b.heure));
  const todayKey = toDateKey(today);

  const tableNomById = (id) => {
    const t = tables.find(t => t.id === id);
    return t ? t.nom : null;
  };

  return (
    <div>
      <div className="topbar">
        <h1>Réservations</h1>
      </div>
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

        <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap' }}>

          {/* Calendrier mensuel */}
          <div style={{
            flex: '1 1 380px',
            maxWidth: 480,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 16,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
              <button className="btn" onClick={() => changeMonth(-1)}>←</button>
              <div style={{ fontWeight: 600, fontSize: 15 }}>{MOIS_LABEL[viewMonth]} {viewYear}</div>
              <button className="btn" onClick={() => changeMonth(1)}>→</button>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4, marginBottom: 4 }}>
              {JOURS_SEMAINE.map(j => (
                <div key={j} style={{ fontSize: 11, color: '#888', textAlign: 'center', fontWeight: 600 }}>{j}</div>
              ))}
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 4 }}>
              {calendarDays.map((date, idx) => {
                if (!date) return <div key={'empty-' + idx} />;
                const dateKey = toDateKey(date);
                const count = monthCounts[dateKey] || 0;
                const isSelected = dateKey === selectedDate;
                const isToday = dateKey === todayKey;
                return (
                  <button
                    key={dateKey}
                    onClick={() => setSelectedDate(dateKey)}
                    style={{
                      border: isSelected ? '2px solid #111' : (isToday ? '1px solid #888' : '1px solid #eee'),
                      borderRadius: 8,
                      background: isSelected ? '#111' : 'white',
                      color: isSelected ? 'white' : '#333',
                      padding: '8px 4px',
                      fontSize: 13,
                      cursor: 'pointer',
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      gap: 2,
                      minHeight: 44,
                    }}
                  >
                    <span style={{ fontWeight: isToday ? 700 : 400 }}>{date.getDate()}</span>
                    {count > 0 && (
                      <span style={{
                        fontSize: 10,
                        fontWeight: 700,
                        color: isSelected ? 'white' : '#f59e0b',
                      }}>
                        {count}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Détail du jour sélectionné */}
          <div style={{
            flex: '1 1 380px',
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 16,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
              <div style={{ fontWeight: 600, fontSize: 15 }}>
                {new Date(selectedDate + 'T00:00:00').toLocaleDateString('fr-BE', { weekday: 'long', day: 'numeric', month: 'long' })}
              </div>
              <button className="btn" onClick={openCreate}>+ Nouvelle réservation</button>
            </div>

            {loadingDay && <div style={{ fontSize: 13, color: '#888' }}>Chargement...</div>}

            {!loadingDay && dayReservations.length === 0 && (
              <div style={{ fontSize: 13, color: '#888', padding: '20px 0', textAlign: 'center' }}>
                Aucune réservation ce jour
              </div>
            )}

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {dayReservations.map(resa => (
                <div
                  key={resa.id}
                  style={{
                    border: '1px solid #eee',
                    borderRadius: 8,
                    padding: '10px 12px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 10,
                    opacity: resa.statut === 'annulee' ? 0.5 : 1,
                  }}
                >
                  <div style={{ fontWeight: 700, fontSize: 14, width: 48 }}>{resa.heure.slice(0, 5)}</div>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontSize: 13, fontWeight: 600, color: '#333' }}>
                      {resa.nom_client} · {resa.nb_personnes}p
                      {resa.table_id && tableNomById(resa.table_id) && (
                        <span style={{ color: '#888', fontWeight: 400 }}> · {tableNomById(resa.table_id)}</span>
                      )}
                    </div>
                    {resa.remarque && (
                      <div style={{ fontSize: 12, color: '#888' }}>{resa.remarque}</div>
                    )}
                  </div>
                  <span style={{
                    fontSize: 11,
                    fontWeight: 600,
                    color: STATUT_COLOR[resa.statut] || '#555',
                    border: '1px solid ' + (STATUT_COLOR[resa.statut] || '#ddd'),
                    borderRadius: 6,
                    padding: '2px 8px',
                  }}>
                    {STATUT_LABEL[resa.statut] || resa.statut}
                  </span>
                  <button className="btn" onClick={() => openEdit(resa)}>Modifier</button>
                  <button className="btn" onClick={() => deleteReservation(resa.id)}>Suppr.</button>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {form && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 360 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 16 }}>
              {form.id ? 'Modifier la réservation' : 'Nouvelle réservation'}
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Nom du client</label>
            <input
              type="text"
              value={form.nom_client}
              onChange={(e) => setForm({ ...form, nom_client: e.target.value })}
              placeholder="Ex: Dupont"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Date</label>
                <input
                  type="date"
                  value={form.date_reservation}
                  onChange={(e) => setForm({ ...form, date_reservation: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ width: 100 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Heure</label>
                <input
                  type="time"
                  value={form.heure}
                  onChange={(e) => setForm({ ...form, heure: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
              <div style={{ width: 100 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Personnes</label>
                <input
                  type="number"
                  min="1"
                  value={form.nb_personnes}
                  onChange={(e) => setForm({ ...form, nb_personnes: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Table (optionnel)</label>
                <select
                  value={form.table_id}
                  onChange={(e) => setForm({ ...form, table_id: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                >
                  <option value="">— Aucune —</option>
                  {tables.slice().sort((a, b) => a.nom.localeCompare(b.nom, undefined, { numeric: true })).map(t => (
                    <option key={t.id} value={t.id}>{t.nom}</option>
                  ))}
                </select>
              </div>
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Remarque</label>
            <input
              type="text"
              value={form.remarque}
              onChange={(e) => setForm({ ...form, remarque: e.target.value })}
              placeholder="Ex: allergie noix, anniversaire..."
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Statut</label>
            <select
              value={form.statut}
              onChange={(e) => setForm({ ...form, statut: e.target.value })}
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 20, boxSizing: 'border-box' }}
            >
              {Object.entries(STATUT_LABEL).map(([key, label]) => (
                <option key={key} value={key}>{label}</option>
              ))}
            </select>

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={() => setForm(null)}>Annuler</button>
              <button className="btn" style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }} onClick={saveForm}>
                Enregistrer
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
