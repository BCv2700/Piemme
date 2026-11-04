import { useState, useEffect, useCallback, useRef } from 'react';
import api from '../api/api';

const MOIS = ['','Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
const JS = ['L','M','M','J','V','S','D'];
const fmt = (n) => Number(n||0).toFixed(2);

export default function PiemmeMensuel() {
  const now = new Date();
  const [annee, setAnnee] = useState(now.getFullYear());
  const [mois, setMois] = useState(now.getMonth()+1);
  const [data, setData] = useState(null);
  const [editCell, setEditCell] = useState(null);
  const [editVal, setEditVal] = useState('');
  const [onglet, setOnglet] = useState('calendrier');

  const charger = useCallback(async () => {
    try { setData((await api.get(`/piemme/mois/${annee}/${mois}`)).data); } catch(e) { console.error(e); }
  }, [annee, mois]);
  useEffect(() => { charger(); }, [charger]);

  const nav = (d) => { let m=mois+d, a=annee; if(m>12){m=1;a++} if(m<1){m=12;a--} setMois(m);setAnnee(a);setEditCell(null); };
  const getJ = (d) => data?.jours.find(j=>j.jour===d);
  const sauver = async (jour, field, value) => {
    const ds=`${annee}-${String(mois).padStart(2,'0')}-${String(jour).padStart(2,'0')}`;
    const e=getJ(jour);
    await api.post('/piemme/jour',{date:ds,recette:field==='recette'?(parseFloat(value)||0):(e?.recette||0),depense:field==='depense'?(parseFloat(value)||0):(e?.depense||0)});
    setEditCell(null); charger();
  };

  const buildWeeks = () => {
    if(!data) return [];
    const fd=new Date(annee,mois-1,1).getDay(), off=fd===0?6:fd-1, nb=data.nb_jours;
    const ws=[]; let w=Array(7).fill(null);
    for(let d=1;d<=nb;d++){const p=(off+d-1)%7;if(d>1&&p===0){ws.push(w);w=Array(7).fill(null)}w[p]=d}
    ws.push(w); return ws;
  };

  const pct=data?.pct_economie||15, r=data?.resume||{}, e=data?.enveloppes||{}, weeks=buildWeeks();
  const role = localStorage.getItem('piemme_role');
  const isLocal = (import.meta.env.VITE_API_URL||'').includes('localhost');

  const getPdf = async (url, filename, inline=false) => {
    const base = import.meta.env.VITE_API_URL || 'http://localhost:8001';
    const token = localStorage.getItem('piemme_token');
    const rep = await fetch(`${base}${url}`, { headers: { Authorization: `Bearer ${token}` } });
    if (!rep.ok) return;
    const blob = await rep.blob();
    const objUrl = URL.createObjectURL(blob);
    if (inline) {
      window.open(objUrl, '_blank');
      setTimeout(() => URL.revokeObjectURL(objUrl), 60000);
    } else {
      const a = document.createElement('a'); a.href = objUrl; a.download = filename;
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      URL.revokeObjectURL(objUrl);
    }
  };

  return (
    <div style={{padding:'0.25rem 0.5rem'}}>
      <div style={{display:'flex',gap:4,marginBottom:4,alignItems:'center',flexWrap:'wrap'}}>
        {[{id:'calendrier',l:'Calendrier'},{id:'graphique_mois',l:'📈 Mois'},{id:'graphique_annuel',l:'📈 Année'},{id:'depenses_mois',l:'Dépenses'},{id:'factures',l:'Factures'},{id:'annuel',l:'Année'},{id:'tva',l:'TVA'},{id:'depenses',l:'Récurr.'},{id:'enveloppes',l:'Enveloppes'}].map(o=>(
          <button key={o.id} onClick={()=>setOnglet(o.id)} style={{padding:'3px 8px',borderRadius:4,border:'none',fontSize:10,fontWeight:onglet===o.id?700:400,background:onglet===o.id?'#1d4ed8':'#e5e7eb',color:onglet===o.id?'white':'#555',cursor:'pointer'}}>{o.l}</button>
        ))}
        {isLocal && <span style={{padding:'2px 7px',borderRadius:4,background:'#fef3c7',color:'#92400e',fontSize:10,fontWeight:700,border:'1px solid #fcd34d',letterSpacing:'0.05em'}}>LOCAL</span>}
        {role==='admin' && <button onClick={()=>window.location.href='/administration'} style={{padding:'3px 8px',borderRadius:4,border:'1px solid #6b7280',fontSize:10,background:'white',color:'#374151',cursor:'pointer',fontWeight:600}}>⚙️ Admin</button>}
        <button onClick={()=>nav(-1)} style={sNav}>◀</button>
        <span style={{fontSize:12,fontWeight:700,color:'#0D1B2A',minWidth:90,textAlign:'center'}}>{MOIS[mois]} {annee}</span>
        <button onClick={()=>nav(1)} style={sNav}>▶</button>
        <button onClick={()=>getPdf(`/piemme/mois/${annee}/${mois}/pdf?inline=true`,``,true)} style={{padding:'3px 8px',borderRadius:4,border:'1px solid #1d4ed8',fontSize:10,background:'white',color:'#1d4ed8',cursor:'pointer',fontWeight:600}}>👁 Mois</button>
        <button onClick={()=>getPdf(`/piemme/mois/${annee}/${mois}/pdf`,`piemme_${annee}_${String(mois).padStart(2,'0')}.pdf`)} style={{padding:'3px 8px',borderRadius:4,border:'1px solid #1d4ed8',fontSize:10,background:'#1d4ed8',color:'white',cursor:'pointer',fontWeight:600}}>⬇ Mois</button>
        <button onClick={()=>getPdf(`/piemme/annuel/${annee}/pdf?inline=true`,``,true)} style={{padding:'3px 8px',borderRadius:4,border:'1px solid #d97706',fontSize:10,background:'white',color:'#d97706',cursor:'pointer',fontWeight:600}}>👁 Année</button>
        <button onClick={()=>getPdf(`/piemme/annuel/${annee}/pdf`,`piemme_annuel_${annee}.pdf`)} style={{padding:'3px 8px',borderRadius:4,border:'1px solid #d97706',fontSize:10,background:'#d97706',color:'white',cursor:'pointer',fontWeight:600}}>⬇ Année</button>
      </div>

      {onglet==='calendrier' && data && <>
        <div style={{fontSize:13,padding:'5px 10px',marginBottom:6,background:'#f9fafb',borderRadius:4,display:'flex',gap:10,flexWrap:'wrap',alignItems:'center'}}>
          <span>Rec: <b style={{color:'#16a34a'}}>{fmt(r.total_recettes)}€</b></span>
          <span>Dép: <b style={{color:'#dc2626'}}>{fmt(r.total_depenses)}€</b></span>
          <span>TVA: <b style={{color:'#d97706'}}>{fmt(r.total_tva)}€</b></span>
          <span>Bénéf: <b style={{color:r.benefice>=0?'#16a34a':'#dc2626'}}>{fmt(r.benefice)}€</b></span>
          <span style={{color:'#aaa'}}>|</span>
          <span style={{color:'#666',fontSize:12}}>D/j:{fmt(e.depenses)} TVA:{fmt(e.tva)} Ép({pct}%):{fmt(e.economie)} Réc/j:{fmt(e.recurrentes)}</span>
        </div>
        <div style={{flex:'1 1 auto',minWidth:0}}>
          <table style={{borderCollapse:'collapse',fontSize:10,tableLayout:'fixed',width:'auto'}}>
            <colgroup>
              <col style={{width:40}} />
              {JS.map((_,i)=><col key={i} style={{width:80}} />)}
              <col style={{width:70}} /><col style={{width:70}} /><col style={{width:70}} /><col style={{width:70}} />
            </colgroup>
            {weeks.map((week,wi)=>{
              const wj=week.filter(Boolean);
              const wR=wj.reduce((s,d)=>s+(getJ(d)?.recette||0),0);
              const wD=wj.reduce((s,d)=>s+(getJ(d)?.depense||0),0);
              const wTva=wR*0.21, wEp=wR*pct/100;
              return (
                <tbody key={wi}>
                  <tr style={{background:'#eef2f7'}}>
                    <td style={sH}></td>
                    {week.map((d,i)=><td key={i} style={sH}>{d?`${JS[i]}${d}`:''}</td>)}
                    <td style={{...sH,background:'#fff',borderLeft:'2px solid #aaa'}} rowSpan={3}><EnvBadge label="Recette" val={wR} color="#16a34a" /></td>
                    <td style={{...sH,background:'#fff'}} rowSpan={3}><EnvBadge label="TVA" val={wTva} color="#d97706" /></td>
                    <td style={{...sH,background:'#fff'}} rowSpan={3}><EnvBadge label="Dép" val={wD} color="#dc2626" /></td>
                    <td style={{...sH,background:'#fff'}} rowSpan={3}><EnvBadge label="Ép" val={wEp} color="#2563eb" /></td>
                  </tr>
                  <tr>
                    <td style={{...sL,color:'#16a34a'}}>Rec.</td>
                    {week.map((d,i)=>(
                      <td key={i} style={sV} onClick={()=>d&&setEditCell({jour:d,field:'recette'})}>
                        {d?<Cell j={d} f="recette" e={getJ(d)} ec={editCell} ev={editVal} sev={setEditVal} save={sauver}/>:''}
                      </td>
                    ))}
                  </tr>
                  <tr style={{borderBottom:'1px solid #ccc'}}>
                    <td style={{...sL,color:'#dc2626'}}>Dép.</td>
                    {week.map((d,i)=>(
                      <td key={i} style={{...sV,cursor:'default',background:'#fefefe'}}>
                        {d?<span style={{color:getJ(d)?.depense>0?'#dc2626':'#ccc',fontSize:14}}>{getJ(d)?.depense>0?fmt(getJ(d).depense):'—'}</span>:''}
                      </td>
                    ))}
                  </tr>
                </tbody>
              );
            })}
          </table>
          <div style={{marginTop:6,fontSize:10,display:'flex',alignItems:'center',gap:6}}>
            <span>% épargne :</span>
            <input type="number" step="0.5" value={pct}
              onChange={ev=>api.post('/piemme/config',{annee,mois,pct_economie:parseFloat(ev.target.value)||15}).then(charger)}
              style={{width:45,padding:'2px 4px',border:'1px solid #ddd',borderRadius:3,fontSize:10}} />%
          </div>
        </div>
      </>}

      {onglet==='graphique_mois' && <GraphiqueMois annee={annee} moisActif={mois} dataMois={data} />}
      {onglet==='graphique_annuel' && <GraphiqueAnnuel annee={annee} moisActif={mois} />}
      {onglet==='depenses_mois' && data && <DepensesMois data={data} annee={annee} mois={mois} onSaved={charger} />}
      {onglet==='factures' && <FacturesEnRetard onPaye={charger} />}
      {onglet==='tva' && data && <TVA data={data} />}
      {onglet==='annuel' && <Annuel annee={annee} />}
      {onglet==='depenses' && <Recurrentes onSaved={charger} />}
      {onglet==='enveloppes' && <Enveloppes />}
    </div>
  );
}

function DepensesMois({ data, annee, mois, onSaved }) {
  const [newJour, setNewJour] = useState(String(new Date().getDate()));
  const [newMontant, setNewMontant] = useState('');
  const [newLibelle, setNewLibelle] = useState('');
  const [editId, setEditId] = useState(null);
  const [editField, setEditField] = useState(null);
  const [editVal, setEditVal] = useState('');
  const [coefficients, setCoefficients] = useState({});
  const [lastCoeffs, setLastCoeffs] = useState({});
  const [refreshTva, setRefreshTva] = useState(0);
  const [confirmId, setConfirmId] = useState(null);
  const dblClickCoeff = useRef(false);

  const getCoeff = (id) => coefficients[id] ?? 1;
  const setCoeff = (id, val) => {
    if (val !== 1) setLastCoeffs(prev => ({ ...prev, [id]: val }));
    setCoefficients(prev => ({ ...prev, [id]: val }));
  };

  const details = (data?.depense_details || []).sort((a, b) => a.jour - b.jour || a.id - b.id);
  const total = details.reduce((s, d) => s + d.montant, 0);

  useEffect(() => {
    const init = {};
    (data?.depense_details || []).forEach(d => {
      init[d.id] = (d.coefficient && d.coefficient !== 1) ? d.coefficient : (coefficients[d.id] ?? 1);
    });
    setCoefficients(init);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  const ajouter = async () => {
    const j = parseInt(newJour);
    if (!j || j < 1 || j > 31) return alert('Jour invalide (1-31)');
    const m = parseFloat(newMontant);
    if (!m || m <= 0) return alert('Montant requis et > 0');
    const ds = annee + '-' + String(mois).padStart(2,'0') + '-' + String(j).padStart(2,'0');
    try {
      await api.post('/piemme/depense-detail', { date: ds, montant: m, libelle: newLibelle.trim() });
      setNewJour(String(new Date().getDate())); setNewMontant(''); setNewLibelle('');
      onSaved();
    } catch (e) { alert(e.response?.data?.detail || e.message || 'Erreur ajout'); }
  };

  const modifier = async (id, champ, valeur) => {
    try {
      await api.post('/piemme/depense-detail/' + id + '/modifier', { [champ]: valeur });
      setEditId(null); setEditField(null); onSaved();
    } catch (e) { alert(e.response?.data?.detail || e.message || 'Erreur modification'); }
  };

  const toggleCoeff = (id) => {
    const current = getCoeff(id);
    const next = current <= 1 ? (lastCoeffs[id] ?? 3.28) : 1;
    setCoeff(id, next); modifier(id, 'coefficient', next); setRefreshTva(v => v + 1);
  };

  const supprimer = async (id) => {
    try { await api.delete('/piemme/depense-detail/' + id); onSaved(); }
    catch (e) { console.error(e); }
    setConfirmId(null);
  };

  const clicSupprimer = (id) => {
    if (confirmId === id) { supprimer(id); }
    else { setConfirmId(id); setTimeout(() => setConfirmId(prev => prev === id ? null : prev), 3000); }
  };

  const startEdit = (id, field, val) => { setEditId(id); setEditField(field); setEditVal(String(val || '')); };
  const stopEdit = () => { setEditId(null); setEditField(null); };
  const isEditing = (id, field) => editId === id && editField === field;

  const saveJour = (id, val) => {
    const j = parseInt(val);
    if (!j || j < 1 || j > 31) { stopEdit(); return; }
    modifier(id, 'date', annee + '-' + String(mois).padStart(2,'0') + '-' + String(j).padStart(2,'0'));
  };

  const parLibelle = {};
  details.forEach(d => { const key = d.libelle || 'Sans libellé'; parLibelle[key] = (parLibelle[key] || 0) + d.montant; });
  const recapEntries = Object.entries(parLibelle).sort((a, b) => b[1] - a[1]);
  const lignesAvecCoeff = details.filter(d => getCoeff(d.id) > 1);
  const totalAvecCoeff = lignesAvecCoeff.reduce((s, d) => s + d.montant * getCoeff(d.id), 0);
  const tvaEstimee = totalAvecCoeff * 0.21;
  const totalTvaPaye = lignesAvecCoeff.reduce((s, d) => s + d.montant * 0.21, 0);

  const sEdit = {fontSize:10,padding:'1px 2px',border:'1px solid #93c5fd',borderRadius:2,boxSizing:'border-box'};

  return (
    <div style={{background:'#fafafa',borderRadius:6,padding:10,border:'1px solid #e5e7eb',width:'fit-content'}}>
      <div style={{marginBottom:6}}>
        <span style={{fontSize:11,fontWeight:700,color:'#0D1B2A'}}>Dépenses du mois </span>
        <span style={{fontSize:11,fontWeight:700,color:'#dc2626'}}>{fmt(total)}€</span>
      </div>
      <div style={{display:'flex',gap:3,marginBottom:8}}>
        <input type="number" min="1" max="31" placeholder="Jr" value={newJour} onChange={e=>setNewJour(e.target.value)}
          style={{width:35,padding:'2px 4px',fontSize:10,border:'1px solid #ccc',borderRadius:3,textAlign:'center'}} />
        <input type="number" step="0.01" placeholder="€" value={newMontant} onChange={e=>setNewMontant(e.target.value)}
          style={{width:55,padding:'2px 4px',fontSize:10,border:'1px solid #ccc',borderRadius:3}} />
        <input placeholder="Libellé" value={newLibelle} onChange={e=>setNewLibelle(e.target.value)}
          onKeyDown={e=>{if(e.key==='Enter') ajouter()}}
          style={{width:160,padding:'2px 4px',fontSize:10,border:'1px solid #ccc',borderRadius:3}} />
        <button onClick={ajouter}
          style={{padding:'3px 8px',borderRadius:4,border:'none',background:'#1d4ed8',color:'white',fontSize:10,cursor:'pointer',fontWeight:600}}>+</button>
      </div>
      {details.length === 0 ? <p style={{fontSize:11,color:'#aaa',margin:0}}>Aucune dépense ce mois.</p> : (<>
        <div style={{display:'flex',gap:16,alignItems:'flex-start'}}>
          <table style={{borderCollapse:'collapse',width:'auto',fontSize:11}}>
            <thead>
              <tr style={{background:'#0D1B2A',color:'white'}}>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'center'}}>Jr</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'right'}}>Montant</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'left'}}>Libellé</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'center'}}>Coeff</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'right'}}>Mont.×coeff</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'right',color:'#d97706'}}>TVA à payer</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'right',color:'#16a34a'}}>TVA déjà payée</th>
                <th style={{padding:'1px 4px',fontSize:9,fontWeight:600,textAlign:'center'}}>Payé</th>
                <th style={{padding:'1px 2px',fontSize:9}}></th>
              </tr>
            </thead>
            <tbody>
              {details.map((d, idx) => (
                <tr key={d.id} style={{background:idx%2?'#f9fafb':'white'}}>
                  <td style={{padding:'0px 4px',fontWeight:600,color:'#555',textAlign:'center',cursor:'pointer',fontSize:10}}>
                    {isEditing(d.id,'jour') ? (
                      <input type="number" min="1" max="31" autoFocus value={editVal}
                        onChange={e=>setEditVal(e.target.value)}
                        onBlur={()=>saveJour(d.id, editVal)}
                        onKeyDown={e=>{if(e.key==='Enter')saveJour(d.id,editVal);if(e.key==='Escape')stopEdit()}}
                        style={{...sEdit,width:30,textAlign:'center'}} />
                    ) : <span onClick={()=>startEdit(d.id,'jour',d.jour)}>{String(d.jour).padStart(2,'0')}</span>}
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'right',color:'#dc2626',fontWeight:600,cursor:'pointer',fontSize:10}}>
                    {isEditing(d.id,'montant') ? (
                      <input type="number" step="0.01" autoFocus value={editVal}
                        onChange={e=>setEditVal(e.target.value)}
                        onBlur={()=>{ const v=parseFloat(editVal); if(v>0) modifier(d.id,'montant',v); else stopEdit(); }}
                        onKeyDown={e=>{if(e.key==='Enter'){const v=parseFloat(editVal);if(v>0)modifier(d.id,'montant',v);else stopEdit();}if(e.key==='Escape')stopEdit()}}
                        style={{...sEdit,width:55,textAlign:'right'}} />
                    ) : <span onClick={()=>startEdit(d.id,'montant',d.montant)}>{fmt(d.montant)}€</span>}
                  </td>
                  <td style={{padding:'0px 4px',color:'#333',cursor:'pointer',fontSize:10}}>
                    {isEditing(d.id,'libelle') ? (
                      <input type="text" autoFocus value={editVal}
                        onChange={e=>setEditVal(e.target.value)}
                        onBlur={()=>{ modifier(d.id,'libelle',editVal); }}
                        onKeyDown={e=>{if(e.key==='Enter')modifier(d.id,'libelle',editVal);if(e.key==='Escape')stopEdit()}}
                        style={{...sEdit,width:'100%'}} />
                    ) : <span onClick={()=>startEdit(d.id,'libelle',d.libelle)}>{d.libelle || '—'}</span>}
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'center',fontSize:10}}>
                    <input type="number" min={0.01} step={0.01} value={getCoeff(d.id)}
                      onChange={e=>setCoeff(d.id, parseFloat(e.target.value)||1)}
                      onBlur={e=>{ if(dblClickCoeff.current){dblClickCoeff.current=false;return;} const v=parseFloat(e.target.value)||1; modifier(d.id,'coefficient',v); setRefreshTva(p=>p+1); }}
                      onDoubleClick={()=>{ dblClickCoeff.current=true; toggleCoeff(d.id); }}
                      style={{width:44,textAlign:'center',padding:'1px 2px',fontSize:10,border:'1px solid #ddd',borderRadius:2}} />
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'right',color:'#dc2626',fontWeight:500,fontSize:10}}>
                    {getCoeff(d.id) !== 1 ? `${(d.montant*getCoeff(d.id)).toFixed(2)}€` : '—'}
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'right',color:'#d97706',fontWeight:500,fontSize:10}}>
                    {getCoeff(d.id) > 1 ? `${(d.montant*getCoeff(d.id)*0.21).toFixed(2)}€` : '—'}
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'right',color:'#16a34a',fontWeight:500,fontSize:10}}>
                    {getCoeff(d.id) > 1 ? `${(d.montant*0.21).toFixed(2)}€` : '—'}
                  </td>
                  <td style={{padding:'0px 4px',textAlign:'center',fontSize:10}}>
                    <input type="checkbox" checked={!!d.paye} onChange={()=>modifier(d.id,'paye',!d.paye)}
                      style={{cursor:'pointer',accentColor:'#16a34a'}} />
                  </td>
                  <td style={{padding:'0px 2px',textAlign:'center'}}>
                    <button onClick={()=>clicSupprimer(d.id)}
                      style={{background:confirmId===d.id?'#dc2626':'none',color:confirmId===d.id?'white':'#dc2626',border:'none',borderRadius:4,cursor:'pointer',fontSize:confirmId===d.id?9:14,fontWeight:confirmId===d.id?700:400,padding:'2px 4px',minWidth:20,whiteSpace:'nowrap'}}>
                      {confirmId===d.id?'OK ?':'×'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {recapEntries.length > 0 && (
            <div style={{borderLeft:'1px solid #ddd',paddingLeft:12,minWidth:160}}>
              <div style={{fontSize:10,fontWeight:700,color:'#0D1B2A',marginBottom:3}}>Récapitulatif</div>
              {recapEntries.map(([lib, tot]) => (
                <div key={lib} style={{display:'flex',justifyContent:'space-between',gap:12,fontSize:10,padding:'1px 0'}}>
                  <span style={{color:'#555'}}>{lib}</span>
                  <span style={{color:'#dc2626',fontWeight:600}}>{fmt(tot)}€</span>
                </div>
              ))}
            </div>
          )}
        </div>
        {lignesAvecCoeff.length > 0 && (
          <div style={{marginTop:10,padding:'7px 12px',background:'#fffbe6',border:'1px solid #ffe58f',borderRadius:6,fontSize:11,color:'#7a5c00',display:'inline-block'}}>
            <div style={{fontWeight:600,marginBottom:3}}>Estimation charges (lignes coeff &gt; 1)</div>
            <div style={{display:'flex',gap:20,flexWrap:'wrap'}}>
              <span>Base×coeff : <strong>{totalAvecCoeff.toFixed(2)}€</strong></span>
              <span style={{color:'#d97706'}}>TVA à payer : <strong>{tvaEstimee.toFixed(2)}€</strong></span>
              <span style={{color:'#16a34a'}}>TVA déjà payée : <strong>{totalTvaPaye.toFixed(2)}€</strong></span>
            </div>
          </div>
        )}
      </>)}
      <div style={{marginTop:16}}>
        <TVATrimestre annee={annee} moisActif={mois} refreshTva={refreshTva} />
      </div>
    </div>
  );
}

