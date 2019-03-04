require_relative 'Grille'
require_relative 'Aide'
require_relative 'ihm/interface.rb'
### Démo pour les aides ###

# Création et affichage de la grille de base (générée via la ligne 40) 
grille=Grille.new(40,"grilles.txt");
puts grille, "\n---------"

aide = Aide.new(grille)

#grille.length
taille = 6
builder = Builder.new
builder.newGrille(grille,taille, taille,aide)

