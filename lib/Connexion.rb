##
# @title Connexion
# @author BUON Romane
# @version 0.1
##

require "active_record"
require "openssl"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"


class Connexion

	# Variables d'instance :
	# 	@id contient l'ID de l'utilisateur connecté
	# 	@login contient le login de l'utilisateur connecté
	# 	@password contient le mot de passe crypté de l'utilisateur connecté
	
	# Méthode permettant de modifier les informations liées à une session, lors de la
	# connexion d'un nouvel utilisateur par exemple.
	#
	# Paramètres :
	#	- unID : l'ID de l'utilisateur connecté
	#	- unLogin : le login de l'utilisateur connecté
	#	- unPassword : le mot de passe crypté de l'utilisateur connecté
	#def modifierSession(unID, unLogin, unPassword)
	def modifierSession(unLogin)
		#@id = unID
		@login = unLogin
		#@password = unPassword
	end
	
	# Méthode permettant à un utilisateur de tenter de se connecter.
	def seConnecter(login, password)
		mdp = crypterMdp(password)									#Cryptage du mot de passe
		#mdp = password.crypt(password)
		#recherche du login dans la base de données
		if(Profil.find_by(pseudonyme: login, mdpEncrypted: mdp) == nil) #si le login n'est pas présent
			puts("ERREUR : Login ou mot de passe incorrect") 			#Affichage d'une erreur
			return 0
			#On propose à l'utilisateur de créer un compte ou de tenter une nouvelle identification
		else 															#si le login est présent dans la base de données
			puts "-----> CONNECTE <-----"								#l'utilisateur est connecté
			@login = login
			return 1
		end
	end
	
	# Méthode permettant de crypter un mot de passe.
	def crypterMdp(mdp)
		#pass_phrase = mdp
		#salt = '8 octets'

		#encrypter = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'
		#encrypter.encrypt
		#encrypter.pkcs5_keyivgen pass_phrase, salt

		#encrypted = encrypter.update mdp
		#encrypted << encrypter.final	
		
		#return encrypted
		return mdp.crypt(mdp)
	end
	
	# Méthode permettant à un utilisateur de se déconnecter.
	def deconnexion()
		#@id = nil
		@login = nil
		#@password = nil
		
		puts "----> Déconnecté <----"
		
		return nil
	end	
	
	attr_reader :login
end