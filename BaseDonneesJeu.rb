##
# @title Base de Données de l'application "Des tentes et des arbres"
# @author KAJAK Rémi
# 
# Le fichier "BaseDonneesJeu.rb" contient toutes les instructions nécessaires à la création de la base de données de l'application.
# La bibliothèque SQL utilisé est +SQLite3+. Il fait appel aux classes *Profil*, *Grille* et *Score* pour pouvoir fonctionner correctement.
# 

require "rubygems"
require "active_record"
require "connectSqlite3"
require "Profil.rb"
require "Grille.rb"
require "Score.rb"
