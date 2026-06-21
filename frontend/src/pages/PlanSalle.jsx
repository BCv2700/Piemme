import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
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

export default function PlanSalle() {
  const [tables, setTables] = useState([]);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [editing, setEditing] = useState(null);
  const roomRef = useRef(null);
  const dragRef = useRef(null);
  const clickTimerRef = useRef(null);
  const navigate = useNavigate();

  const load = () => api.get('/tables/').then(r => setTables(r.data)).catch(() => setError('Impossible de charger le plan de salle'));
  useEffect(() => { load(); }, []);

  const savePosition = async (id, pos_x, pos_y) => {
    try {
      await api.patch('/tables/' + id, { pos_x, pos_y });
    } catch (e) {
      setError(e.response?.data?.detail || 'Erreur lors du déplacement');
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
      setTables(prev => prev.map(t => t.id === draggedId ? { ...t, pos_x: newX, pos_y: newY } : t));
    };

    const onUp = () => {
      if (dragRef.current) {
        const { id, moved } = dragRef.current;
        if (moved) {
          setTables(prev => {
            const updated = prev.find(t => t.id === id);
            if (updated) savePosition(id, updated.pos_x, updated.pos_y);
            return prev;
          });
        } else {
          if (clickTimerRef.current) clearTimeout(clickTimerRef.current);
          clickTimerRef.current = setTimeout(() => {
            if (table.statut === 'indisponible') {
              setMsg({ type: 'error', text: 'Cette table est indisponible' });
              setTimeout(() => setMsg(null), 3000);
            } else {
              navigate('/caddy/' + id);
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
    setEditing({
      id: table.id,
      nom_reservation: table.nom_reservation || '',
      heure_arrivee: table.heure_arrivee ? table.heure_arrivee.slice(0, 16) : '',
    });
  };

  const saveReservation = async () => {
    try {
      await api.patch('/tables/' + editing.id, {
        nom_reservation: editing.nom_reservation || null,
        heure_arrivee: editing.heure_arrivee ? new Date(editing.heure_arrivee).toISOString() : null,
      });
      setMsg({ type: 'success', text: 'Réservation mise à jour' });
      setEditing(null);
      load();
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const clearReservation = async () => {
    try {
      await api.patch('/tables/' + editing.id, { nom_reservation: null, heure_arrivee: null });
      setMsg({ type: 'success', text: 'Réservation effacée' });
      setEditing(null);
      load();
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const changerStatut = async (id, statut) => {
    try {
      await api.patch('/tables/' + id, { statut });
      setMsg({ type: 'success', text: 'Statut mis à jour' });
      load();
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const nbLibres = tables.filter(t => t.statut === 'libre').length;
  const nbOccupees = tables.filter(t => t.statut === 'occupee').length;
  const nbReservees = tables.filter(t => t.statut === 'reservee').length;
  const nbIndisponibles = tables.filter(t => t.statut === 'indisponible').length;

  return (
    <div>
      <div className="topbar">
        <h1>Plan de salle</h1>
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

        <div className="stats">
          <div className="stat-card">
            <label>Tables libres</label>
            <span style={{ color: '#16a34a' }}>{nbLibres}</span>
          </div>
          <div className="stat-card">
            <label>Tables occupées</label>
            <span style={{ color: '#dc2626' }}>{nbOccupees}</span>
          </div>
          <div className="stat-card">
            <label>Tables réservées</label>
            <span style={{ color: '#b45309' }}>{nbReservees}</span>
          </div>
          <div className="stat-card">
            <label>Tables indisponibles</label>
            <span style={{ color: '#6b7280' }}>{nbIndisponibles}</span>
          </div>
          <div className="stat-card">
            <label>Total</label>
            <span>{tables.length}</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 16, marginBottom: 12, fontSize: 12, color: '#888' }}>
          {Object.entries(STATUT_LABEL).map(([key, label]) => (
            <span key={key} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ width: 10, height: 10, borderRadius: '50%', background: STATUT_COLOR[key], display: 'inline-block' }} />
              {label}
            </span>
          ))}
          <span style={{ marginLeft: 'auto' }}>Glissez une table pour la déplacer · Cliquez pour ouvrir le caddy · Double-cliquez pour la réservation</span>
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
          {tables.map(table => (
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
                height: table.forme === 'rond' ? 64 : 56,
                borderRadius: table.forme === 'rond' ? '50%' : 10,
                background: STATUT_COLOR[table.statut] || '#9ca3af',
                color: 'white',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: table.statut === 'indisponible' ? 'not-allowed' : 'grab',
                opacity: table.statut === 'indisponible' ? 0.6 : 1,
                userSelect: 'none',
                WebkitTouchCallout: 'none',
                fontSize: 13,
                fontWeight: 600,
                boxShadow: '0 1px 3px rgba(0,0,0,0.15)',
              }}
              title={table.nom + ' — ' + STATUT_LABEL[table.statut] + (table.nom_reservation ? ' — ' + table.nom_reservation : '')}
            >
              <span>{table.nom}</span>
              {table.nom_reservation ? (
                <span style={{ fontSize: 9, fontWeight: 500, opacity: 0.9, maxWidth: '90%', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{table.nom_reservation}</span>
              ) : (
                <span style={{ fontSize: 10, fontWeight: 400, opacity: 0.85 }}>{table.capacite}p</span>
              )}
            </div>
          ))}
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
            Statut des tables
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10 }}>
            {[...tables].sort((a, b) => a.nom.localeCompare(b.nom, undefined, { numeric: true })).map(table => (
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
                  value={table.statut}
                  onChange={(e) => changerStatut(table.id, e.target.value)}
                  style={{
                    fontSize: 12,
                    padding: '4px 6px',
                    borderRadius: 6,
                    border: '1px solid #ddd',
                    color: STATUT_COLOR[table.statut] || '#555',
                    fontWeight: 600,
                    background: 'white',
                    flex: 1,
                  }}
                >
                  {Object.entries(STATUT_LABEL).map(([key, label]) => (
                    <option key={key} value={key}>{label}</option>
                  ))}
                </select>
              </div>
            ))}
          </div>
        </div>
      </div>

      {editing && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 320 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 16 }}>Réservation</div>

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Nom de la réservation</label>
            <input
              type="text"
              value={editing.nom_reservation}
              onChange={(e) => setEditing({ ...editing, nom_reservation: e.target.value })}
              placeholder="Ex: Dupont 4p"
              style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, marginBottom: 16, boxSizing: 'border-box' }}
            />

            <label style={{ fontSize: 12, color: '#888', display: 'block', marginBottom: 4 }}>Heure d'arrivée</label>
            <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
              <input
                type="datetime-local"
                value={editing.heure_arrivee}
                onChange={(e) => setEditing({ ...editing, heure_arrivee: e.target.value })}
                style={{ flex: 1, padding: '8px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13 }}
              />
              <button
                className="btn"
                onClick={() => {
                  const now = new Date();
                  now.setSeconds(0, 0);
                  setEditing({ ...editing, heure_arrivee: now.toISOString().slice(0, 16) });
                }}
              >
                Maintenant
              </button>
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
