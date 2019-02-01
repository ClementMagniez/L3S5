##
# @title Score
# @author KAJAK Rémi
# 
# Ce fichier gère le modèle de la table *Score*, qui contient les informations des Scores de l'application.
# 

##
# == Classe *Score*
# 
# à compléter - classe intermédiaire
# 
class Score < ActiveRecord::Base
	# Un score appartient à un joueur et à une grille.
	has_and_belongs_to :profil, :grille
	
	# @id_score, @montant_score, @joueur_id, @grille_id - L'identifiant du score, un entier strictement positif, l'identifiant d'un joueur, l'identifiant d'une grille

	##
	# == to_s
	# 
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de l'objet appelé.
	# 
	def to_s
		return "Score du joueur n°#{@joueur_id} pour la Score n°#{@grille_id} : #{@montant_score}"
	end
end