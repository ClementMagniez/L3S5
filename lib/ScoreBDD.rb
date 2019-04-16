##
# @title Score
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Score*, qui contient les informations des scores de l'application.
#
require "active_record"

##
# = Classe *Score*
#
# La classe *Score* a pour rôle d'établir le modèle pour la table éponyme. Elle fait office de lien
# entre les tables *Map* et *Profil*, car un score concerne obligatoirement un joueur et une grille.
#
class Score < ActiveRecord::Base
	# Un score appartient à un profil de joueur
	belongs_to :profil

	# @id, @montantScore, @modeJeu, @dateObtention, @joueur_id, @grille_id - L'identifiant du score, un
	# entier strictement positif, une chaine de caractères indiquant le mode de jeu où le score a été
	# obtenu, la date où le score a été obtenu, l'identifiant d'un joueur, l'identifiant d'une map

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de
	# l'objet appelé.
	#
	def to_s
		return "\##{id} => mode \"#{modeJeu}\", difficulté \"#{difficulte}\" : #{montantScore}, obtenu le #{dateObtention}, par le joueur #{joueur_id}."
	end
end
