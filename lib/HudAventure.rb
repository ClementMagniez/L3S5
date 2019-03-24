class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		# self.setDesc("Ici la desc du mode aventure")

		#self.initBoutonOptions

		fond = ajoutFondEcran

		self.attach(fond,0,0,@varPlaceGrid+2,5)
	end

	# Comportement a la fin du jeu
	# Lance une nouvelle grille
	def jeuTermine
		self.lancementAventure(@tailleGrille+1)
	end
end
