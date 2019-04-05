require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");
		self.setTitre("Partie rapide")

		initBoutonTimer
		initBoutonPause
		initBoutonAide
		initBoutonResetRapide

		self.attach(@btnPause,@varPlaceGrid-3,0,1,1)
		self.attach(@lblTime,@varPlaceGrid-4,0,1,1)
		self.attach(@btnAide,@varPlaceGrid-2,0,1,1)
		self.attach(@lblAide,1,2, @varPlaceGrid, 1)
		fond = ajoutFondEcran
		self.attach(fond,0,0,@varPlaceGrid+2,5)
	end



	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
		@btnAide.signal_connect("clicked") {
			@stockHorloge = @stockHorloge-5
		}
	end
end
