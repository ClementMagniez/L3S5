##
# @title Connexion
# @author BUON Romane
# @version 0.1
##

require "active_record"
require 'digest/sha1'
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"


class Connexion

	# Variables d'instance :
	# 	@loginUser contient le login de l'utilisateur connecté
	
	# Méthode permettant de modifier les informations liées à une session, lors de la
	# connexion d'un nouvel utilisateur par exemple.
	#
	# Paramètres :
	#	- unLogin : le login de l'utilisateur connecté
	def modifierSession(unLogin)
		@loginUser = unLogin
	end
	
	# Méthode permettant à un utilisateur de tenter de se connecter.
	def seConnecter(login, password)
		mdp = crypterMdp(password)									#Cryptage du mot de passe
		#recherche du login dans la base de données
		if(Profil.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil) #si le login n'est pas présent
			return -1
		else 															#si le login est présent dans la base de données
			puts "-----> CONNECTE <-----"								#l'utilisateur est connecté
			@loginUser = login
			return @loginUser
		end
	end
	
	# Méthode permettant de crypter un mot de passe.
	def crypterMdp(mdp)
		Digest::SHA1.hexdigest(mdp)
	end
	
	# Méthode permettant à un utilisateur de se déconnecter.
	def deconnexion()
		@loginUser = nil
		
		puts "----> Déconnecté <----"
		
		return nil
	end	
	
	attr_reader :login
end