function TVATrimestre({ annee, moisActif, refreshTva }) {
  const trimestreActif = Math.ceil(moisActif / 3);
  const [trimestre, setTrimestre] = useState(trimestreActif);
  const [anneeT, setAnneeT] = useState(annee);
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const labels = { 1:'Jan–Mar', 2:'Avr–Jun', 3:'Jul–Sep', 4:'Oct–Déc' };

  useEffect(() => { setTrimestre(trimestreActif); setAnneeT(annee); }, [annee, trimestreActif]);
  useEffect(() => {
    setLoading(true);
    api.get(`/piemme/trimestre/${anneeT}/${trimestre}`)
      .then(r => { setData(r.data); setLoading(false); })
      .catch(() => { setData(null); setLoading(false); });
  }, [anneeT, trimestre, refreshTva]);

  return (
    <div style={{background:'#f0fdf4',border:'1px solid #86efac',borderRadius:6,padding:'8px 12px',display:'inline-block',minWidth:320,fontSize:11}}>
      <div style={{fontWeight:700,color:'#15803d',marginBottom:6,fontSize:12}}>TVA trimestrielle</div>
      <div style={{display:'flex',gap:6,alignItems:'center',marginBottom:8,flexWrap:'wrap'}}>
        <span style={{fontSize:10,color:'#555'}}>Année :</span>
        <input type="number" value={anneeT} onChange={e=>setAnneeT(parseInt(e.target.value)||annee)}
          style={{width:55,fontSize:10,padding:'1px 4px',border:'1px solid #ccc',borderRadius:3}} />
        {[1,2,3,4].map(t=>(
          <button key={t} onClick={()=>setTrimestre(t)}
            style={{padding:'2px 8px',borderRadius:4,border:'none',fontSize:10,fontWeight:t===trimestre?700:400,background:t===trimestre?'#15803d':'#e5e7eb',color:t===trimestre?'white':'#555',cursor:'pointer'}}>
            T{t} {labels[t]}
          </button>
        ))}
      </div>
      {loading && <span style={{fontSize:10,color:'#aaa'}}>Chargement…</span>}
      {!loading && data && (
        <>
          <table style={{borderCollapse:'collapse',fontSize:10,marginBottom:8}}>
            <thead><tr style={{background:'#0D1B2A',color:'white'}}>
              <th style={{padding:'2px 8px',textAlign:'left'}}>Mois</th>
              <th style={{padding:'2px 8px',textAlign:'right',color:'#fbbf24'}}>TVA à payer</th>
              <th style={{padding:'2px 8px',textAlign:'right',color:'#86efac'}}>TVA déjà payée</th>
            </tr></thead>
            <tbody>{(data.mois||[]).map((m,i)=>(
              <tr key={m.mois} style={{background:i%2?'#f0fdf4':'white'}}>
                <td style={{padding:'1px 8px',color:'#374151'}}>{m.label}</td>
                <td style={{padding:'1px 8px',textAlign:'right',color:'#d97706',fontWeight:600}}>{m.tva_a_payer.toFixed(2)}€</td>
                <td style={{padding:'1px 8px',textAlign:'right',color:'#16a34a',fontWeight:600}}>{m.tva_deja_payee.toFixed(2)}€</td>
              </tr>
            ))}</tbody>
            <tfoot>
              <tr style={{background:'#dcfce7',fontWeight:700}}>
                <td style={{padding:'2px 8px',color:'#15803d'}}>Total T{trimestre}</td>
                <td style={{padding:'2px 8px',textAlign:'right',color:'#d97706'}}>{data.total_tva_a_payer.toFixed(2)}€</td>
                <td style={{padding:'2px 8px',textAlign:'right',color:'#16a34a'}}>{data.total_tva_deja_payee.toFixed(2)}€</td>
              </tr>
              <tr style={{background:'#bbf7d0',fontWeight:700}}>
                <td style={{padding:'2px 8px',color:'#15803d'}} colSpan={2}>TVA nette à payer (T{trimestre})</td>
                <td style={{padding:'2px 8px',textAlign:'right',color:data.solde_tva>=0?'#dc2626':'#16a34a',fontSize:12}}>{data.solde_tva.toFixed(2)}€</td>
              </tr>
            </tfoot>
          </table>
          <div style={{fontSize:9,color:'#6b7280'}}>TVA nette = TVA à payer − TVA déjà payée</div>
        </>
      )}
      {!loading && !data && <span style={{fontSize:10,color:'#aaa'}}>Aucune donnée pour ce trimestre.</span>}
    </div>
  );
}

