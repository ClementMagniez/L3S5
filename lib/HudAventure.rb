class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")

			fond = ajoutFondEcran
		self.attach(fond,0,0,@varPlaceGrid+2,5)
	end


	# Lance une nouvelle grille plus grande en mode aventure
	def jeuTermine
		lancementAventure(@tailleGrille+1)
	end
end
