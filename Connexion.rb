##
# @title Connexion d'un utilisateur
# @author BUON Romane
# @version 0.1
##

require "active_record"
require_relative "connectSqlite3.rb"

#require_relative "Utilisateur.rb"
#require_relative "Cryptage.rb"
require_relative "Profil.rb"

class Connexion < ActiveRecord::Base
	#@utilisateurConnecte contient l'ID de l'utilisateur connecté

	attr_reader :utilisateurConnecte

	def Connexion.CreerConnexion(unID, unLogin, unPassword)
		intialize(unID, unLogin, unPassword)
	end

	def initialize(unID, unLogin, unPassword)
		@utilisateurConnecte = unID
		@login = unLogin
		@password = unPassword.crypt(unPassword)
	end

	def seConnecter(login, password)
		#@connexion = Connexion.CreerConnexion(@id, login, password)
		#@connexion.seConnecter()
		#Cryptage du mot de passe
		mdp = password.crypt(password)
		#recherche du login dans la base de données
		#si le login n'est pas présent
		if(Profil.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil)
			#Affichage d'une erreur
			puts("Login ou mot de passe incorrect")
			#On propose à l'utilisateur de créé un compte ou de tenter une nouvelle identification
		#si le login est présent dans la base de données
		else
			#l'utilisateur est connecté
			#self.authenticate_safely_simply(login, mdp)
			estConnecte = 1
			@connexion = Connexion.CreerConnexion(@id)
			puts "===== CONNECTE ====="
		end
	end

	#def seConnecter(login, password)
		#Cryptage du mot de passe
	#	mdp = password.crypt(password)
		#recherche du login dans la base de données
		#si le login n'est pas présent
	#	if(Profil.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil)
			#Affichage d'une erreur
	#		puts("Login ou mot de passe incorrect")
			#On propose à l'utilisateur de créé un compte ou de tenter une nouvelle identification
		#si le login est présent dans la base de données
	#	else
			#l'utilisateur est connecté
	#		self.authenticate_safely_simply(login, mdp)
	#		@utilisateurConnecte = 1
	#	end
	#end

	#def self.authenticate_safely_simply(login, password)
    	#	where(pseudonyme: login, mdpEncrypted: password).first
 	#end

	def deconnexion()
		@utilisateurConnecte = nil
	end
end

#test = Connexion.new()
