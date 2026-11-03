"""
Service d'envoi d'emails via l'API Brevo — Piemme.
"""
import requests
import os
import logging

logger = logging.getLogger(__name__)

BREVO_API_URL = "https://api.brevo.com/v3/smtp/email"
DESTINATAIRES_PIEMME = [
    {"email": "lolive.318@gmail.com", "name": "L'Olive"},
    {"email": "mike.neureuther@gmail.com", "name": "Mike"},
]


def _envoyer(subject: str, html_content: str, destinataires=None) -> bool:
    if destinataires is None:
        destinataires = DESTINATAIRES_PIEMME
    api_key = os.getenv("BREVO_API_KEY")
    sender_email = os.getenv("BREVO_SENDER_EMAIL", "verlainebc@gmail.com")
    sender_name = os.getenv("BREVO_SENDER_NAME", "Piemme")
    if not api_key:
        logger.warning("[EMAIL] BREVO_API_KEY manquante — email non envoyé")
        return False
    payload = {"sender": {"name": sender_name, "email": sender_email},
               "to": destinataires, "subject": subject, "htmlContent": html_content}
    try:
        response = requests.post(BREVO_API_URL,
                                 headers={"accept": "application/json", "api-key": api_key,
                                          "content-type": "application/json"},
                                 json=payload, timeout=10)
        if response.status_code not in (200, 201):
            logger.error(f"[EMAIL] Brevo erreur: {response.text}")
            return False
        return True
    except Exception as e:
        logger.error(f"[EMAIL] Erreur envoi: {e}")
        return False


def envoyer_mail_recette(date_str: str, montant: float, remarque: str = None) -> bool:
    remarque_html = f"<p><em>Remarque : {remarque}</em></p>" if remarque else ""
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:500px;margin:0 auto;">
        <h2 style="color:#16a34a;">✅ Recette encodée — Piemme</h2>
        <table style="width:100%;border-collapse:collapse;">
            <tr><td style="padding:8px;font-weight:bold;color:#555;">Date</td><td style="padding:8px;">{date_str}</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;font-weight:bold;color:#555;">Montant</td>
            <td style="padding:8px;font-size:18px;color:#16a34a;"><strong>{montant:.2f} €</strong></td></tr>
        </table>{remarque_html}
        <p style="color:#888;font-size:12px;margin-top:20px;">— Piemme</p>
    </div>"""
    return _envoyer(subject=f"[Piemme] Recette du {date_str} : {montant:.2f} €", html_content=html)


def envoyer_mail_facture(date_str: str, montant: float, fournisseur: str = None, remarque: str = None) -> bool:
    fournisseur_html = f"<tr><td style='padding:8px;font-weight:bold;color:#555;'>Fournisseur</td><td style='padding:8px;'>{fournisseur}</td></tr>" if fournisseur else ""
    remarque_html = f"<p><em>Remarque : {remarque}</em></p>" if remarque else ""
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:500px;margin:0 auto;">
        <h2 style="color:#dc2626;">🧾 Facture encodée — Piemme</h2>
        <table style="width:100%;border-collapse:collapse;">
            <tr><td style="padding:8px;font-weight:bold;color:#555;">Date</td><td style="padding:8px;">{date_str}</td></tr>
            {fournisseur_html}
            <tr style="background:#f9f9f9;"><td style="padding:8px;font-weight:bold;color:#555;">Montant</td>
            <td style="padding:8px;font-size:18px;color:#dc2626;"><strong>{montant:.2f} €</strong></td></tr>
        </table>{remarque_html}
        <p style="color:#888;font-size:12px;margin-top:20px;">— Piemme</p>
    </div>"""
    return _envoyer(subject=f"[Piemme] Facture {fournisseur or ''} du {date_str} : {montant:.2f} €", html_content=html)


