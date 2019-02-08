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
	# Un score appartient à un joueur et à une grille.
	has_and_belongs_to_many :profil, :grille

	# @id_score, @montantScore, @modeJeu, @dateObtention, @joueur_id, @grille_id - L'identifiant du score, un entier strictement positif, une chaine de caractères indiquant le mode de jeu où le score a été obtenu, la date où le score a été obtenu, l'identifiant d'un joueur, l'identifiant d'une grille

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de l'objet appelé.
	#
	def to_s
		return "Score du joueur n°#{@joueur_id} pour la grille n°#{@grille_id} (difficulté #{@modeJeu}) : #{@montantScore}, obtenu le #{@dateObtention}."
	end
end