function Cell({j,f,e,ec,ev,sev,save}) {
  const v=e?.[f]||0, editing=ec?.jour===j&&ec?.field===f;
  if(editing) return <input type="number" step="0.01" autoFocus value={ev} onChange={x=>sev(x.target.value)} onBlur={()=>save(j,f,ev)} onKeyDown={x=>x.key==='Enter'&&save(j,f,ev)} onFocus={()=>sev(String(v||''))} style={{width:'100%',padding:'2px 4px',fontSize:14,border:'none',textAlign:'left',background:'#eff6ff',outline:'none',boxSizing:'border-box'}} />;
  return <span style={{cursor:'pointer',color:v>0?(f==='recette'?'#16a34a':'#dc2626'):'#ccc',fontSize:14}}>{v>0?fmt(v):'—'}</span>;
}

function EnvBadge({label,val,color}) {
  return (
    <div style={{border:`1.5px solid ${color}`,borderRadius:5,padding:'4px 2px',width:60,margin:'0 auto',textAlign:'center',background:'#fff',boxSizing:'border-box'}}>
      <div style={{fontSize:9,color,fontWeight:700}}>{label}</div>
      <div style={{fontSize:12,fontWeight:700,color:'#222'}}>{fmt(val)}€</div>
    </div>
  );
}

