Projet "jeu de tentes et arbre" de fin de L3.

# Comment jouer

## Installation
Après avoir téléchargé le zip ou cloné le repo, exécuter `./install.sh` si sur une distro Debian/Ubuntu ; sur une autre, installer à la main GTK, SQLite3 et Ruby ainsi que les gemmes sqlite3, gtk3, inifile et activerecord.

## Exécution
Entrer `./tents-trees` depuis la racine du projet si install.sh a été utilisé ; sinon, entrer `rake` ou `ruby lib/main.rb`

### Jouer

Commencer par créer un compte en cliquant sur "S'inscrire" depuis l'écran d'accueil, puis se connecter via ces identifiants. Choisir un mode de difficulté puis (si non-tutoriel) un niveau de difficulté ; les règles sont systématiquement disponibles via un bouton en haut à droite de la fenêtre.
La partie s'achèvera automatiquement quand la grille sera complète et valide, présentant un écran résumant le score et le temps mis à la compléter.
Une configuration basique est proposée dans le menu d'options, accessible en bas à gauche ; il est possible de renommer son compte / changer son mot de passe et de voir ses scores dans le profil.

Quatre modes de jeu sont proposés :
- Tutoriel
- Chrono (la partie s'achevant, et le score étant ignoré, si le décompte atteint 00:00 ; l'aide retire des secondes au temps)
- Aventure (cinq parties de suite sur une même taille de grille avant de passer à la suivante, la taille de départ dépendant de la difficulté ; l'aide est indisponible)
- Exploration (mode libre ; l'aide est cependant limitée à n usages pour une grille n*n)

# Membres
- BUON Romane
- DURAND Pierre
- KAJAK Rémi 
- LALOY Alexandre
- LOUP Renaud
- MAGNIEZ Clément
- PHILIPPE Marion
