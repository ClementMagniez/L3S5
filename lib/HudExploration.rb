require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(window,grille)
		super(window,grille)
		self.setTitre("Partie exploration")

	end
end
