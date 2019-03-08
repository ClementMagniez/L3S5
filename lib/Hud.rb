require_relative 'Grille'

class Hud < Gtk::Grid
	# @fenetre
	# @btnOptions

	def initialize(window)
		super()
		@fenetre = window

		initBoutonOptions

		self.attach(@btnOptions, 0, 25, 1, 1)
	end



	def lancementAventure(taille)
		# grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"grilles.txt");
		grille = Grille.new(taille,"grilles.txt")
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

	# Créé et initialise le bouton des options
	# Le bouton affiche le menu des options
	def initBoutonOptions
		@btnOptions = Gtk::Button.new(:label=>"Options")
		@btnOptions.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudOption.new(@fenetre))
		}
	end
end
