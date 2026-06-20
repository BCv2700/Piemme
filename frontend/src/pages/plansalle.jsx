import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/api';

const STATUT_COLOR = {
  libre: '#22c55e',
  occupee: '#ef4444',
  reservee: '#f59e0b',
};

const STATUT_LABEL = {
  libre: 'Libre',
  occupee: 'Occupée',
  reservee: 'Réservée',
};

export default function PlanSalle() {
  const [tables, setTables] = useState([]);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState(null);
  const [selected, setSelected] = useState(null);
  const roomRef = useRef(null);
  const dragRef = useRef(null);
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
          navigate('/caddy/' + id);
        }
      }
      dragRef.current = null;
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  };

  const changerStatut = async (id, statut) => {
    try {
      await api.patch('/tables/' + id, { statut });
      setMsg({ type: 'success', text: 'Statut mis à jour' });
      setSelected(null);
      load();
    } catch (e) {
      setMsg({ type: 'error', text: e.response?.data?.detail || 'Erreur' });
    }
    setTimeout(() => setMsg(null), 3000);
  };

  const nbLibres = tables.filter(t => t.statut === 'libre').length;
  const nbOccupees = tables.filter(t => t.statut === 'occupee').length;
  const nbReservees = tables.filter(t => t.statut === 'reservee').length;

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
          <span style={{ marginLeft: 'auto' }}>Glissez une table pour la déplacer · Cliquez pour ouvrir le caddy</span>
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
          }}
        >
          {tables.map(table => (
            <div
              key={table.id}
              id={'table-' + table.id}
              onMouseDown={(e) => handleMouseDown(e, table)}
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
                cursor: 'grab',
                userSelect: 'none',
                fontSize: 13,
                fontWeight: 600,
                boxShadow: '0 1px 3px rgba(0,0,0,0.15)',
              }}
              title={table.nom + ' — ' + STATUT_LABEL[table.statut]}
            >
              <span>{table.nom}</span>
              <span style={{ fontSize: 10, fontWeight: 400, opacity: 0.85 }}>{table.capacite}p</span>
            </div>
          ))}
        </div>
      </div>

      {selected && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
        }}>
          <div style={{ background: 'white', borderRadius: 10, padding: 24, width: 320 }}>
            <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 4 }}>{selected.nom}</div>
            <div style={{ fontSize: 13, color: '#888', marginBottom: 16 }}>{selected.capacite} places</div>

            <div style={{ fontSize: 12, color: '#888', marginBottom: 8 }}>Changer le statut</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
              {Object.entries(STATUT_LABEL).map(([key, label]) => (
                <button
                  key={key}
                  className="btn"
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'flex-start',
                    borderColor: selected.statut === key ? STATUT_COLOR[key] : '#ddd',
                    color: selected.statut === key ? STATUT_COLOR[key] : '#555',
                    fontWeight: selected.statut === key ? 600 : 400,
                  }}
                  onClick={() => changerStatut(selected.id, key)}
                >
                  <span style={{ width: 10, height: 10, borderRadius: '50%', background: STATUT_COLOR[key], display: 'inline-block', marginRight: 8 }} />
                  {label}
                </button>
              ))}
            </div>

            <button className="btn" style={{ width: '100%' }} onClick={() => setSelected(null)}>Fermer</button>
          </div>
        </div>
      )}
    </div>
  );
}
