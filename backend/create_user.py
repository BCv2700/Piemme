"""
Script pour créer un nouvel utilisateur ou réinitialiser le mot de passe d'un
utilisateur existant.

Utilisation (depuis le dossier backend, avec l'environnement Python activé) :
    python create_user.py

Le script demande un nom d'utilisateur et un mot de passe, puis :
- si l'utilisateur n'existe pas encore -> il est créé
- si l'utilisateur existe déjà -> son mot de passe est mis à jour (réinitialisation)

IMPORTANT : ce script se connecte à la base définie par DATABASE_URL dans ton
fichier .env local. Vérifie que ce .env pointe bien vers la base Railway de
production avant de lancer le script, sinon tu créeras l'utilisateur dans la
mauvaise base.
"""
from getpass import getpass
from app.database import SessionLocal
from app.models.utilisateur import Utilisateur
from app.auth import hasher_mot_de_passe


def main():
    username = input("Nom d'utilisateur : ").strip()
    if not username:
        print("Nom d'utilisateur vide, abandon.")
        return

    mot_de_passe = getpass("Mot de passe (ne s'affiche pas en tapant) : ").strip()
    if len(mot_de_passe) < 4:
        print("Mot de passe trop court (minimum 4 caractères), abandon.")
        return

    confirmation = getpass("Confirme le mot de passe : ").strip()
    if mot_de_passe != confirmation:
        print("Les deux mots de passe ne correspondent pas, abandon.")
        return

    db = SessionLocal()
    try:
        utilisateur = db.query(Utilisateur).filter(Utilisateur.username == username).first()
        mot_de_passe_hash = hasher_mot_de_passe(mot_de_passe)

        if utilisateur:
            utilisateur.mot_de_passe = mot_de_passe_hash
            utilisateur.actif = True
            db.commit()
            print(f"Mot de passe de '{username}' réinitialisé avec succès.")
        else:
            nouvel_utilisateur = Utilisateur(
                username=username,
                mot_de_passe=mot_de_passe_hash,
                actif=True,
            )
            db.add(nouvel_utilisateur)
            db.commit()
            print(f"Utilisateur '{username}' créé avec succès.")
    finally:
        db.close()


if __name__ == "__main__":
    main()