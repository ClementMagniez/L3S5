require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(window,grille)
		super(window,grille)
		self.setTitre("Partie exploration")

		 self.remove(@btnPause)
		# @btnPause.sensitive = false
	end
end
