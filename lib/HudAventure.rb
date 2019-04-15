class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(window,grille)
		super(window,grille)
<<<<<<< HEAD
		@@NbPartie += 1


		initBoutonTimer
		initBoutonPause

		self.setTitre("Aventure")

=======
		self.setTitre("Aventure")
>>>>>>> origin/Restructuration

		@@NbPartie += 1
		@varBoutonEnPlus=1

<<<<<<< HEAD
	

		self.attach(@btnPause,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)

		ajoutFondEcran
=======
		@btnAide.set_visible(true)
		@btnAide.sensitive = false
		@btnPause.set_visible(false)
		@btnPause.sensitive = false
		@lblAide.visible = false
>>>>>>> origin/Restructuration
	end

	# Redéfinie la méthode jeuTermine de HudJeu.
	# La méthode va maintenant lancer une autre grille (toujours en mode aventure) de plus en plus grande
	def jeuTermine
		lancementAventure(Grille.new(@tailleGrille+(@@NbPartie % 5 == 0 ? 1 : 0).to_i))
	end
end
