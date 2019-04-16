class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(grille)
		super(grille)
		self.setTitre("Aventure")
		@@NbPartie += 1
		@btnAide.destroy
		@gridLblAide.destroy
	end

	# Redéfinie la méthode jeuTermine de HudJeu.
	# La méthode va maintenant lancer une autre grille (toujours en mode aventure) de plus en plus grande
	def jeuTermine
		lancementAventure(Grille.new(@grille.length+(@@NbPartie % 5 == 0 ? 1 : 0).to_i))
	end
end
