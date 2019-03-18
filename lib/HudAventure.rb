class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		# self.setDesc("Ici la desc du mode aventure")

		#self.initBoutonOptions

		fond = scaleFond
		self.attach(fond,0,0,@tailleGrille+4,@tailleGrille+4)
	end

	# Comportement a la fin du jeu
	# Lance une nouvelle grille
	def jeuTermine
		self.lancementAventure(@tailleGrille+1)
	end
end
