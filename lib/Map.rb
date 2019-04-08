##
# @title Map
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Map*, qui contient les informations des grilles de l'application.
#
require "active_record"

##
# == Classe *Map*
#
# La classe *Map* a pour rôle d'établir le modèle pour la table éponyme. Elle est reliée à la table
# *Profil* grâce à une table intermédiaire nommée *Score*.
#
class Map < ActiveRecord::Base
	# Une grille possède plusieurs scores (un par joueur l'ayant tenté)
	has_and_belongs_to_many :scores

	# @id, @hash_name, @taille, @difficulte - L'identifiant de la grille, son hashcode pour la reconnaître lors d'une
	# recherche, un entier représentant sa taille en longueur et en largeur, une chaîne de caractères indiquant sa
	# difficulté

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de
	# l'objet appelé.
	#
	def to_s
		return "Map n°#{id} : Hashcode = #{hash_name}, Taille = #{taille}, difficulté : #{difficulte}"
	end
end
