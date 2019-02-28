require_relative 'Grille'
require_relative 'Aide'

### Démo pour les aides ###

# Création et affichage de la grille de base (générée via la ligne 40) 
grille=Grille.new(380,"grilles.txt");
puts grille, "\n---------"

aide = Aide.new(grille)


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"

grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
grille[0][4].cycle(0,4, grille.tentesLigne, grille.tentesCol)
grille[0][6].cycle(0,6, grille.tentesLigne, grille.tentesCol)
grille[1][7].cycle(1,7, grille.tentesLigne, grille.tentesCol)
grille[2][0].cycle(2,0, grille.tentesLigne, grille.tentesCol)
grille[2][3].cycle(2,3, grille.tentesLigne, grille.tentesCol)
grille[2][4].cycle(2,4, grille.tentesLigne, grille.tentesCol)
grille[2][6].cycle(2,6, grille.tentesLigne, grille.tentesCol)
grille[2][7].cycle(2,7, grille.tentesLigne, grille.tentesCol)
grille[2][8].cycle(2,8, grille.tentesLigne, grille.tentesCol)
grille[3][0].cycle(3,0, grille.tentesLigne, grille.tentesCol)
grille[3][1].cycle(3,1, grille.tentesLigne, grille.tentesCol)
grille[3][2].cycle(3,2, grille.tentesLigne, grille.tentesCol)
grille[3][3].cycle(3,3, grille.tentesLigne, grille.tentesCol)
grille[3][8].cycle(3,8, grille.tentesLigne, grille.tentesCol)
grille[4][0].cycle(4,0, grille.tentesLigne, grille.tentesCol)
grille[4][2].cycle(4,2, grille.tentesLigne, grille.tentesCol)
grille[5][3].cycle(5,3, grille.tentesLigne, grille.tentesCol)
grille[5][5].cycle(5,5, grille.tentesLigne, grille.tentesCol)
grille[6][4].cycle(6,4, grille.tentesLigne, grille.tentesCol)
grille[6][5].cycle(6,5, grille.tentesLigne, grille.tentesCol)
grille[6][6].cycle(6,6, grille.tentesLigne, grille.tentesCol)
grille[7][3].cycle(7,3, grille.tentesLigne, grille.tentesCol)
grille[7][4].cycle(7,4, grille.tentesLigne, grille.tentesCol)
grille[8][1].cycle(8,1, grille.tentesLigne, grille.tentesCol)
grille[8][2].cycle(8,2, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"

grille[8][3].cycle(8,3, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"

grille[0][7].cycle(0,7, grille.tentesLigne, grille.tentesCol)
grille[0][7].cycle(0,7, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[2][5].cycle(2,5, grille.tentesLigne, grille.tentesCol)
grille[2][5].cycle(2,5, grille.tentesLigne, grille.tentesCol)
grille[1][4].cycle(1,4, grille.tentesLigne, grille.tentesCol)
grille[1][6].cycle(1,6, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"



grille[8][6].cycle(8,6, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"

puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"