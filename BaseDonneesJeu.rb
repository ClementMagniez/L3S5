##
# @title Base de Données de l'application "Des tentes et des arbres"
# @author KAJAK Rémi
# @version 0.1
#
# Le fichier "BaseDonneesJeu.rb" contient toutes les instructions nécessaires à la création de la base de données de l'application.
# La bibliothèque SQL utilisé est +SQLite3+. Il fait appel aux classes *Profil*, *Grille* et *Score* pour pouvoir fonctionner correctement.
#
require "rubygems"
require "active_record"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"
require_relative "Grille.rb"
require_relative "Score.rb"


profilTest = Profil.new(
	:pseudonyme => "Test",
	:mdpEncrypted => "azerty"
);
profilTest.save;

grilleTest = Grille.new(
	:taille => "16x16",
	:difficulte => "Normal"
);
grilleTest.save;

scoreTest = Score.new(
	:montantScore => "2500",
	:modeJeu	=> "Aventure",
	:dateObtention => "01/01/2019"
);
scoreTest.joueur_id = profilTest;
scoreTest.grille_id = grilleTest;
scoreTest.save;
