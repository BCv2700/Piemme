export default function TicketImprimable({ data }) {
  if (!data) return null;
  const dateAffichee = new Date(data.date).toLocaleDateString('fr-BE');

  return (
    <div className="ticket-caisse">
      <div className="ticket-header">
        <div className="ticket-nom">{data.nom}</div>
        <div>{data.adresse}</div>
        <div>{data.codePostalVille}</div>
        {data.telephones.map((tel, i) => <div key={i}>Tel : {tel}</div>)}
        <div>{data.tva}</div>
      </div>

      <div className="ticket-date">{dateAffichee}</div>

      {data.table && (
        <div className="ticket-table">{data.table}</div>
      )}

      <table className="ticket-lignes">
        <tbody>
          {data.lignes.map((l, i) => (
            <tr key={i}>
              <td>{l.quantite}</td>
              <td>{l.nom}</td>
              <td className="right">{l.total.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="ticket-total-ligne">
        <span>Total des achats :</span><span>{data.montantTotal.toFixed(2)}</span>
      </div>
      <div className="ticket-total-ligne ticket-a-payer">
        <span>à payer :</span><span>{data.montantTotal.toFixed(2)}</span>
      </div>
      <div className="ticket-total-ligne">
        <span>{data.nbPersonnes} pers. - Prix/pers. :</span><span>{data.prixParPersonne.toFixed(2)}</span>
      </div>

      {data.montantCarte > 0 && (
        <div className="ticket-total-ligne">
          <span>Bancontact :</span><span>{data.montantCarte.toFixed(2)}</span>
        </div>
      )}
      {data.montantCash > 0 && (
        <div className="ticket-total-ligne">
          <span>Cash :</span><span>{data.montantCash.toFixed(2)}</span>
        </div>
      )}

      <div className="ticket-ref">Ref ticket : {data.numeroTicket}</div>
      <div className="ticket-merci">MERCI POUR VOTRE VISITE<br />ET A BIENTÔT.</div>

      <table className="ticket-tva">
        <thead><tr><th>% TVA</th><th className="right">Montant</th></tr></thead>
        <tbody>
          {[6, 12, 21].map(t => data.tvaParTaux[t] > 0 && (
            <tr key={t}><td>{t}</td><td className="right">{data.tvaParTaux[t].toFixed(2)}</td></tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}