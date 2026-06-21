import { useState, useEffect, useRef } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import api from '../api/api';

const STATUT_COLOR = {
  libre: '#22c55e',
  occupee: '#ef4444',
  reservee: '#f59e0b',
  indisponible: '#9ca3af',
};

const STATUT_LABEL = {
  libre: 'Libre',
  occupee: 'Occupée',
  reservee: 'Réservée',
  indisponible: 'Indisponible',
};

function toDateKey(date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

const DATE_REFERENCE = '2025-12-31'; // jour neutre utilisé pour éditer la disposition de référence des tables

function extractErrorMessage(e, fallback) {
  const detail = e.response?.data?.detail;
  if (!detail) return fallback;
  if (typeof detail === 'string') return detail;
  if (Array.isArray(detail)) {
    return detail.map(d => d.msg || JSON.stringify(d)).join(' · ');
  }
  return fallback;
}

export default function PlanSalle() {
  const todayKey = toDateKey(new Date());
  const [searchParams, setSearchParams] = useSearchParams();
  const selectedDate = searchParams.get('date') || todayKey;

  const setSelectedDate = (newDate) => {
    if (newDate === todayKey) {
      setSearchParams({});
    } else {
      setSearchParams({ date: newDate });
    }
  };

  const [tablesRef, setTablesRef] = useState([]); // disposition de référence (Table.pos_x/pos_y/statut...)
  const [positionsJour, setPositionsJour] = useState([]); // exceptions de position pour le jour affiché
  const [reservationsJour, setReservationsJour] = useState([]); // réservations confirmées du jour affiché
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [editing, setEditing] = useState(null);
  const roomRef = useRef(null);
  const dragRef = useRef(null);
  const clickTimerRef = useRef(null);
  const navigate = useNavigate();

  const isToday = selectedDate === todayKey;
  const isReferenceDay = selectedDate === DATE_REFERENCE;

  const load = () => {
    Promise.all([
      api.get('/tables/'),
      api.get('/table-positions-jour/', { params: { date_jour: selectedDate } }),
      api.get('/reservations/', { params: { date_reservation: selectedDate } }),
    ])
      .then(([tablesRes, positionsRes, reservationsRes]) => {
        setTablesRef(tablesRes.data);
        setPositionsJour(positionsRes.data);
        setReservationsJour(reservationsRes.data.filter(r => r.statut !== 'annulee'));
      })
      .catch(() => setError('Impossible de charger le plan de salle'));
  };

  useEffect(() => { load(); }, [selectedDate]);

  // Fusionne la disposition de référence avec les exceptions du jour affiché,
  // et calcule pour chaque table sa réservation du jour (s'il y en a une) et son statut effectif.
  const tables = tablesRef.map(t => {
    const exception = positionsJour.find(p => p.table_id === t.id);
    const reservation = reservationsJour.find(r => r.table_id === t.id);
    let statutEffectif = 'libre';
    if (reservation) {
      statutEffectif = 'reservee';
    } else if (exception && exception.statut) {
      statutEffectif = exception.statut;
    } else if (isToday) {
      statutEffectif = t.statut;
    }
    return {
      ...t,
      pos_x: exception && exception.pos_x != null ? exception.pos_x : t.pos_x,
      pos_y: exception && exception.pos_y != null ? exception.pos_y : t.pos_y,
      statutEffectif,
      reservation,
    };
  });

  const savePosition = async (id, pos_x, pos_y) => {
    try {
      await api.put('/table-positions-jour/', {
        table_id: id,
        date: selectedDate,
        pos_x,
        pos_y,
        definir_reference: isReferenceDay,
      });
      if (isReferenceDay) load();
    } catch (e) {
      setError(extractErrorMessage(e, 'Erreur lors du déplacement'));
    }
  };

  const handleMouseDown = (e, table) => {
    if (e.button !== 0) return;
    e.preventDefault();
    const roomRect = roomRef.current.getBoundingClientRect();
    dragRef.current = {
      id: table.id,
      offsetX: e.clientX - roomRect.left - table.pos_x,
      offsetY: e.clientY - roomRect.top - table.pos_y,
      startX: table.pos_x,
      startY: table.pos_y,
      moved: false,
    };

    const onMove = (ev) => {
      if (!dragRef.current) return;
      const draggedId = dragRef.current.id;
      const rect = roomRef.current.getBoundingClientRect();
      const newX = Math.max(0, Math.min(rect.width - 90, ev.clientX - rect.left - dragRef.current.offsetX));
      const newY = Math.max(0, Math.min(rect.height - 90, ev.clientY - rect.top - dragRef.current.offsetY));
      if (Math.abs(newX - dragRef.current.startX) > 4 || Math.abs(newY - dragRef.current.startY) > 4) {
        dragRef.current.moved = true;
      }
      setPositionsJour(prev => {
        const others = prev.filter(p => p.table_id !== draggedId);
        return [...others, { table_id: draggedId, date: selectedDate, pos_x: newX, pos_y: newY }];
      });
    };

    const onUp = () => {
      if (dragRef.current) {
        const { id, moved } = dragRef.current;
        if (moved) {
          setPositionsJour(prev => {
            const current = prev.find(p => p.table_id === id);
            if (current) savePosition(id, current.pos_x, current.pos_y);
            return prev;
          });
        } else {
          if (clickTimerRef.current) clearTimeout(clickTimerRef.current);
          clickTimerRef.current = setTimeout(() => {
            if (table.statutEffectif === 'indisponible') {
              setMsg({ type: 'error', text: 'Cette table est indisponible' });
              setTimeout(() => setMsg(null), 3000);
            } else {
              navigate('/caddy/' + id + '?retourDate=' + selectedDate);
            }
          }, 220);
        }
      }
      dragRef.current = null;
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  };

  const handleDoubleClick = (e, table) => {
    e.preventDefault();
    if (clickTimerRef.current) {
      clearTimeout(clickTimerRef.current);
      clickTimerRef.current = null;
    }
    if (isReferenceDay) {
      setMsg({ type: 'error', text: 'Pas de réservation possible sur le jour de référence' });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    const resa = table.reservation;
    setEditing({
      tableId: table.id,
      reservationId: resa ? resa.id : null,
      nom_client: resa ? resa.nom_client : '',
      heure: resa ? resa.heure.slice(0, 5) : '12:00',
      nb_personnes: resa ? resa.nb_personnes : (table.capacite || 2),
    });
  };

  const saveReservation = async () => {
    if (!editing.nom_client.trim()) {
      setMsg({ type: 'error', text: 'Le nom est requis' });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    const nbPersonnes = Number(editing.nb_personnes);
    if (!nbPersonnes || nbPersonnes < 1) {
      setMsg({ type: 'error', text: 'Le nombre de personnes doit être supérieur à 0' });
      setTimeout(() => setMsg(null), 3000);
      return;
    }
    const payload = {
      table_id: editing.tableId,
      nom_client: editing.nom_client,
      date_reservation: selectedDate,
      heure: editing.heure,
      nb_personnes: nbPersonnes,
      statut: 'confirmee',
    };
    try {
      if (editing.reservationId) {
        await api.patch('/reservations/' + editing.reservationId, payload);
      } else {
        await api.post('/reservations/', payload);
      }
      setMsg({ type: 'success', text: 'Réservation enregistrée' });
      setEditing(null);
      load();
    } catch (e) {
      setMsg({ type: 'error', text: extractErrorMessage(e, 'Erreur') });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const clearReservation = async () => {
    try {
      if (editing.reservationId) {
        await api.delete('/reservations/' + editing.reservationId);
      }
      setMsg({ type: 'success', text: 'Réservation effacée' });
      setEditing(null);
      load();
    } catch (e) {
      setMsg({ type: 'error', text: extractErrorMessage(e, 'Erreur') });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const resetPositionsJour = async () => {
    if (!window.confirm('Réinitialiser toutes les tables de ce jour vers la disposition de référence ?')) return;
    try {
      await api.delete('/table-positions-jour/jour/' + selectedDate);
      setMsg({ type: 'success', text: 'Disposition réinitialisée pour ce jour' });
      load();
    } catch (e) {
      setMsg({ type: 'error', text: extractErrorMessage(e, 'Erreur') });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const changerStatut = async (id, statut) => {
    try {
      await api.put('/table-positions-jour/statut', {
        table_id: id,
        date: selectedDate,
        statut,
      });
      setMsg({ type: 'success', text: 'Statut mis à jour' });
      load();
    } catch (e) {
      setMsg({ type: 'error', text: extractErrorMessage(e, 'Erreur') });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const nbLibres = tables.filter(t => t.statutEffectif === 'libre').length;
  const nbOccupees = tables.filter(t => t.statutEffectif === 'occupee').length;
  const nbReservees = tables.filter(t => t.statutEffectif === 'reservee').length;
  const nbIndisponibles = tables.filter(t => t.statutEffectif === 'indisponible').length;

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

        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14, flexWrap: 'wrap' }}>
          <label style={{ fontSize: 13, color: '#888', fontWeight: 600 }}>Jour affiché</label>
          <input
            type="date"
            value={selectedDate}
            onChange={(e) => setSelectedDate(e.target.value)}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
          />
          {!isToday && (
            <button className="btn" onClick={() => setSelectedDate(todayKey)}>Revenir à aujourd'hui</button>
          )}
          {!isReferenceDay && (
            <button className="btn" onClick={() => setSelectedDate(DATE_REFERENCE)} style={{ color: '#888' }}>
              Modifier la disposition de référence
            </button>
          )}
          {!isReferenceDay && (
            <button className="btn" onClick={resetPositionsJour} style={{ color: '#888' }}>
              Réinitialiser ce jour
            </button>
          )}
          {isReferenceDay && (
            <span style={{
              fontSize: 12, fontWeight: 600, color: '#b45309',
              background: '#fef3c7', borderRadius: 6, padding: '6px 12px', marginLeft: 'auto',
            }}>
              Mode disposition de référence — tout déplacement modifie la base pour tous les jours
            </span>
          )}
        </div>

        <div className="stats" style={{ gridTemplateColumns: 'repeat(5, 1fr)' }}>
          <div className="stat-card" style={{ padding: '8px 14px' }}>
            <label>Tables libres</label>
            <span style={{ color: '#16a34a', fontSize: 20 }}>{nbLibres}</span>
          </div>
          <div className="stat-card" style={{ padding: '8px 14px' }}>
            <label>Tables occupées</label>
            <span style={{ color: '#dc2626', fontSize: 20 }}>{nbOccupees}</span>
          </div>
          <div className="stat-card" style={{ padding: '8px 14px' }}>
            <label>Tables réservées</label>
            <span style={{ color: '#b45309', fontSize: 20 }}>{nbReservees}</span>
          </div>
          <div className="stat-card" style={{ padding: '8px 14px' }}>
            <label>Tables indisponibles</label>
            <span style={{ color: '#6b7280', fontSize: 20 }}>{nbIndisponibles}</span>
          </div>
          <div className="stat-card" style={{ padding: '8px 14px' }}>
            <label>Total</label>
            <span style={{ fontSize: 20 }}>{tables.length}</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 16, marginBottom: 12, fontSize: 12, color: '#888' }}>
          {Object.entries(STATUT_LABEL).map(([key, label]) => (
            <span key={key} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ width: 10, height: 10, borderRadius: '50%', background: STATUT_COLOR[key], display: 'inline-block' }} />
              {label}
            </span>
          ))}
          <span style={{ marginLeft: 'auto' }}>
            {isToday
              ? 'Glissez une table pour la déplacer · Cliquez pour ouvrir le caddy · Double-cliquez pour la réservation'
              : 'Double-cliquez pour réserver ce jour · Choisissez le statut ci-dessous'}
          </span>
        </div>

        <div
          ref={roomRef}
          style={{
            position: 'relative',
            width: '100%',
            height: 560,
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            overflow: 'hidden',
            marginBottom: 16,
          }}
        >
          {tables.map(table => {
            const resa = table.reservation;
            const heure = resa ? resa.heure.slice(0, 5) : null;
            const nomResa = resa ? resa.nom_client : null;
            const hasReservation = !!resa;
            return (
              <div
                key={table.id}
                id={'table-' + table.id}
                onMouseDown={(e) => handleMouseDown(e, table)}
                onDoubleClick={(e) => handleDoubleClick(e, table)}
                style={{
                  position: 'absolute',
                  left: table.pos_x,
                  top: table.pos_y,
                  width: table.forme === 'rond' ? 64 : (table.capacite >= 6 ? 100 : 80),
                  height: table.forme === 'rond' ? 64 : (hasReservation ? 70 : 44),
                  borderRadius: table.forme === 'rond' ? '50%' : 10,
                  background: STATUT_COLOR[table.statutEffectif] || '#9ca3af',
                  color: 'white',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  cursor: table.statutEffectif === 'indisponible' ? 'not-allowed' : 'grab',
                  opacity: table.statutEffectif === 'indisponible' ? 0.6 : 1,
                  userSelect: 'none',
                  WebkitTouchCallout: 'none',
                  fontSize: 13,
                  fontWeight: 600,
                  boxShadow: '0 1px 3px rgba(0,0,0,0.15)',
                  padding: '2px 4px',
                }}
                title={table.nom + ' — ' + STATUT_LABEL[table.statutEffectif] + (nomResa ? ' — ' + nomResa : '') + (heure ? ' — ' + heure : '')}
              >
                <span>{table.nom}</span>
                {resa && (
                  <span style={{ fontSize: 10, fontWeight: 400, opacity: 0.85 }}>
                    {resa.nb_personnes}p{heure ? ' · ' + heure : ''}
                  </span>
                )}
                {nomResa && (
                  <span style={{ fontSize: 9, fontWeight: 500, opacity: 0.9, maxWidth: '95%', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {nomResa}
                  </span>
                )}
              </div>
            );
          })}
        </div>

        <div
          style={{
            background: 'white',
            border: '1px solid #e5e5e0',
            borderRadius: 10,
            padding: 16,
          }}
        >
          <div style={{ fontSize: 12, color: '#888', fontWeight: 600, marginBottom: 12, textTransform: 'uppercase', letterSpacing: 0.4 }}>
            Statut des tables {isToday ? "(aujourd'hui)" : '— ' + selectedDate}
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10 }}>
            {[...tables].sort((a, b) => a.nom.localeCompare(b.nom, undefined, { numeric: true })).map(table => {
              const disabled = !!table.reservation || isReferenceDay;
              return (
                <div
                  key={table.id}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    padding: '8px 10px',
                    border: '1px solid #eee',
                    borderRadius: 8,
                    minWidth: 150,
                  }}
                >
                  <span style={{ fontSize: 13, fontWeight: 600, color: '#333' }}>{table.nom}</span>
                  <select
                    value={table.statutEffectif}
                    onChange={(e) => changerStatut(table.id, e.target.value)}
                    disabled={disabled}
                    title={disabled ? (table.reservation ? 'Réservée automatiquement ce jour' : 'Non modifiable sur le jour de référence') : ''}
                    style={{
                      fontSize: 12,
                      padding: '4px 6px',
                      borderRadius: 6,
                      border: '1px solid #ddd',
                      color: STATUT_COLOR[table.statutEffectif] || '#555',
                      fontWeight: 600,
                      background: disabled ? '#f5f5f0' : 'white',
                      flex: 1,
                      cursor: disabled ? 'not-allowed' : 'pointer',
                    }}
                  >
                    {Object.entries(STATUT_LABEL).map(([key, label]) => (
                      <option key={key} value={key}>{label}</option>
                    ))}
                  </select>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {editing && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 320 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 4 }}>Réservation</div>
            <div style={{ fontSize: 12, color: '#888', marginBottom: 16 }}>
              {new Date(selectedDate + 'T00:00:00').toLocaleDateString('fr-BE', { weekday: 'long', day: 'numeric', month: 'long' })}
            </div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Nom du client</label>
            <input
              type="text"
              value={editing.nom_client}
              onChange={(e) => setEditing({ ...editing, nom_client: e.target.value })}
              placeholder="Ex: Dupont"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 14, boxSizing: 'border-box' }}
            />

            <div style={{ display: 'flex', gap: 10, marginBottom: 20 }}>
              <div style={{ flex: 1 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Heure</label>
                <input
                  type="time"
                  value={editing.heure}
                  onChange={(e) => setEditing({ ...editing, heure: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
              <div style={{ width: 100 }}>
                <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Personnes</label>
                <input
                  type="number"
                  min="1"
                  value={editing.nb_personnes}
                  onChange={(e) => setEditing({ ...editing, nb_personnes: e.target.value })}
                  style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" style={{ flex: 1 }} onClick={() => setEditing(null)}>Annuler</button>
              <button className="btn" style={{ flex: 1 }} onClick={clearReservation}>Effacer</button>
              <button className="btn" style={{ flex: 1, background: '#22c55e', color: 'white', borderColor: '#22c55e' }} onClick={saveReservation}>Valider</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