function TVA({data}) {
  const jours=data.jours.filter(j=>j.recette>0);
  return (
    <div style={{display:'inline-block'}}>
      <table style={{borderCollapse:'collapse',fontSize:11}}>
        <thead><tr style={{background:'#0D1B2A',color:'white'}}>
          <th style={sTh}>Jour</th><th style={{...sTh,textAlign:'right'}}>Recette</th><th style={{...sTh,textAlign:'right'}}>TVA 21%</th>
        </tr></thead>
        <tbody>{jours.map((j,i)=>(
          <tr key={j.jour} style={{background:i%2?'#f9fafb':'white'}}>
            <td style={sTd}>{j.jour}</td>
            <td style={{...sTd,textAlign:'right'}}>{fmt(j.recette)}</td>
            <td style={{...sTd,textAlign:'right',color:'#d97706',fontWeight:600}}>{fmt(j.tva)}</td>
          </tr>
        ))}</tbody>
        <tfoot><tr style={{background:'#f0f9ff',fontWeight:700}}>
          <td style={sTd}>Total</td>
          <td style={{...sTd,textAlign:'right'}}>{fmt(data.resume.total_recettes)}</td>
          <td style={{...sTd,textAlign:'right',color:'#d97706'}}>{fmt(data.resume.total_tva)}</td>
        </tr></tfoot>
      </table>
    </div>
  );
}

