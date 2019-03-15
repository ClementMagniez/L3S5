class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		self.setDesc("Ici la desc du mode aventure")

		self.initBoutonOptions
	end

	
end
