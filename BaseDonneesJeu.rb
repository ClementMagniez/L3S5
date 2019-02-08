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
require "connectSqlite3.rb"
require "Profil.rb"
require "Grille.rb"
require "Score.rb"


profilTest = Profil.new(
	:pseudonyme => "Test",
	:mdp_encrypted => "azerty"
);
profilTest.save;

grilleTest = Grille.new(
	:taille => "16x16",
	:difficulte => "Normal"
);
grilleTest.save;

scoreTest = Score.new(
	:montant_score => "2500"
);
scoreTest.joueur_id = profilTest;
scoreTest.grille_id = grilleTest;
scoreTest.save;