def envoyer_mail_echeances_depassees(factures: list) -> bool:
    aujourd_hui_str = factures[0]["aujourd_hui"] if factures and "aujourd_hui" in factures[0] else ""
    total = sum(f["montant"] for f in factures)
    lignes_html = "".join(f"""<tr>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;">{f['date']}</td>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;color:#dc2626;font-weight:bold;">{f['montant']:.2f} €</td>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;">{f.get('fournisseur') or '—'}</td>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;color:#dc2626;">{f.get('date_echeance') or '—'}</td>
    </tr>""" for f in factures)
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:650px;margin:0 auto;">
        <h2 style="color:#dc2626;">🔔 Factures en retard — Échéances dépassées</h2>
        <p>Factures dont l'échéance est dépassée au <strong>{aujourd_hui_str}</strong> :</p>
        <table style="width:100%;border-collapse:collapse;">
            <thead><tr style="background:#f3f4f6;">
                <th style="padding:6px 8px;text-align:left;font-size:12px;">Date</th>
                <th style="padding:6px 8px;text-align:left;font-size:12px;">Montant</th>
                <th style="padding:6px 8px;text-align:left;font-size:12px;">Fournisseur</th>
                <th style="padding:6px 8px;text-align:left;font-size:12px;color:#dc2626;">Échéance</th>
            </tr></thead>
            <tbody>{lignes_html}</tbody>
            <tfoot><tr style="background:#fef2f2;">
                <td style="padding:8px;font-weight:bold;">TOTAL</td>
                <td style="padding:8px;font-weight:bold;color:#dc2626;font-size:16px;">{total:.2f} €</td>
                <td colspan="2"></td>
            </tr></tfoot>
        </table>
        <p style="color:#888;font-size:12px;margin-top:20px;">— Piemme (vérification automatique)</p>
    </div>"""
    nb = len(factures)
    return _envoyer(subject=f"[Piemme] 🔔 {nb} facture{'s' if nb>1 else ''} en retard ({total:.2f} €)", html_content=html)


def envoyer_mail_recurrentes_dues(recurrentes: list) -> bool:
    mois_actuel = recurrentes[0]["mois_actuel"] if recurrentes else ""
    total = sum(r["montant"] for r in recurrentes)
    lignes_html = "".join(f"""<tr>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;">{r['libelle']}</td>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;color:#d97706;font-weight:bold;">{r['montant']:.2f} €</td>
        <td style="padding:6px 8px;border-bottom:1px solid #eee;text-align:center;">le {r['jour_du_mois']}</td>
    </tr>""" for r in recurrentes)
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;">
        <h2 style="color:#d97706;">📅 Dépenses récurrentes dues — {mois_actuel}</h2>
        <table style="width:100%;border-collapse:collapse;">
            <thead><tr style="background:#f3f4f6;">
                <th style="padding:6px 8px;text-align:left;font-size:12px;">Libellé</th>
                <th style="padding:6px 8px;text-align:left;font-size:12px;">Montant</th>
                <th style="padding:6px 8px;text-align:center;font-size:12px;">Jour prévu</th>
            </tr></thead>
            <tbody>{lignes_html}</tbody>
            <tfoot><tr style="background:#fffbeb;">
                <td style="padding:8px;font-weight:bold;">TOTAL</td>
                <td style="padding:8px;font-weight:bold;color:#d97706;font-size:16px;">{total:.2f} €</td>
                <td></td>
            </tr></tfoot>
        </table>
        <p style="color:#888;font-size:12px;margin-top:20px;">— Piemme (vérification automatique)</p>
    </div>"""
    nb = len(recurrentes)
    return _envoyer(subject=f"[Piemme] 📅 {nb} dépense{'s' if nb>1 else ''} récurrente{'s' if nb>1 else ''} due{'s' if nb>1 else ''} — {mois_actuel} ({total:.2f} €)", html_content=html)


def envoyer_mail_recette_manquante(date_str: str) -> bool:
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:500px;margin:0 auto;">
        <h2 style="color:#d97706;">⚠️ Recette manquante — Piemme</h2>
        <p>La recette du <strong>{date_str}</strong> n'a pas encore été encodée.</p>
        <p style="color:#888;font-size:12px;margin-top:20px;">— Piemme (vérification automatique 23h)</p>
    </div>"""
    return _envoyer(subject=f"[Piemme] ⚠️ Recette manquante du {date_str}", html_content=html)
