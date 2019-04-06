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
	
	# Ajouts de Romane :
	# @estConnecte vaut 1 si l'utilisateur est connecté, 0 sinon
	# @connexion vaut nil si l'utilisateur n'est pas connecté
	#			 contient un objet de la classe Connexion s'il est connecté
	
	# Méthode permettant à l'utilisateur de se connecter au jeu.
	#
	# Paramètres :
	#	- login : le login entré par l'utilisateur
	#	- password : le mot de passe entré par l'utilisateur
	def seConnecter(uneSession, login, password)
		@connexion = uneSession
		@estConnecte = @connexion.seConnecter(login, password)
		if(@estConnecte)
			@connexion.modifierSession(@id, login, password)
		end
	end
	
	# Méthode permettant à l'utilisateur de se déconnecter du jeu.
	def seDeconnecter()
		@connexion = @connexion.deconnexion()
		@estConnecte = 0
	end
	
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
