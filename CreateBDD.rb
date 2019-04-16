##
# @title CreateBDD
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier a pour rôle de créer les tables de la base de données de l'application.
#

##
#
# = Schéma par défaut
#
# Lorsque le fichier est exécuté, il crée les trois tables nécessaires au stockage des données du joueur actuel,
# des grilles qu'il a complété et des scores qu'il a obtenu.
#
require_relative "lib/connectSqlite3.rb"

if(!File.file?("lib/DAEDT.sqlite3"))
	ActiveRecord::Schema.define do
		create_table :profils do |c|
			c.string :pseudonyme
			c.string :mdpEncrypted
		end

	  create_table :scores do |c|
	  	c.string :modeJeu
	    c.string :difficulte
		  c.integer :montantScore
	  	c.date :dateObtention
	    c.references :profil
	  end
	end
end
