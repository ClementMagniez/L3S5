require_relative 'Grille'
require_relative 'Aide'

### Démo pour les aides ###

# Création et affichage de la grille de base (générée via la ligne 40) 
grille=Grille.new(40,"grilles.txt");
puts grille, "\n---------"

aide = Aide.new(grille)


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[4][1].cycle(4,1, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[4][2].cycle(4,2, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[4][3].cycle(4,3, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[2][0].cycle(2,0, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[2][1].cycle(2,1, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[2][3].cycle(2,3, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[2][4].cycle(2,4, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[2][5].cycle(2,5, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[1][0].cycle(1,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[0][0].cycle(0,0, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][0].cycle(3,0, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][0].cycle(3,0, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[3][1].cycle(3,1, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[3][3].cycle(3,3, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[5][2].cycle(5,2, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[5][1].cycle(5,1, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[5][1].cycle(5,1, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[5][3].cycle(5,3, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[5][3].cycle(5,3, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[5][5].cycle(5,5, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[5][5].cycle(5,5, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[1][5].cycle(1,5, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][5].cycle(3,5, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[3][2].cycle(3,2, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][2].cycle(3,2, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][4].cycle(3,4, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[3][4].cycle(3,4, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[0][3].cycle(0,3, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[1][1].cycle(1,1, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[0][4].cycle(0,4, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[0][4].cycle(0,4, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[0][2].cycle(0,2, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[1][2].cycle(1,2, grille.tentesLigne, grille.tentesCol)
#puts grille, "\n---------"
grille[1][2].cycle(1,2, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"


grille[1][4].cycle(1,4, grille.tentesLigne, grille.tentesCol)
puts grille, "\n---------"


puts "\nDEBUT cycle\n", aide.cycle, "FIN cycle\n"

