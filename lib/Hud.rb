require_relative 'Grille'
require 'gtk3'
class Hud < Gtk::Grid
	def initialize(window)
		super()
		@fenetre = window
	end


	def lancementAventure(taille)
		grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"grilles.txt");
		aide = Aide.new(grille)
		@fenetre.changerWidget(self,HudAventure.new(@fenetre,grille,aide))
	end

	def lancementRapide(taille)
		grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"grilles.txt");
		aide = Aide.new(grille)
		@fenetre.changerWidget(self,HudRapide.new(@fenetre,grille,aide))
	end

	def lancementModeJeu
		puts "Retour au menu"
		@fenetre.changerWidget(self, HudModeDeJeu.new(@fenetre))
	end

	# initialise le bouton des options
	# affiche le menu des options
	def initBoutonOptions
		@btnOption.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudOption.new(@fenetre))
		}
	end
end
