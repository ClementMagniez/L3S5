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
ActiveRecord::Base.establish_connection(
	:adapter	=>	"sqlite3",
	:database	=>	"DAEDT.sqlite3",
	:timeout	=>	5000
);
