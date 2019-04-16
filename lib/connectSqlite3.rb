##
# @title connectSqlite3
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier a pour rôle de gérer la connexion à la base de données de l'application. Le moteur SQL
# utilisé est SQLite3.
#
require "active_record"

##
#
# Le nom de la base de données est l'abréviation du nom du jeu (Des Arbres Et Des Tentes).
#
nomBDD = (!File.file?("DAEDT.sqlite3")) ?	"lib/DAEDT.sqlite3" : "DAEDT.sqlite3"

ActiveRecord::Base.establish_connection(
	:adapter	=>	"sqlite3",
	:database	=>	nomBDD,
	:timeout	=>	5000
);
