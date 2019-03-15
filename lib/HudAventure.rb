class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		self.setDesc("Ici la desc du mode aventure")

		self.initBoutonOptions
	end

<<<<<<< HEAD
	# Comportement a la fin du jeu
	def jeuTermine
		self.lancementAventure(@grille.length+1)
		
	end
=======
	
>>>>>>> 2742e5a036e76601d3f2f0a6e0e8391263a68349
end
