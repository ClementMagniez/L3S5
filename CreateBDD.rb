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
if(!File.file?("lib/DAEDT.sqlite3"))
	ActiveRecord::Schema.define do
		create_table :profils do |c|
			c.string :pseudonyme
			c.string :mdpEncrypted
		end

	  create_table :maps do |c|
	    c.string :taille
	    c.string :difficulte
	  end

	  create_table :scores do |c|
	  	c.integer :montantScore
	  	c.string :modeJeu
	  	c.date :dateObtention
	    c.references :profil
	    c.references :map
	  end
	end
end
