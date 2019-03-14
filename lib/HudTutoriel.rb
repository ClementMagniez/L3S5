class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)

		self.setTitre("Tutoriel")
		self.setDesc("Ici la desc du mode tuto")

		self.initBoutonOptions

		
	end
end
