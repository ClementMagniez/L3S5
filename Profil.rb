##
# @title Profil
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Profil*, qui contient les informations des joueurs de l'application.
#
require "active_record"

ActiveRecord::Schema.define do
	create_table :profils do |c|
		c.string :pseudonyme
		c.string :mdpEncrypted
	end
end

##
# == Classe *Profil*
#
# à compléter
#
class Profil < ActiveRecord::Base
	# Un joueur possède plusieurs scores (un par grille de jeu)
	has_and_belongs_to_many :scores

	# @id_joueur, @pseudonyme, @mdpEncrypted - L'identifiant du joueur, une chaîne de caractères représentant son nom dans l'application, une chaîne de caractères lui permettant de se connecter à l'application

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de l'objet appelé.
	#
	def to_s
		return "Joueur n°#{@id_profil} : #{@pseudonyme}, mot de passe du compte (encrypté) : #{@mdp_encrypted}"
	end
end
