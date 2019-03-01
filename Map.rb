##
# @title Map
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Map*, qui contient les informations des grilles de l'application.
#
require "active_record"

ActiveRecord::Schema.define do
	create_table :maps do |c|
    c.string :taille
    c.string :difficulte
  end
end

##
# == Classe *Map*
#
# à compléter
#
class Map < ActiveRecord::Base
	# Une grille possède plusieurs scores (un par joueur l'ayant tenté)
	has_and_belongs_to_many :scores

	# @id_grille, @taille, @difficulte - L'identifiant de la grille, un entier représentant sa taille en longueur et en largeur, une chaîne de caractères indiquant sa difficulté

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de l'objet appelé.
	#
	def to_s
		return "Grille n°#{@id_map} : Taille = #{@taille}, difficulté : #{@difficulte}"
	end
end
