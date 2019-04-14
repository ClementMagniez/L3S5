##
# @title Profil
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère le modèle de la table *Profil*, qui contient les informations des joueurs de
# l'application.
#
require "active_record"
require_relative "connectSqlite3.rb"
require_relative "Connexion.rb"

##
# = Classe *Profil*
#
# La classe *Profil* a pour rôle d'établir le modèle pour la table éponyme. Elle est reliée à la table
# *Map* grâce à une table intermédiaire nommée *Score*.
#
class Profil < ActiveRecord::Base
	# Un joueur possède plusieurs scores (un par grille de jeu)
	has_and_belongs_to_many :scores

	# @id, @pseudonyme, @mdpEncrypted - L'identifiant du joueur, une chaîne de caractères représentant
	# son nom dans l'application, une chaîne de caractères lui permettant de se connecter à l'application
	
	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de
	# l'objet appelé.
	#
	def to_s
		return "Joueur n°#{id} : #{pseudonyme}, mot de passe du compte (encrypté) : #{mdpEncrypted}"
	end
end