function Recurrentes({ onSaved }) {
  const [items,setItems]=useState([]);
  const [nom,setNom]=useState('');const [mt,setMt]=useState('');const [jour,setJour]=useState('');
  const [editId,setEditId]=useState(null);const [editField,setEditField]=useState(null);const [editVal,setEditVal]=useState('');
  const ch=()=>api.get('/piemme/depenses-recurrentes').then(r=>setItems(r.data||[]));
  useEffect(()=>{ch()},[]);
  const total=items.filter(i=>i.actif).reduce((s,i)=>s+i.montant,0);
  const startEdit=(id,f,v)=>{setEditId(id);setEditField(f);setEditVal(String(v??''));};
  const stopEdit=()=>{setEditId(null);setEditField(null);};
  const isEditing=(id,f)=>editId===id&&editField===f;
  const modifier=async(id,champ,valeur)=>{
    try { await api.patch('/piemme/depenses-recurrentes/'+id,{[champ]:valeur}); stopEdit(); ch(); }
    catch(e) { alert(e.response?.data?.detail||e.message||'Erreur'); }
  };
  const clicValider=(item)=>{
    const saisi=window.prompt(`Créer une dépense "${item.libelle}" :\nMontant (€) :`,fmt(item.montant));
    if(saisi===null) return;
    const montant=parseFloat(saisi);
    if(!montant||montant<=0) return alert('Montant invalide');
    const now=new Date();
    const ds=now.getFullYear()+'-'+String(now.getMonth()+1).padStart(2,'0')+'-'+String(now.getDate()).padStart(2,'0');
    api.post('/piemme/depense-detail',{date:ds,montant,libelle:item.libelle}).then(()=>{if(onSaved)onSaved();}).catch(e=>alert(e.response?.data?.detail||e.message));
  };
  const sEdit={fontSize:11,padding:'1px 4px',border:'1px solid #93c5fd',borderRadius:2,boxSizing:'border-box'};
  return (
    <div>
      <div style={{background:'#fef3c7',borderRadius:6,padding:'4px 10px',marginBottom:8,fontSize:11}}>
        Total: <b>{fmt(total)}€</b> → Env/jour (÷20): <b>{fmt(total/20)}€</b>
      </div>
      <table style={{borderCollapse:'collapse',fontSize:11,marginBottom:8}}>
        <thead><tr style={{background:'#0D1B2A',color:'white'}}>
          <th style={sTh}>Libellé</th><th style={{...sTh,textAlign:'right'}}>Montant</th>
          <th style={sTh}>Échéance</th><th style={{...sTh,textAlign:'center'}}>Jour</th>
          <th style={{...sTh,textAlign:'center'}}>📧</th><th style={sTh}>✓</th><th style={sTh}></th>
        </tr></thead>
        <tbody>{items.map((i,x)=>(
          <tr key={i.id} style={{background:x%2?'#f9fafb':'white'}}>
            <td style={{...sTd,cursor:'pointer'}}>
              {isEditing(i.id,'libelle')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{if(editVal.trim())modifier(i.id,'libelle',editVal.trim());else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'&&editVal.trim())modifier(i.id,'libelle',editVal.trim());if(e.key==='Escape')stopEdit();}} style={{...sEdit,width:'100%'}} />
              :<span onClick={()=>startEdit(i.id,'libelle',i.libelle)}>{i.libelle}</span>}
            </td>
            <td style={{...sTd,textAlign:'right',cursor:'pointer'}}>
              {isEditing(i.id,'montant')?<input type="number" step="0.01" autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{const v=parseFloat(editVal);if(v>0)modifier(i.id,'montant',v);else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'){const v=parseFloat(editVal);if(v>0)modifier(i.id,'montant',v);else stopEdit();}if(e.key==='Escape')stopEdit();}} style={{...sEdit,width:70,textAlign:'right'}} />
              :<span onClick={()=>startEdit(i.id,'montant',i.montant)}>{fmt(i.montant)}</span>}
            </td>
            <td style={{...sTd,cursor:'pointer'}}>
              {(() => {
                if(!i.date_echeance) return <span onClick={()=>startEdit(i.id,'date_echeance','')} style={{color:'#ccc',cursor:'pointer'}}>—</span>;
                const de=new Date(i.date_echeance);
                const deStr=String(de.getDate()).padStart(2,'0')+'/'+String(de.getMonth()+1).padStart(2,'0')+'/'+de.getFullYear();
                return <span onClick={()=>startEdit(i.id,'date_echeance',deStr)} style={{color:de<new Date()?'#dc2626':'#d97706',fontWeight:700,cursor:'pointer'}}>{deStr}</span>;
              })()}
            </td>
            <td style={{...sTd,textAlign:'center',cursor:'pointer'}}>
              <span onClick={()=>startEdit(i.id,'jour_du_mois',i.jour_du_mois??'')} style={{color:i.jour_du_mois?'#1d4ed8':'#ccc',fontWeight:i.jour_du_mois?700:400}}>
                {i.jour_du_mois??'—'}
              </span>
            </td>
            <td style={{...sTd,textAlign:'center'}}>
              {(()=>{
                const moisActuel=new Date().getFullYear()+'-'+String(new Date().getMonth()+1).padStart(2,'0');
                const envoye=i.email_envoye_mois===moisActuel;
                return <button onClick={()=>api.patch('/piemme/depenses-recurrentes/'+i.id+'/toggle-email').then(ch)}
                  style={{background:envoye?'#dcfce7':'#f3f4f6',color:envoye?'#16a34a':'#9ca3af',border:envoye?'1px solid #16a34a':'1px solid #d1d5db',borderRadius:4,cursor:'pointer',fontSize:11,fontWeight:700,padding:'2px 4px',minWidth:20,minHeight:18}}>
                  {envoye?'✓':'○'}
                </button>;
              })()}
            </td>
            <td style={{...sTd,textAlign:'center'}}>
              <button onClick={()=>clicValider(i)} style={{background:'#dcfce7',color:'#16a34a',border:'1px solid #16a34a',borderRadius:4,cursor:'pointer',fontSize:11,fontWeight:700,padding:'2px 4px',minWidth:20,minHeight:18}}>✓</button>
            </td>
            <td style={{...sTd,textAlign:'center'}}>
              <button onClick={()=>api.delete('/piemme/depenses-recurrentes/'+i.id).then(ch)} style={{background:'none',border:'none',color:'#dc2626',cursor:'pointer'}}>×</button>
            </td>
          </tr>
        ))}</tbody>
      </table>
      <div style={{display:'flex',gap:4}}>
        <input placeholder="Libellé" value={nom} onChange={e=>setNom(e.target.value)} style={{...sIn,width:160}} />
        <input type="number" step="0.01" placeholder="€" value={mt} onChange={e=>setMt(e.target.value)} style={{...sIn,width:70}} />
        <input type="number" min="1" max="31" placeholder="Jour" value={jour} onChange={e=>setJour(e.target.value)} style={{...sIn,width:50}} />
        <button onClick={()=>{
          if(!nom.trim()||!mt) return;
          const payload={libelle:nom.trim(),montant:parseFloat(mt)};
          if(jour&&parseInt(jour)>=1&&parseInt(jour)<=31) payload.jour_du_mois=parseInt(jour);
          api.post('/piemme/depenses-recurrentes',payload).then(()=>{setNom('');setMt('');setJour('');ch();});
        }} style={{padding:'3px 10px',borderRadius:4,border:'none',background:'#1d4ed8',color:'white',fontSize:10,cursor:'pointer'}}>+</button>
      </div>
    </div>
  );
}

function FacturesEnRetard({ onPaye }) {
  const [factures,setFactures]=useState([]);
  const [loading,setLoading]=useState(true);
  const [editId,setEditId]=useState(null);const [editField,setEditField]=useState(null);const [editVal,setEditVal]=useState('');
  const [confirmDelId,setConfirmDelId]=useState(null);const [confirmPayId,setConfirmPayId]=useState(null);
  const todayStr=()=>{const d=new Date();return String(d.getDate()).padStart(2,'0')+'/'+String(d.getMonth()+1).padStart(2,'0')+'/'+d.getFullYear();};
  const [newDate,setNewDate]=useState(todayStr);const [newMontant,setNewMontant]=useState('');
  const [newLibelle,setNewLibelle]=useState('');const [newRemarque,setNewRemarque]=useState('');const [newEcheance,setNewEcheance]=useState('');

  const charger=()=>{setLoading(true);api.get('/piemme/factures-en-retard').then(r=>setFactures(r.data||[])).catch(()=>{}).finally(()=>setLoading(false));};
  useEffect(()=>{charger();},[]);

  const parseDate=(val)=>{const p=val.split(/[\/\-]/);if(p.length===3&&p[2].length===4)return p[2]+'-'+p[1].padStart(2,'0')+'-'+p[0].padStart(2,'0');if(p.length===3&&p[0].length===4)return val;return null;};

  const ajouter=async()=>{
    const ds=parseDate(newDate); if(!ds) return alert('Date invalide');
    const m=parseFloat(newMontant); if(!m||m<=0) return alert('Montant requis et > 0');
    const dsEch=newEcheance.trim()?parseDate(newEcheance):null;
    try { await api.post('/piemme/factures-en-retard',{date:ds,montant:m,fournisseur:newLibelle.trim(),remarque:newRemarque.trim(),date_echeance:dsEch}); setNewDate(todayStr());setNewMontant('');setNewLibelle('');setNewRemarque('');setNewEcheance('');charger(); }
    catch(e) { alert(e.response?.data?.detail||e.message||'Erreur'); }
  };

  const modifier=async(id,champ,valeur)=>{try{await api.post('/piemme/factures-en-retard/'+id+'/modifier',{[champ]:valeur});stopEdit();charger();}catch(e){alert(e.response?.data?.detail||e.message||'Erreur');}};
  const payer=async(id)=>{try{await api.post('/piemme/factures-en-retard/'+id+'/payer',{});setConfirmPayId(null);charger();if(onPaye)onPaye();}catch(e){alert(e.response?.data?.detail||e.message||'Erreur');}};
  const clicPayer=(id)=>{if(confirmPayId===id){payer(id);}else{setConfirmPayId(id);setTimeout(()=>setConfirmPayId(p=>p===id?null:p),3000);}};
  const supprimer=async(id)=>{try{await api.delete('/piemme/factures-en-retard/'+id);setConfirmDelId(null);charger();}catch(e){alert(e.response?.data?.detail||e.message||'Erreur');}};
  const clicSupprimer=(id)=>{if(confirmDelId===id){supprimer(id);}else{setConfirmDelId(id);setTimeout(()=>setConfirmDelId(p=>p===id?null:p),3000);}};
  const startEdit=(id,f,v)=>{setEditId(id);setEditField(f);setEditVal(String(v??''));};
  const stopEdit=()=>{setEditId(null);setEditField(null);};
  const isEditing=(id,f)=>editId===id&&editField===f;

  const total=factures.reduce((s,f)=>s+f.montant,0);
  const sEd={fontSize:11,padding:'2px 4px',border:'1px solid #93c5fd',borderRadius:3,boxSizing:'border-box'};
  const sNI={padding:'2px 4px',fontSize:10,border:'1px solid #ccc',borderRadius:3,boxSizing:'border-box'};

  if(loading) return <div style={{fontSize:11,color:'#888'}}>Chargement...</div>;

  return (
    <div style={{borderTop:'2px solid #dc2626',paddingTop:10}}>
      <div style={{display:'flex',alignItems:'center',gap:8,marginBottom:6}}>
        <span style={{fontSize:12,fontWeight:700,color:'#dc2626'}}>Factures en retard ({factures.length})</span>
        {factures.length>0&&<span style={{fontSize:12,fontWeight:700,color:'#dc2626'}}>{fmt(total)}€</span>}
      </div>
      <div style={{display:'flex',gap:3,marginBottom:8,flexWrap:'wrap'}}>
        <input placeholder="JJ/MM/AAAA" value={newDate} onChange={e=>setNewDate(e.target.value)} style={{...sNI,width:85}} />
        <input type="number" step="0.01" placeholder="€" value={newMontant} onChange={e=>setNewMontant(e.target.value)} style={{...sNI,width:60}} />
        <input placeholder="Fournisseur" value={newLibelle} onChange={e=>setNewLibelle(e.target.value)} style={{...sNI,width:120}} />
        <input placeholder="Remarque" value={newRemarque} onChange={e=>setNewRemarque(e.target.value)} style={{...sNI,width:120}} />
        <input placeholder="Échéance JJ/MM/AAAA" value={newEcheance} onChange={e=>setNewEcheance(e.target.value)} onKeyDown={e=>{if(e.key==='Enter')ajouter();}} style={{...sNI,width:130}} />
        <button onClick={ajouter} style={{padding:'3px 10px',borderRadius:4,border:'none',background:'#dc2626',color:'white',fontSize:10,cursor:'pointer',fontWeight:700}}>+</button>
      </div>
      {factures.length>0&&(
        <table style={{borderCollapse:'collapse',width:'auto',fontSize:11}}>
          <thead><tr style={{background:'#0D1B2A',color:'white'}}>
            <th style={{padding:'3px 8px',fontSize:10}}>Date</th>
            <th style={{padding:'3px 8px',fontSize:10,textAlign:'right'}}>Montant</th>
            <th style={{padding:'3px 8px',fontSize:10}}>Fournisseur</th>
            <th style={{padding:'3px 8px',fontSize:10}}>Remarque</th>
            <th style={{padding:'3px 8px',fontSize:10}}>Échéance</th>
            <th style={{padding:'3px 2px',fontSize:10,width:46}}></th>
          </tr></thead>
          <tbody>
            {factures.map((f,i)=>{
              const d=new Date(f.date);
              const dateStr=String(d.getDate()).padStart(2,'0')+'/'+String(d.getMonth()+1).padStart(2,'0')+'/'+d.getFullYear();
              const today=new Date();today.setHours(0,0,0,0);
              const depasse=f.date_echeance&&(()=>{const de=new Date(f.date_echeance);de.setHours(12,0,0,0);return de<today;})();
              return (
                <tr key={f.id} style={{background:depasse?'#fee2e2':i%2?'#f9fafb':'white'}}>
                  <td style={{padding:'1px 8px',cursor:'pointer',fontSize:10}}>
                    {isEditing(f.id,'date')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{const ds=parseDate(editVal);if(ds)modifier(f.id,'date',ds);else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'){const ds=parseDate(editVal);if(ds)modifier(f.id,'date',ds);else stopEdit();}if(e.key==='Escape')stopEdit();}} placeholder="JJ/MM/AAAA" style={{...sEd,width:90}} />
                    :<span onClick={()=>startEdit(f.id,'date',dateStr)}>{dateStr}</span>}
                  </td>
                  <td style={{padding:'1px 8px',textAlign:'right',color:'#dc2626',fontWeight:600,cursor:'pointer',fontSize:10}}>
                    {isEditing(f.id,'montant')?<input type="number" step="0.01" autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{const v=parseFloat(editVal);if(v>0)modifier(f.id,'montant',v);else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'){const v=parseFloat(editVal);if(v>0)modifier(f.id,'montant',v);else stopEdit();}if(e.key==='Escape')stopEdit();}} style={{...sEd,width:70,textAlign:'right'}} />
                    :<span onClick={()=>startEdit(f.id,'montant',f.montant)}>{fmt(f.montant)}€</span>}
                  </td>
                  <td style={{padding:'1px 8px',cursor:'pointer',fontSize:10}}>
                    {isEditing(f.id,'fournisseur')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>modifier(f.id,'fournisseur',editVal)} onKeyDown={e=>{if(e.key==='Enter')modifier(f.id,'fournisseur',editVal);if(e.key==='Escape')stopEdit();}} style={{...sEd,width:'100%'}} />
                    :<span onClick={()=>startEdit(f.id,'fournisseur',f.fournisseur||'')}>{f.fournisseur||'—'}</span>}
                  </td>
                  <td style={{padding:'1px 8px',color:'#666',cursor:'pointer',fontSize:10}}>
                    {isEditing(f.id,'remarque')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>modifier(f.id,'remarque',editVal)} onKeyDown={e=>{if(e.key==='Enter')modifier(f.id,'remarque',editVal);if(e.key==='Escape')stopEdit();}} style={{...sEd,width:'100%'}} />
                    :<span onClick={()=>startEdit(f.id,'remarque',f.remarque||'')}>{f.remarque||'—'}</span>}
                  </td>
                  <td style={{padding:'1px 8px',cursor:'pointer',fontSize:10}}>
                    {(()=>{
                      if(isEditing(f.id,'date_echeance')) return <input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{const ds=parseDate(editVal);modifier(f.id,'date_echeance',ds||null);}} onKeyDown={e=>{if(e.key==='Enter'){const ds=parseDate(editVal);modifier(f.id,'date_echeance',ds||null);}if(e.key==='Escape')stopEdit();}} placeholder="JJ/MM/AAAA" style={{...sEd,width:90}} />;
                      if(!f.date_echeance) return <span onClick={()=>startEdit(f.id,'date_echeance','')} style={{color:'#ccc',cursor:'pointer'}}>—</span>;
                      const de=new Date(f.date_echeance);
                      const deStr=String(de.getDate()).padStart(2,'0')+'/'+String(de.getMonth()+1).padStart(2,'0')+'/'+de.getFullYear();
                      return <span onClick={()=>startEdit(f.id,'date_echeance',deStr)} style={{color:de<new Date()?'#dc2626':'#d97706',fontWeight:700,cursor:'pointer'}}>{deStr}</span>;
                    })()}
                  </td>
                  <td style={{padding:'0px 2px',textAlign:'center'}}>
                    <div style={{display:'flex',gap:2,justifyContent:'center'}}>
                      <button onClick={()=>clicPayer(f.id)} style={{background:confirmPayId===f.id?'#16a34a':'#dcfce7',color:confirmPayId===f.id?'white':'#16a34a',border:'1px solid #16a34a',borderRadius:4,cursor:'pointer',fontSize:confirmPayId===f.id?8:10,fontWeight:700,padding:'2px 4px',minWidth:20,minHeight:18,whiteSpace:'nowrap'}}>
                        {confirmPayId===f.id?'OK ?':'✓'}
                      </button>
                      <button onClick={()=>clicSupprimer(f.id)} style={{background:confirmDelId===f.id?'#dc2626':'none',color:confirmDelId===f.id?'white':'#dc2626',border:'none',borderRadius:4,cursor:'pointer',fontSize:confirmDelId===f.id?9:14,fontWeight:confirmDelId===f.id?700:400,padding:'2px 4px',minWidth:20,minHeight:18,whiteSpace:'nowrap'}}>
                        {confirmDelId===f.id?'OK ?':'×'}
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </div>
  );
}

function Enveloppes() {
  const [items,setItems]=useState([]);const [nom,setNom]=useState('');const [dc,setDc]=useState('');const [rq,setRq]=useState('');
  const [editId,setEditId]=useState(null);const [editField,setEditField]=useState(null);const [editVal,setEditVal]=useState('');
  const ch=()=>api.get('/piemme/enveloppes').then(r=>setItems(r.data||[]));
  useEffect(()=>{ch();},[]);
  const startEdit=(id,f,v)=>{setEditId(id);setEditField(f);setEditVal(String(v??''));};
  const stopEdit=()=>{setEditId(null);setEditField(null);};
  const isEditing=(id,f)=>editId===id&&editField===f;
  const modifier=async(id,champ,valeur)=>{try{await api.patch('/piemme/enveloppes/'+id,{[champ]:valeur});stopEdit();ch();}catch(e){alert(e.response?.data?.detail||e.message||'Erreur');}};
  const parseDate=(val)=>{const p=val.split(/[\/\-]/);if(p.length===3&&p[2].length===4)return p[2]+'-'+p[1].padStart(2,'0')+'-'+p[0].padStart(2,'0');if(p.length===3&&p[0].length===4)return val;return null;};
  const total=items.reduce((s,i)=>s+Number(i.montant||0),0);
  const sEdit={fontSize:11,padding:'1px 4px',border:'1px solid #93c5fd',borderRadius:2,boxSizing:'border-box'};

  return (
    <div>
      <div style={{display:'flex',gap:4,flexWrap:'wrap',marginBottom:8}}>
        <input placeholder="Nom enveloppe" value={nom} onChange={e=>setNom(e.target.value)} style={{...sIn,width:150}} />
        <input placeholder="JJ/MM/AAAA" value={dc} onChange={e=>setDc(e.target.value)} style={{...sIn,width:95}} />
        <input placeholder="Remarque" value={rq} onChange={e=>setRq(e.target.value)} onKeyDown={e=>{if(e.key==='Enter'){if(!nom.trim())return;const dsIso=dc.trim()?parseDate(dc):null;api.post('/piemme/enveloppes',{nom:nom.trim(),montant1:0,montant2:0,montant3:0,montant4:0,date_creation:dsIso,remarque:rq.trim()||null}).then(()=>{setNom('');setDc('');setRq('');ch();}).catch(e=>alert(e.response?.data?.detail||e.message));}}} style={{...sIn,width:160}} />
        <button onClick={()=>{if(!nom.trim())return;const dsIso=dc.trim()?parseDate(dc):null;api.post('/piemme/enveloppes',{nom:nom.trim(),montant1:0,montant2:0,montant3:0,montant4:0,date_creation:dsIso,remarque:rq.trim()||null}).then(()=>{setNom('');setDc('');setRq('');ch();}).catch(e=>alert(e.response?.data?.detail||e.message));}}
          style={{padding:'3px 10px',borderRadius:4,border:'none',background:'#1d4ed8',color:'white',fontSize:10,cursor:'pointer'}}>+</button>
      </div>
      <div style={{background:'#fef3c7',borderRadius:6,padding:'4px 10px',marginBottom:8,fontSize:11}}>Total épargné : <b>{fmt(total)}€</b></div>
      <table style={{borderCollapse:'collapse',fontSize:11,marginBottom:8}}>
        <thead><tr style={{background:'#0D1B2A',color:'white'}}>
          <th style={sTh}>Enveloppe</th>
          {['V1','V2','V3','V4'].map(v=><th key={v} style={{...sTh,textAlign:'right'}}>{v}</th>)}
          <th style={{...sTh,textAlign:'right'}}>TOTAL</th>
          <th style={sTh}>Créée le</th><th style={sTh}>Remarque</th><th style={sTh}></th>
        </tr></thead>
        <tbody>{items.map((i,x)=>(
          <tr key={i.id} style={{background:x%2?'#f9fafb':'white'}}>
            <td style={{...sTd,cursor:'pointer'}}>
              {isEditing(i.id,'nom')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{if(editVal.trim())modifier(i.id,'nom',editVal.trim());else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'&&editVal.trim())modifier(i.id,'nom',editVal.trim());if(e.key==='Escape')stopEdit();}} style={{...sEdit,width:'100%'}} />
              :<span onClick={()=>startEdit(i.id,'nom',i.nom)}>{i.nom}</span>}
            </td>
            {['montant1','montant2','montant3','montant4'].map(champ=>(
              <td key={champ} style={{...sTd,textAlign:'right',cursor:'pointer'}}>
                {isEditing(i.id,champ)?<input type="number" step="0.01" autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>{const v=parseFloat(editVal);if(!isNaN(v))modifier(i.id,champ,v);else stopEdit();}} onKeyDown={e=>{if(e.key==='Enter'){const v=parseFloat(editVal);if(!isNaN(v))modifier(i.id,champ,v);else stopEdit();}if(e.key==='Escape')stopEdit();}} style={{...sEdit,width:70,textAlign:'right'}} />
                :<span onClick={()=>startEdit(i.id,champ,i[champ]||0)}>{fmt(i[champ]||0)}€</span>}
              </td>
            ))}
            <td style={{...sTd,textAlign:'right',fontWeight:700,color:'#1d4ed8'}}>{fmt(i.montant||0)}€</td>
            <td style={{...sTd,cursor:'pointer',color:'#666'}}>
              {(()=>{if(!i.date_creation)return <span onClick={()=>startEdit(i.id,'date_creation','')} style={{color:'#ccc',cursor:'pointer'}}>—</span>;const de=new Date(i.date_creation);de.setHours(12,0,0,0);const deStr=String(de.getDate()).padStart(2,'0')+'/'+String(de.getMonth()+1).padStart(2,'0')+'/'+de.getFullYear();return <span onClick={()=>startEdit(i.id,'date_creation',deStr)} style={{cursor:'pointer'}}>{deStr}</span>;})()}
            </td>
            <td style={{...sTd,cursor:'pointer',color:'#666'}}>
              {isEditing(i.id,'remarque')?<input autoFocus value={editVal} onChange={e=>setEditVal(e.target.value)} onBlur={()=>modifier(i.id,'remarque',editVal.trim()||null)} onKeyDown={e=>{if(e.key==='Enter')modifier(i.id,'remarque',editVal.trim()||null);if(e.key==='Escape')stopEdit();}} style={{...sEdit,width:160}} />
              :<span onClick={()=>startEdit(i.id,'remarque',i.remarque||'')} style={{color:i.remarque?'#444':'#ccc'}}>{i.remarque||'—'}</span>}
            </td>
            <td style={{...sTd,textAlign:'center'}}>
              <div style={{display:'flex',gap:4,justifyContent:'center'}}>
                <button onClick={()=>api.patch('/piemme/enveloppes/'+i.id,{montant1:0,montant2:0,montant3:0,montant4:0}).then(ch)} style={{background:'#fef3c7',color:'#d97706',border:'1px solid #d97706',borderRadius:4,cursor:'pointer',fontSize:10,fontWeight:700,padding:'2px 6px'}}>0</button>
                <button onClick={()=>api.delete('/piemme/enveloppes/'+i.id).then(ch)} style={{background:'none',border:'none',color:'#dc2626',cursor:'pointer',fontSize:14}}>×</button>
              </div>
            </td>
          </tr>
        ))}</tbody>
      </table>
    </div>
  );
}

function GraphiqueMois({ annee, moisActif, dataMois }) {
  const MOIS_COURT=['Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
  const fmtK=(n)=>{const v=Number(n||0);return v>=1000?(v/1000).toFixed(1)+'k':v.toFixed(0);};
  const joursMois=dataMois?.jours||[], nbJours=dataMois?.nb_jours||31;
  const maxJour=Math.max(...joursMois.map(j=>j.recette),1);
  const W=900,H=260,padL=55,padR=15,padT=22,padB=38,gW=W-padL-padR,gH=H-padT-padB;
  const bW=gW/nbJours,bI=Math.max(4,Math.floor(bW*0.65));
  const niv=[0,0.25,0.5,0.75,1.0].map(p=>({val:Math.round(maxJour*p),y:padT+gH-Math.round(gH*p)}));
  return (
    <div style={{marginTop:6}}>
      <div style={{fontSize:11,fontWeight:700,color:'#0D1B2A',marginBottom:4}}>Recettes par jour — {MOIS_COURT[moisActif-1]} {annee}</div>
      <svg viewBox={`0 0 ${W} ${H}`} width="100%" style={{fontFamily:'sans-serif',display:'block',maxWidth:'100%'}}>
        <rect x={0} y={0} width={W} height={H} fill="#f9fafb" rx={6} />
        {niv.map((n,i)=>(<g key={i}><line x1={padL} y1={n.y} x2={W-padR} y2={n.y} stroke="#e5e7eb" strokeWidth={1} strokeDasharray={i===0?'0':'3,3'} /><text x={padL-4} y={n.y+4} textAnchor="end" fontSize={8} fill="#9ca3af">{fmtK(n.val)}€</text></g>))}
        {Array.from({length:nbJours},(_,di)=>{const d=di+1,j=joursMois.find(jj=>jj.jour===d),rec=j?.recette||0,hBar=rec>0?Math.max(2,Math.round(gH*rec/maxJour)):0,x=padL+di*bW+(bW-bI)/2,y=padT+gH-hBar,show=d===1||d%5===0||d===nbJours;return(<g key={d}><rect x={x} y={y} width={bI} height={hBar||2} fill={rec>0?'#60a5fa':'#e5e7eb'} rx={1} />{rec>0&&bW>14&&<text x={x+bI/2} y={y-3} textAnchor="middle" fontSize={7} fill="#3b82f6">{fmtK(rec)}</text>}{show&&<text x={x+bI/2} y={H-padB+14} textAnchor="middle" fontSize={8} fill="#9ca3af">{d}</text>}</g>);})}
        <line x1={padL} y1={padT} x2={padL} y2={padT+gH} stroke="#d1d5db" strokeWidth={1} />
        <line x1={padL} y1={padT+gH} x2={W-padR} y2={padT+gH} stroke="#d1d5db" strokeWidth={1} />
      </svg>
      {dataMois&&<div style={{display:'flex',gap:14,marginTop:4,fontSize:10,color:'#555',flexWrap:'wrap'}}>
        <span>Recettes : <b style={{color:'#16a34a'}}>{Number(dataMois.resume?.total_recettes||0).toFixed(2)}€</b></span>
        <span>Dépenses : <b style={{color:'#dc2626'}}>{Number(dataMois.resume?.total_depenses||0).toFixed(2)}€</b></span>
        <span>Bénéfice : <b style={{color:dataMois.resume?.benefice>=0?'#16a34a':'#dc2626'}}>{Number(dataMois.resume?.benefice||0).toFixed(2)}€</b></span>
      </div>}
    </div>
  );
}

function GraphiqueAnnuel({ annee, moisActif }) {
  const [dataAnnuel,setDataAnnuel]=useState(null);
  const MOIS_COURT=['Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
  const fmtK=(n)=>{const v=Number(n||0);return v>=1000?(v/1000).toFixed(1)+'k':v.toFixed(0);};
  useEffect(()=>{api.get('/piemme/annuel/'+annee).then(r=>setDataAnnuel(r.data)).catch(()=>{});},[annee]);
  const moisData=dataAnnuel?.mois||{};
  const valMois=Array.from({length:12},(_,i)=>({m:i+1,recettes:moisData[i+1]?moisData[i+1].total_recettes:0}));
  const maxMois=Math.max(...valMois.map(v=>v.recettes),1);
  const W=900,H=260,padL=55,padR=15,padT=22,padB=38,gW=W-padL-padR,gH=H-padT-padB;
  const bW=Math.floor(gW/12),bI=Math.floor(bW*0.55);
  const niv=[0,0.25,0.5,0.75,1.0].map(p=>({val:Math.round(maxMois*p),y:padT+gH-Math.round(gH*p)}));
  if(!dataAnnuel) return <p style={{fontSize:11,color:'#888',marginTop:10}}>Chargement...</p>;
  return (
    <div style={{marginTop:6}}>
      <div style={{fontSize:11,fontWeight:700,color:'#0D1B2A',marginBottom:4}}>Recettes par mois — {annee}</div>
      <svg viewBox={`0 0 ${W} ${H}`} width="100%" style={{fontFamily:'sans-serif',display:'block'}}>
        <rect x={0} y={0} width={W} height={H} fill="#f9fafb" rx={6} />
        {niv.map((n,i)=>(<g key={i}><line x1={padL} y1={n.y} x2={W-padR} y2={n.y} stroke="#e5e7eb" strokeWidth={1} strokeDasharray={i===0?'0':'3,3'} /><text x={padL-4} y={n.y+4} textAnchor="end" fontSize={8} fill="#9ca3af">{fmtK(n.val)}€</text></g>))}
        {valMois.map((v,i)=>{const x=padL+i*bW+(bW-bI)/2,hBar=v.recettes>0?Math.max(2,Math.round(gH*v.recettes/maxMois)):0,y=padT+gH-hBar,actif=v.m===moisActif,couleur=actif?'#1d4ed8':v.recettes>0?'#60a5fa':'#e5e7eb';return(<g key={i}><rect x={x} y={y} width={bI} height={hBar||2} fill={couleur} rx={2} />{v.recettes>0&&<text x={x+bI/2} y={y-3} textAnchor="middle" fontSize={8} fill={actif?'#1d4ed8':'#6b7280'} fontWeight={actif?700:400}>{fmtK(v.recettes)}</text>}<text x={x+bI/2} y={H-padB+14} textAnchor="middle" fontSize={9} fill={actif?'#1d4ed8':'#6b7280'} fontWeight={actif?700:400}>{MOIS_COURT[i]}</text></g>);})}
        <line x1={padL} y1={padT} x2={padL} y2={padT+gH} stroke="#d1d5db" strokeWidth={1} />
        <line x1={padL} y1={padT+gH} x2={W-padR} y2={padT+gH} stroke="#d1d5db" strokeWidth={1} />
      </svg>
      <div style={{display:'flex',gap:14,marginTop:4,fontSize:10,color:'#555',flexWrap:'wrap'}}>
        <span>Total recettes : <b style={{color:'#16a34a'}}>{Number(dataAnnuel.totaux?.recettes||0).toFixed(2)}€</b></span>
        <span>Total dépenses : <b style={{color:'#dc2626'}}>{Number(dataAnnuel.totaux?.depenses||0).toFixed(2)}€</b></span>
        <span>TVA : <b style={{color:'#d97706'}}>{Number(dataAnnuel.totaux?.tva||0).toFixed(2)}€</b></span>
        <span>Bénéfice : <b style={{color:dataAnnuel.totaux?.benefice>=0?'#16a34a':'#dc2626'}}>{Number(dataAnnuel.totaux?.benefice||0).toFixed(2)}€</b></span>
      </div>
    </div>
  );
}

function Annuel({annee}) {
  const [data,setData]=useState(null);
  useEffect(()=>{api.get('/piemme/annuel/'+annee).then(r=>setData(r.data)).catch(()=>{});},[annee]);
  if(!data) return <p style={{color:'#888'}}>Chargement...</p>;
  const moisData=data.mois||{},t=data.totaux||{};
  const MC=['Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
  const getVal=(m,d,field)=>{const md=moisData[m];if(!md||!md.jours||!md.jours[d])return null;return md.jours[d][field]||0;};
  return (
    <div style={{display:'flex',alignItems:'flex-start',gap:16}}>
      <div style={{overflowX:'auto'}}>
        <table style={{borderCollapse:'collapse',fontSize:11,tableLayout:'fixed',width:'auto'}}>
          <colgroup><col style={{width:36}} />{MC.map((_,i)=><col key={i} style={{width:72}} />)}<col style={{width:78}} /></colgroup>
          <thead><tr style={{background:'#0D1B2A',color:'white'}}>
            <th style={{padding:'4px 4px',fontSize:12}}>J</th>
            {MC.map((m,i)=><th key={i} style={{padding:'4px 3px',fontSize:11,textAlign:'center'}}>{m}</th>)}
            <th style={{padding:'4px 3px',fontSize:11,textAlign:'center'}}>Total</th>
          </tr></thead>
          <tbody>{Array.from({length:31},(_,d)=>d+1).map(d=>{
            const rowTotal=Array.from({length:12},(_,m)=>m+1).reduce((s,m)=>(getVal(m,d,'recette')||0)+s,0);
            return(<tr key={d} style={{background:d%2?'white':'#f9fafb'}}>
              <td style={{padding:'3px 5px',fontWeight:700,fontSize:12,textAlign:'center',borderRight:'2px solid #aaa',color:'#555'}}>{d}</td>
              {Array.from({length:12},(_,m)=>m+1).map(m=>{const v=getVal(m,d,'recette');return(<td key={m} style={{padding:'3px 4px',textAlign:'right',fontSize:12,borderLeft:'1px solid #ddd',color:v>0?'#16a34a':'#eee'}}>{v!==null&&v>0?fmt(v):''}</td>);})}
              <td style={{padding:'3px 5px',textAlign:'right',fontWeight:700,fontSize:12,borderLeft:'2px solid #aaa',color:'#16a34a'}}>{rowTotal>0?fmt(rowTotal):''}</td>
            </tr>);
          })}</tbody>
          <tfoot>
            {[['Rec.','#e0f2e9','total_recettes','#16a34a'],['Dép.','#fef2f2','total_depenses','#dc2626'],['TVA','#fffbeb','total_tva','#d97706']].map(([label,bg,field,color])=>(
              <tr key={label} style={{background:bg,borderTop:label==='Rec.'?'2px solid #0D1B2A':'none'}}>
                <td style={{padding:'3px 4px',fontWeight:700,fontSize:10,borderRight:'2px solid #aaa'}}>{label}</td>
                {Array.from({length:12},(_,m)=>m+1).map(m=>(<td key={m} style={{padding:'3px 3px',textAlign:'right',fontWeight:700,fontSize:11,borderLeft:'1px solid #ddd',color}}>{moisData[m]?fmt(moisData[m][field]):''}</td>))}
                <td style={{padding:'3px 4px',textAlign:'right',fontWeight:700,fontSize:12,borderLeft:'2px solid #aaa',color}}>{fmt(t[field.replace('total_','')]??t.recettes??0)}</td>
              </tr>
            ))}
            <tr style={{background:'#f0f9ff'}}>
              <td style={{padding:'3px 4px',fontWeight:700,fontSize:10,borderRight:'2px solid #aaa'}}>Bén.</td>
              {Array.from({length:12},(_,m)=>m+1).map(m=>{const b=moisData[m]?moisData[m].benefice:null;return(<td key={m} style={{padding:'3px 3px',textAlign:'right',fontWeight:700,fontSize:11,borderLeft:'1px solid #ddd',color:b>=0?'#16a34a':'#dc2626'}}>{b!==null?fmt(b):''}</td>);})}
              <td style={{padding:'3px 4px',textAlign:'right',fontWeight:700,fontSize:12,borderLeft:'2px solid #aaa',color:t.benefice>=0?'#16a34a':'#dc2626'}}>{fmt(t.benefice)}</td>
            </tr>
          </tfoot>
        </table>
      </div>
      <div style={{display:'flex',flexDirection:'column',gap:8,minWidth:140,padding:'10px 14px',background:'#f9fafb',borderRadius:8,border:'1px solid #e5e7eb',fontSize:13,whiteSpace:'nowrap'}}>
        <div><span style={{color:'#888'}}>Année </span><b>{annee}</b></div>
        <div><span style={{color:'#888'}}>Recettes </span><b style={{color:'#16a34a'}}>{fmt(t.recettes)} €</b></div>
        <div><span style={{color:'#888'}}>Dépenses </span><b style={{color:'#dc2626'}}>{fmt(t.depenses)} €</b></div>
        <div><span style={{color:'#888'}}>TVA </span><b style={{color:'#d97706'}}>{fmt(t.tva)} €</b></div>
        <div style={{borderTop:'1px solid #e5e7eb',paddingTop:6}}><span style={{color:'#888'}}>Bénéfice </span><b style={{color:t.benefice>=0?'#16a34a':'#dc2626'}}>{fmt(t.benefice)} €</b></div>
      </div>
    </div>
  );
}

const sNav={width:24,height:24,borderRadius:'50%',border:'1px solid #ddd',background:'white',fontSize:11,cursor:'pointer',display:'flex',alignItems:'center',justifyContent:'center'};
const sH={padding:'4px 2px',textAlign:'center',fontSize:14,fontWeight:700,color:'#555',borderLeft:'2px solid #aaa'};
const sL={padding:'3px 4px',fontWeight:700,fontSize:14,whiteSpace:'nowrap',borderRight:'2px solid #aaa',width:40};
const sV={padding:'3px 4px',textAlign:'left',fontSize:14,borderLeft:'2px solid #ccc',border:'1px solid #ddd',background:'white',cursor:'pointer'};
const sTh={padding:'3px 6px',fontSize:10,fontWeight:600};
const sTd={padding:'3px 6px',borderBottom:'1px solid #f0f0f0'};
const sIn={padding:'3px 6px',fontSize:11,border:'1px solid #ddd',borderRadius:4,boxSizing:'border-box'};
