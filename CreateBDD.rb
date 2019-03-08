##
# @title CreateBDD
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier a pour rôle de créer les tables de la base de données de l'application.
#
require_relative "connectSqlite3.rb"

##
#
# = Schéma par défaut
#
# Lorsque le fichier est exécuté, il crée les trois tables nécessaires au stockage des données du joueur actuel,
# des grilles qu'il a complété et des scores qu'il a obtenu.
#
ActiveRecord::Schema.define do
	##
	#
	# == Table *Profil*
	#
	# Contient l'identifiant d'un compte joueur, son pseudonyme et son mot de passe encrypté (impossible à voir
	# en clair dans la BDD).
	#
	create_table :profils do |c|
		c.string :pseudonyme
		c.string :mdpEncrypted
	end

	##
	#
	# == Table *Map*
	#
	# Contient l'identifiant d'une grille de jeu, sa taille (nombre de cases en longueur/largeur) et sa
	# difficulté.
	#
  create_table :maps do |c|
    c.string :taille
    c.string :difficulte
  end

	##
	#
	# == Table *Score*
	#
	# Contient l'identifiant d'un score, sa valeur numérique, le mode de jeu dans lequel il a été obtenu,
	# sa date d'obtention, plus les identifiants de la grille concernée et du joueur propriétaire.
	#
  create_table :scores do |c|
  	c.integer :montantScore
  	c.string :modeJeu
  	c.date :dateObtention
    c.references :profil
    c.references :map
  end
end
