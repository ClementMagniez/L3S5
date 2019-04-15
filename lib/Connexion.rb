##
# @title Connexion
# @author BUON Romane, KAJAK Rémi
# @version 0.1
##

require "active_record"
require "openssl"
require_relative "connectSqlite3.rb"
require_relative "Map.rb"
require_relative "Score.rb"
require_relative "Profil.rb"


class Connexion

	# Variables d'instance :
	# 	@id contient l'ID de l'utilisateur connecté
	# 	@login contient le login de l'utilisateur connecté

	attr_reader :id, :login

	# Méthode permettant de modifier les informations liées à une session, lors de la
	# connexion d'un nouvel utilisateur par exemple.
	#
	# Paramètres :
	#	- unID : l'ID de l'utilisateur connecté
	#	- unLogin : le login de l'utilisateur connecté
	#def modifierSession(unID, unLogin)
	def modifierSession(unID,unLogin)
		@id = unID
		@login = unLogin
	end

	# Méthode permettant à un utilisateur de tenter de se connecter.
	def seConnecter(login, password)
		mdp = crypterMdp(password)									#Cryptage du mot de passe
		#mdp = password.crypt(password)
		#recherche du login dans la base de données
		reqProfil = Profil.find_by(pseudonyme: login, mdpEncrypted: mdp)

		if(reqProfil == nil) #si le login n'est pas présent
			return false
			#On propose à l'utilisateur de créer un compte ou de tenter une nouvelle identification
		else 															#si le login est présent dans la base de données
			@id = reqProfil.id
			@login = login
			return true
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
		@id = nil
		@login = nil

		puts "----> Déconnecté <----"

		return nil
	end

	##
	# == enregistrerScore(4)
	#
	# Cette méthode permet d'insérer un nouveau score dans la base de données à la fin
	# d'une partie. Toutes les informations liées à cette partie sont enregistrées dans
	# la table *Score*.
	#
	# === Paramètres
	#
	# * +idJoueur+ - L'identifiant numérique du joueur connecté à l'application
	# * +nomMode+ - Le nom du mode de jeu
	# * +nomMap+ - Le nom de la grille jouée
	# * +score+ - Le montant du score obtenu à la fin de la partie
	#
	def enregistrerScore(idJoueur,infoGrille)
		reqScore = Score.new(
			montantScore: infoGrille[3],
			modeJeu: infoGrille[2],
			dateObtention: Time.now.to_s.split(" ").at(0).to_s
		);
		reqScore.profil_id = idJoueur
		reqScore.map_id = nil

		if(infoGrille[2] == "Rapide" || infoGrille[2] == "Exploration")
			# Cherche si la grille courante possède déjà une entrée dans la BDD ou pas
			reqMap = Map.find_by(nomMap: infoGrille[0])

			if(reqMap == nil)
				# Insertion d'un nouveau champ dans la table Map
				insertMap = Map.new(
					hash_name: infoGrille[0],
					difficulte: infoGrille[1]
				);
				insertMap.save
				reqMap = Map.find_by(nomMap: infoGrille[0])
				reqScore.map_id = reqMap.id
			end
		end
		reqScore.save
	end

	##
	# == rechercherScore(1)
	#
	# Cette méthode permet de sortir tous les scores contenues dans la base de données.
	#
	# === Paramètre
	#
	# * +idJoueur+ - L'identifiant numérique du joueur connecté à l'application
	#
	def rechercherScore(idJoueur)
		reqScore = Score.find_by(id: idJoueur)

		if(reqScore != nil)
			reqScore.order("modeJeu, dateObtention, montantScore DESC")
		end
		return reqScore
	end

	##
	# == rechercherScore(1)
	#
	# Cette méthode permet de sortir tous les scores contenues dans la base de données.
	#
	# === Paramètre
	#
	# * +idJoueur+ - L'identifiant numérique du joueur connecté à l'application
	#
	def supprimerScore(idScore)
		Score.find_by(id: idScore).destroy
	end
end
