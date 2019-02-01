require_relative 'Grille'

### Démo

# Création et affichage de la grille de base (générée via la ligne 40) 
grille=Grille.new(40,"grilles.txt");
puts grille, "\n---------"


# Cycle de la case vide [0][0] : vide -> gazon
grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

# Cycle de la case vide [0][0] : gazon -> tente ; tentesCol et tentesLigne changent
grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

# Cycle de la case vide [0][0] : tente -> vide, reset de Col et Ligne
grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

# Cycle de la case arbre [0][1] : arbre -> arbre coché
grille[0][1].cycle(0,1, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

# Cycle de la case vide [1][0] : arbre -> arbre coché
grille[1][0].cycle(1,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

# Cycle de la case vide [1][0] : arbre -> arbre coché
grille[1][0].cycle(1,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

