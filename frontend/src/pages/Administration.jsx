import { useState, useEffect } from 'react';
import api from '../api/api';

const PROD_URL = 'https://piemme-production.up.railway.app';

export default function Administration() {
  const [infoEnv, setInfoEnv] = useState(null);
  const [etatBackup, setEtatBackup] = useState('');
  const [etatSync, setEtatSync] = useState('');
  const [enCours, setEnCours] = useState(false);
  const [detailSync, setDetailSync] = useState(null);
  const [mdpForm, setMdpForm] = useState({ username: '', ancien: '', nouveau: '', nouveau2: '' });
  const [mdpMsg, setMdpMsg] = useState('');
  const [resetForm, setResetForm] = useState({ username: '', nouveau: '', nouveau2: '' });
  const [resetMsg, setResetMsg] = useState('');
  const [showMdp, setShowMdp] = useState({ ancien: false, nouveau: false, nouveau2: false });
  const [showReset, setShowReset] = useState({ nouveau: false, nouveau2: false });
  const [credsProd, setCredsProd] = useState({ username: '', password: '', visible: false });

  // ── Utilisateurs ────────────────────────────────────────────────────────
  const [utilisateurs, setUtilisateurs] = useState([]);
  const [loadingUsers, setLoadingUsers] = useState(false);
  const [userMsg, setUserMsg] = useState('');
  const [nouvelUser, setNouvelUser] = useState({ username: '', mot_de_passe: '', role: 'admin' });
  const [showNouvelUserMdp, setShowNouvelUserMdp] = useState(false);

  const chargerUtilisateurs = async () => {
    setLoadingUsers(true);
    try {
      const r = await api.get('/auth/utilisateurs');
      setUtilisateurs(r.data);
    } catch (e) {
      setUserMsg('❌ Impossible de charger les utilisateurs.');
    } finally {
      setLoadingUsers(false);
    }
  };

  useEffect(() => { chargerUtilisateurs(); }, []);

  const creerUtilisateur = async () => {
    setUserMsg('');
    if (!nouvelUser.username || !nouvelUser.mot_de_passe) { setUserMsg('❌ Identifiant et mot de passe requis.'); return; }
    try {
      await api.post('/auth/utilisateurs', nouvelUser);
      setUserMsg('✅ Compte créé.');
      setNouvelUser({ username: '', mot_de_passe: '', role: 'admin' });
      chargerUtilisateurs();
    } catch (e) {
      setUserMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  const toggleActif = async (u) => {
    try {
      await api.put(`/auth/utilisateurs/${u.id}`, { actif: !u.actif });
      chargerUtilisateurs();
    } catch (e) {
      setUserMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  const changerRole = async (u, role) => {
    try {
      await api.put(`/auth/utilisateurs/${u.id}`, { role });
      chargerUtilisateurs();
    } catch (e) {
      setUserMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  const supprimerUtilisateur = async (u) => {
    if (!window.confirm(`Supprimer le compte « ${u.username} » ? Cette action est irréversible.`)) return;
    try {
      await api.delete(`/auth/utilisateurs/${u.id}`);
      setUserMsg(`✅ Compte « ${u.username} » supprimé.`);
      chargerUtilisateurs();
    } catch (e) {
      setUserMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  useEffect(() => {
    api.get('/admin/info').then(r => setInfoEnv(r.data)).catch(() => {});
  }, []);

  const estLocal = infoEnv?.env === 'local';

  // ── Backup ──────────────────────────────────────────────────────────────
  const lancerBackup = async () => {
    const base = import.meta.env.VITE_API_URL || 'http://localhost:8001';
    const token = localStorage.getItem('piemme_token');
    setEtatBackup('⏳ Préparation du backup…');
    try {
      const rep = await fetch(`${base}/admin/backup`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (!rep.ok) { setEtatBackup('❌ Erreur lors du backup.'); return; }
      const blob = await rep.blob();
      const now = new Date();
      const nomFichier = `piemme_backup_${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}-${String(now.getDate()).padStart(2,'0')}_${String(now.getHours()).padStart(2,'0')}-${String(now.getMinutes()).padStart(2,'0')}.zip`;
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = nomFichier;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      setEtatBackup('✅ Backup téléchargé !');
    } catch (e) {
      setEtatBackup('❌ Erreur : ' + e.message);
    }
    setTimeout(() => setEtatBackup(''), 4000);
  };

  // ── Synchro prod → local ────────────────────────────────────────────────
  const lancerSync = async () => {
    if (!estLocal) {
      alert('La synchro ne peut être lancée qu\'en environnement local.');
      return;
    }
    if (!window.confirm('Cela va écraser TOUTES les données locales avec celles de la prod. Continuer ?')) return;

    setEnCours(true);
    setEtatSync('⏳ Étape 1/2 — Récupération du dump depuis la prod…');
    setDetailSync(null);

    try {
      const token = localStorage.getItem('piemme_token');
      const rep1 = await fetch(`${PROD_URL}/admin/dump`, {
        headers: { Authorization: `Bearer ${token}` }
      });

      if (!rep1.ok) {
        setEnCours(false);
        setEtatSync('🔐 Token prod invalide. Entrez vos identifiants prod ci-dessous.');
        setCredsProd(p => ({ ...p, visible: true }));
        return;
      }

      const dump = await rep1.json();
      await _importerDump(dump);

    } catch (e) {
      setEtatSync(`❌ Erreur : ${e.message}`);
    } finally {
      setEnCours(false);
    }
  };

  const _importerDump = async (dump) => {
    setEtatSync('⏳ Étape 2/2 — Import dans la base locale…');
    const rep2 = await api.post('/admin/restore-dump', dump);
    const resultats = rep2.data.resultats || {};
    setDetailSync(resultats);
    const nbOk = Object.values(resultats).filter(v => v.includes('importées')).length;
    setEtatSync(`✅ Synchro terminée — ${nbOk} tables importées.`);
  };

  const lancerSyncAvecCreds = async () => {
    const { username, password } = credsProd;
    if (!username || !password) return;
    setCredsProd(p => ({ ...p, visible: false }));
    setEnCours(true);
    setEtatSync('🔐 Connexion à la prod…');
    try {
      const loginRep = await fetch(`${PROD_URL}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, mot_de_passe: password })
      });
      if (!loginRep.ok) { setEnCours(false); setEtatSync('❌ Connexion prod échouée.'); return; }
      const { access_token } = await loginRep.json();

      const rep1b = await fetch(`${PROD_URL}/admin/dump`, {
        headers: { Authorization: `Bearer ${access_token}` }
      });
      if (!rep1b.ok) { setEtatSync('❌ Impossible de récupérer le dump prod.'); return; }
      const dump = await rep1b.json();
      await _importerDump(dump);
    } catch (e) {
      setEtatSync(`❌ Erreur : ${e.message}`);
    } finally {
      setEnCours(false);
    }
  };

  // ── Changer mot de passe ─────────────────────────────────────────────────
  const changerMdp = async () => {
    setMdpMsg('');
    if (!mdpForm.username || !mdpForm.ancien || !mdpForm.nouveau) { setMdpMsg('❌ Remplis tous les champs.'); return; }
    if (mdpForm.nouveau !== mdpForm.nouveau2) { setMdpMsg('❌ Les nouveaux mots de passe ne correspondent pas.'); return; }
    try {
      await api.post('/auth/changer-mot-de-passe', { username: mdpForm.username, ancien: mdpForm.ancien, nouveau: mdpForm.nouveau });
      setMdpMsg('✅ Mot de passe modifié.');
      setMdpForm({ username: '', ancien: '', nouveau: '', nouveau2: '' });
    } catch (e) {
      setMdpMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  const resetMdp = async () => {
    setResetMsg('');
    if (!resetForm.username || !resetForm.nouveau) { setResetMsg('❌ Remplis tous les champs.'); return; }
    if (resetForm.nouveau !== resetForm.nouveau2) { setResetMsg('❌ Les nouveaux mots de passe ne correspondent pas.'); return; }
    if (!window.confirm(`Réinitialiser le mot de passe de "${resetForm.username}" ?`)) return;
    try {
      await api.post('/auth/reset-mot-de-passe', { username: resetForm.username, nouveau: resetForm.nouveau });
      setResetMsg('✅ Mot de passe réinitialisé.');
      setResetForm({ username: '', nouveau: '', nouveau2: '' });
    } catch (e) {
      setResetMsg('❌ ' + (e.response?.data?.detail || e.message));
    }
  };

  return (
    <div style={{ padding: '20px 24px', maxWidth: 700 }}>
      <h2 style={{ fontSize: 18, fontWeight: 700, marginBottom: 6 }}>⚙️ Administration — Piemme</h2>

      {/* Badge environnement */}
      <div style={{ marginBottom: 24 }}>
        {infoEnv ? (
          <span style={{
            display: 'inline-block',
            padding: '4px 12px',
            borderRadius: 20,
            fontSize: 12,
            fontWeight: 600,
            background: estLocal ? '#dcfce7' : '#fef3c7',
            color: estLocal ? '#16a34a' : '#d97706',
            border: `1px solid ${estLocal ? '#86efac' : '#fcd34d'}`
          }}>
            {estLocal ? `🖥️ Base locale — ${infoEnv.db}` : `☁️ Base production — Railway`}
          </span>
        ) : (
          <span style={{ fontSize: 12, color: '#aaa' }}>Chargement…</span>
        )}
      </div>

      {/* ── Carte Backup ── */}
      <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, padding: '16px 20px', marginBottom: 16 }}>
        <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 6 }}>💾 Backup complet</div>
        <div style={{ fontSize: 12, color: '#666', marginBottom: 12 }}>
          Télécharge un ZIP contenant le dump JSON de la base + le code source du backend.
        </div>
        <button onClick={lancerBackup}
          style={{ padding: '8px 18px', borderRadius: 7, border: '1px solid #6b21a8', background: '#6b21a8', color: 'white', fontWeight: 600, fontSize: 13, cursor: 'pointer' }}>
          💾 Télécharger le backup
        </button>
        {etatBackup && <span style={{ marginLeft: 12, fontSize: 12, color: '#666' }}>{etatBackup}</span>}
      </div>

      {/* ── Carte Synchro ── */}
      <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, padding: '16px 20px', marginBottom: 16 }}>
        <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 6 }}>⬇️ Synchroniser prod → local</div>
        <div style={{ fontSize: 12, color: '#666', marginBottom: 12 }}>
          Copie toutes les données de la base Railway (prod) dans ta base locale <code>piemme_local</code>.<br />
          <strong style={{ color: '#dc2626' }}>Attention :</strong> toutes les données locales seront écrasées.
          {!estLocal && <span style={{ display: 'block', marginTop: 6, color: '#dc2626', fontWeight: 600 }}>⛔ Disponible uniquement en environnement local.</span>}
        </div>
        <button onClick={lancerSync} disabled={enCours || !estLocal}
          style={{
            padding: '8px 18px', borderRadius: 7, border: '1px solid #1d4ed8',
            background: (!estLocal || enCours) ? '#e5e7eb' : '#1d4ed8',
            color: (!estLocal || enCours) ? '#aaa' : 'white',
            fontWeight: 600, fontSize: 13,
            cursor: (!estLocal || enCours) ? 'not-allowed' : 'pointer'
          }}>
          {enCours ? '⏳ En cours…' : '⬇️ Lancer la synchro'}
        </button>

        {etatSync && (
          <div style={{ marginTop: 12, fontSize: 13, color: etatSync.startsWith('✅') ? '#16a34a' : etatSync.startsWith('❌') ? '#dc2626' : '#555' }}>
            {etatSync}
          </div>
        )}

        {/* Formulaire credentials prod */}
        {credsProd.visible && (
          <div style={{ marginTop: 12, background: '#fef3c7', border: '1px solid #fcd34d', borderRadius: 8, padding: '12px 16px' }}>
            <div style={{ fontSize: 12, fontWeight: 600, color: '#92400e', marginBottom: 8 }}>Identifiants de production</div>
            <input type="text" placeholder="Identifiant prod"
              value={credsProd.username}
              onChange={e => setCredsProd(p => ({ ...p, username: e.target.value }))}
              style={{ display: 'block', width: '100%', marginBottom: 6, padding: '6px 10px', borderRadius: 6, border: '1px solid #fcd34d', fontSize: 13, boxSizing: 'border-box' }}
            />
            <input type="password" placeholder="Mot de passe prod"
              value={credsProd.password}
              onChange={e => setCredsProd(p => ({ ...p, password: e.target.value }))}
              onKeyDown={e => { if (e.key === 'Enter') lancerSyncAvecCreds(); }}
              style={{ display: 'block', width: '100%', marginBottom: 10, padding: '6px 10px', borderRadius: 6, border: '1px solid #fcd34d', fontSize: 13, boxSizing: 'border-box' }}
            />
            <div style={{ display: 'flex', gap: 8 }}>
              <button onClick={lancerSyncAvecCreds}
                style={{ padding: '7px 16px', borderRadius: 6, border: '1px solid #1d4ed8', background: '#1d4ed8', color: 'white', fontWeight: 600, fontSize: 12, cursor: 'pointer' }}>
                Se connecter et synchroniser
              </button>
              <button onClick={() => { setCredsProd({ username: '', password: '', visible: false }); setEtatSync(''); }}
                style={{ padding: '7px 16px', borderRadius: 6, border: '1px solid #ddd', background: 'white', color: '#555', fontWeight: 600, fontSize: 12, cursor: 'pointer' }}>
                Annuler
              </button>
            </div>
          </div>
        )}

        {detailSync && (
          <div style={{ marginTop: 12, maxHeight: 260, overflowY: 'auto', border: '1px solid #e5e7eb', borderRadius: 6, padding: 10 }}>
            <table style={{ width: '100%', fontSize: 11, borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ background: '#f9f9f7' }}>
                  <th style={{ textAlign: 'left', padding: '4px 8px', borderBottom: '1px solid #ddd' }}>Table</th>
                  <th style={{ textAlign: 'left', padding: '4px 8px', borderBottom: '1px solid #ddd' }}>Résultat</th>
                </tr>
              </thead>
              <tbody>
                {Object.entries(detailSync).map(([table, res]) => (
                  <tr key={table}>
                    <td style={{ padding: '3px 8px', fontFamily: 'monospace', color: '#555' }}>{table}</td>
                    <td style={{ padding: '3px 8px', color: res.includes('importées') ? '#16a34a' : '#d97706' }}>{res}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* ── Carte Gestion mots de passe ── */}
      <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, padding: '16px 20px', marginBottom: 16 }}>
        <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 12 }}>🔑 Gestion des mots de passe</div>

        {/* Changer son propre MDP */}
        <div style={{ marginBottom: 16 }}>
          <div style={{ fontSize: 12, fontWeight: 600, color: '#444', marginBottom: 8 }}>Changer un mot de passe (ancien requis)</div>
          <input type="text"
            placeholder="Identifiant"
            value={mdpForm.username}
            onChange={e => setMdpForm(p => ({ ...p, username: e.target.value }))}
            style={{ display: 'block', width: '100%', marginBottom: 6, padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
          />
          {[
            { f: 'ancien', label: 'Ancien mot de passe' },
            { f: 'nouveau', label: 'Nouveau mot de passe' },
            { f: 'nouveau2', label: 'Confirmer nouveau' }
          ].map(({ f, label }) => (
            <div key={f} style={{ position: 'relative', marginBottom: 6 }}>
              <input type={showMdp[f] ? 'text' : 'password'}
                placeholder={label}
                value={mdpForm[f]}
                onChange={e => setMdpForm(p => ({ ...p, [f]: e.target.value }))}
                style={{ display: 'block', width: '100%', padding: '6px 36px 6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
              />
              <button type="button" onClick={() => setShowMdp(p => ({ ...p, [f]: !p[f] }))}
                style={{ position: 'absolute', right: 8, top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', fontSize: 15, color: '#888', padding: 0 }}>
                {showMdp[f] ? '🙈' : '👁️'}
              </button>
            </div>
          ))}
          <button onClick={changerMdp}
            style={{ padding: '7px 16px', borderRadius: 6, border: '1px solid #1d4ed8', background: '#1d4ed8', color: 'white', fontWeight: 600, fontSize: 12, cursor: 'pointer' }}>
            Changer le mot de passe
          </button>
          {mdpMsg && <div style={{ marginTop: 8, fontSize: 12, color: mdpMsg.startsWith('✅') ? '#16a34a' : '#dc2626' }}>{mdpMsg}</div>}
        </div>

        <hr style={{ border: 'none', borderTop: '1px solid #f0f0ee', margin: '12px 0' }} />

        {/* Réinitialisation admin (sans ancien) */}
        <div>
          <div style={{ fontSize: 12, fontWeight: 600, color: '#444', marginBottom: 8 }}>Réinitialiser un mot de passe (admin — sans ancien)</div>
          <input type="text"
            placeholder="Identifiant"
            value={resetForm.username}
            onChange={e => setResetForm(p => ({ ...p, username: e.target.value }))}
            style={{ display: 'block', width: '100%', marginBottom: 6, padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
          />
          {[
            { f: 'nouveau', label: 'Nouveau mot de passe' },
            { f: 'nouveau2', label: 'Confirmer nouveau' }
          ].map(({ f, label }) => (
            <div key={f} style={{ position: 'relative', marginBottom: 6 }}>
              <input type={showReset[f] ? 'text' : 'password'}
                placeholder={label}
                value={resetForm[f]}
                onChange={e => setResetForm(p => ({ ...p, [f]: e.target.value }))}
                style={{ display: 'block', width: '100%', padding: '6px 36px 6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 13, boxSizing: 'border-box' }}
              />
              <button type="button" onClick={() => setShowReset(p => ({ ...p, [f]: !p[f] }))}
                style={{ position: 'absolute', right: 8, top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', fontSize: 15, color: '#888', padding: 0 }}>
                {showReset[f] ? '🙈' : '👁️'}
              </button>
            </div>
          ))}
          <button onClick={resetMdp}
            style={{ padding: '7px 16px', borderRadius: 6, border: '1px solid #dc2626', background: '#dc2626', color: 'white', fontWeight: 600, fontSize: 12, cursor: 'pointer' }}>
            Réinitialiser
          </button>
          {resetMsg && <div style={{ marginTop: 8, fontSize: 12, color: resetMsg.startsWith('✅') ? '#16a34a' : '#dc2626' }}>{resetMsg}</div>}
        </div>
      </div>

      {/* ── Carte Utilisateurs ── */}
      <div style={{ background: 'white', border: '1px solid #e5e5e0', borderRadius: 10, padding: '16px 20px' }}>
        <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 12 }}>👥 Utilisateurs</div>

        {loadingUsers ? (
          <div style={{ fontSize: 12, color: '#aaa' }}>Chargement…</div>
        ) : (
          <table style={{ width: '100%', fontSize: 12, borderCollapse: 'collapse', marginBottom: 16 }}>
            <thead>
              <tr style={{ background: '#f9f9f7' }}>
                <th style={{ textAlign: 'left', padding: '6px 8px', borderBottom: '1px solid #e5e5e0' }}>Identifiant</th>
                <th style={{ textAlign: 'left', padding: '6px 8px', borderBottom: '1px solid #e5e5e0' }}>Rôle</th>
                <th style={{ textAlign: 'left', padding: '6px 8px', borderBottom: '1px solid #e5e5e0' }}>Actif</th>
                <th style={{ padding: '6px 8px', borderBottom: '1px solid #e5e5e0' }}></th>
              </tr>
            </thead>
            <tbody>
              {utilisateurs.map(u => (
                <tr key={u.id} style={{ borderBottom: '1px solid #f0f0ee' }}>
                  <td style={{ padding: '6px 8px', fontWeight: 500 }}>{u.username}</td>
                  <td style={{ padding: '6px 8px' }}>
                    <select
                      value={u.role}
                      onChange={e => changerRole(u, e.target.value)}
                      style={{ fontSize: 12, borderRadius: 5, border: '1px solid #ddd', padding: '2px 6px', background: u.role === 'admin' ? '#ede9fe' : '#f0fdf4', color: u.role === 'admin' ? '#6b21a8' : '#16a34a', fontWeight: 600 }}
                    >
                      <option value="admin">admin</option>
                    </select>
                  </td>
                  <td style={{ padding: '6px 8px' }}>
                    <button
                      onClick={() => toggleActif(u)}
                      style={{ fontSize: 11, padding: '2px 8px', borderRadius: 5, border: '1px solid', cursor: 'pointer', fontWeight: 600, background: u.actif ? '#dcfce7' : '#fee2e2', color: u.actif ? '#16a34a' : '#dc2626', borderColor: u.actif ? '#86efac' : '#fca5a5' }}
                    >
                      {u.actif ? 'Actif' : 'Inactif'}
                    </button>
                  </td>
                  <td style={{ padding: '6px 8px', textAlign: 'right' }}>
                    <button
                      onClick={() => supprimerUtilisateur(u)}
                      title="Supprimer ce compte"
                      style={{ fontSize: 13, background: 'none', border: 'none', cursor: 'pointer', color: '#dc2626', padding: '2px 4px' }}
                    >
                      🗑️
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        <hr style={{ border: 'none', borderTop: '1px solid #f0f0ee', margin: '12px 0' }} />

        <div style={{ fontSize: 12, fontWeight: 600, color: '#444', marginBottom: 8 }}>Créer un compte</div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center', marginBottom: 8 }}>
          <input
            type="text"
            placeholder="Identifiant"
            value={nouvelUser.username}
            onChange={e => setNouvelUser(p => ({ ...p, username: e.target.value }))}
            style={{ flex: 1, minWidth: 100, padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12 }}
          />
          <div style={{ position: 'relative', flex: 1, minWidth: 120 }}>
            <input
              type={showNouvelUserMdp ? 'text' : 'password'}
              placeholder="Mot de passe"
              value={nouvelUser.mot_de_passe}
              onChange={e => setNouvelUser(p => ({ ...p, mot_de_passe: e.target.value }))}
              style={{ width: '100%', padding: '6px 32px 6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12, boxSizing: 'border-box' }}
            />
            <button type="button" onClick={() => setShowNouvelUserMdp(v => !v)}
              style={{ position: 'absolute', right: 6, top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', fontSize: 13, color: '#888', padding: 0 }}>
              {showNouvelUserMdp ? '🙈' : '👁️'}
            </button>
          </div>
          <select
            value={nouvelUser.role}
            onChange={e => setNouvelUser(p => ({ ...p, role: e.target.value }))}
            style={{ padding: '6px 10px', borderRadius: 6, border: '1px solid #ddd', fontSize: 12 }}
          >
            <option value="admin">admin</option>
          </select>
          <button
            onClick={creerUtilisateur}
            style={{ padding: '6px 14px', borderRadius: 6, border: '1px solid #16a34a', background: '#16a34a', color: 'white', fontWeight: 600, fontSize: 12, cursor: 'pointer', whiteSpace: 'nowrap' }}
          >
            + Créer
          </button>
        </div>
        {userMsg && <div style={{ fontSize: 12, color: userMsg.startsWith('✅') ? '#16a34a' : '#dc2626', marginTop: 4 }}>{userMsg}</div>}
      </div>

    </div>
  );
}
