##
# @title Score
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Score*, qui contient les informations des scores de l'application.
#
require "active_record"

##
# == Classe *Score*
#
# à compléter - classe intermédiaire
#
class Score < ActiveRecord::Base
	# @montantScore, @modeJeu, @dateObtention, @joueur_id, @grille_id - Un entier strictement positif, une chaine de caractères indiquant le mode de jeu où le score a été obtenu, la date où le score a été obtenu, l'identifiant d'un joueur, l'identifiant d'une grille

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de l'objet appelé.
	#
	def to_s
		return "Score du joueur n°#{@profil} pour la grille n°#{@map} (difficulté #{@modeJeu}) : #{@montantScore}, obtenu le #{@dateObtention}."
	end
end
