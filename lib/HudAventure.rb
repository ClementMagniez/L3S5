class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		# self.setDesc("Ici la desc du mode aventure")

		self.initBoutonOptions
	end

	# Comportement a la fin du jeu
	# Lance une nouvelle grille
	def jeuTermine
		self.lancementAventure(@grille.length+1)
	end
end
