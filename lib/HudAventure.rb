class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(window,grille)
		super(window,grille)
		self.setTitre("Aventure")

		@@NbPartie += 1
		@varBoutonEnPlus=1

		@btnAide.destroy
		@gridLblAide.destroy
		@btnRetour.text = "Abandonner"
	end

	# Redéfinie la méthode jeuTermine de HudJeu.
	# La méthode va maintenant lancer une autre grille (toujours en mode aventure) de plus en plus grande
	def jeuTermine
		lancementAventure(Grille.new(@tailleGrille+(@@NbPartie % 5 == 0 ? 1 : 0).to_i))
	end
end
