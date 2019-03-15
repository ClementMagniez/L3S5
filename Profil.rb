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
	
	
	# Ajouts de Romane
	# @estConnecte vaut 1 si l'utilisateur est connecté, 0 sinon
	# @connexion vaut nil si l'utilisateur n'est pas connecté
	#			 contient un objet de la classe Connexion s'il est connecté
	
	# Méthode permettant à l'utilisateur de se connecter au jeu
	def seConnecter(login, password)
		@connexion = Connexion.CreerConnexion(@id, login, password)
		@connexion.seConnecter(login, password)
		#Cryptage du mot de passe
		#mdp = password.crypt(password)
		#recherche du login dans la base de données
		#si le login n'est pas présent
		#if(profils.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil)
			#Affichage d'une erreur
			#puts("Login ou mot de passe incorrect")
			#On propose à l'utilisateur de créé un compte ou de tenter une nouvelle identification
		#si le login est présent dans la base de données
		#else
			#l'utilisateur est connecté
			#self.authenticate_safely_simply(login, mdp)
			#estConnecte = 1
			#@connexion = Connexion.CreerConnexion(@id)
			#puts "===== CONNECTE ====="
		#end
	end
	
	# Méthode permettant à l'utilisateur de se déconnecter
	def seDeconnecter(utilisateurConnecte)
		@utilisateurConnecte = nil
		@connexion = @connexion.deconnexion()
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