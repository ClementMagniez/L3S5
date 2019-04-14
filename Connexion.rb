##
# @title Connexion
# @author BUON Romane
# @version 0.1
##

require "active_record"
require "digest/sha1"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"

class Connexion
	
	# Variable d'instance :
	# 	@loginUser contient le login de l'utilisateur connecté
	
	##
	# Méthode permettant de modifier les informations liées à une session, lors de la
	# connexion d'un nouvel utilisateur par exemple.
	#
	# Paramètres :
	#	- unLogin : le login de l'utilisateur connecté
	def modifierSession(unLogin)
		@loginUser = unLogin
	end
	
	##
	# Méthode permettant à un utilisateur de tenter de se connecter.
	#
	# Paramètres :
	#	- login : l'identifiant entré par l'utilisateur
	#	- password : le mot de passe entré par l'utilisateur
	#
	# Retourne -1 si le couple identifiant/mot de passe n'a pas été trouvé dans la base de données
	# Retourne l'identifiant de l'utilisateur si la connexion est possible.
	def seConnecter(login, password)
		#Cryptage du mot de passe
		mdp = crypterMdp(password)
		
		#recherche du couple login/mot de passe dans la base de données
		if(Profil.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil) #si le login n'est pas présent
			return -1
		else 															#si le login est présent dans la base de données
			#puts "-----> CONNECTE <-----"								#l'utilisateur est connecté
			@loginUser = login
			return @loginUser
		end
	end
	
	##
	# Méthode permettant de crypter un mot de passe.
	#
	# Paramètres :
	#	- mdp : le mot de passe à crypter.
	#
	# Retourne le mot de passe crypté.
	def crypterMdp(mdp)		
		Digest::SHA1.hexdigest(mdp)
	end
	
	##
	# Méthode permettant à un utilisateur de se déconnecter.
	def deconnexion()
		@loginUser = nil
		puts "----> Déconnecté <----"
	end
	
end