##
# @title Base de Données de l'application "Des tentes et des arbres"
# @author KAJAK Rémi
# @version 0.1
#
# Le fichier "BaseDonneesJeu.rb" contient toutes les instructions nécessaires à la manipulation des données de l'application.
# La bibliothèque SQL utilisé est +SQLite3+. Il fait appel aux classes *Profil*, *Map* et *Score* pour pouvoir fonctionner correctement.
#
require "rubygems"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"
require_relative "Map.rb"
require_relative "Score.rb"

profilTest = Profil.new(
	pseudonyme: "Test",
	mdpEncrypted: "azerty".crypt("azerty")
)
profilTest.save

mapTest = Map.new(
	taille: "16x16",
	difficulte: "Normal"
)
mapTest.save

scoreTest = Score.new(
	montantScore: "2500",
	modeJeu: "Aventure",
	dateObtention: "01/01/2019"
);
scoreTest.profil_id = profilTest.id
scoreTest.map_id = mapTest.id
scoreTest.save

puts profilTest
puts mapTest
puts scoreTest
puts "\n"
