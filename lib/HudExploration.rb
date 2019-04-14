require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(window,grille)
		super(window,grille)
		self.setTitre("Partie exploration")

		@btnPause.visible = false
		@btnPause.sensitive = false
	end


	# Créé et initialise le bouton d'aide
	def initBoutonAide
		super
		aide
	end
end
