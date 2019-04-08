class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(window,grille)
		super(window,grille)
		@@NbPartie += 1


		self.setTitre("Aventure")
		initBoutonTimer
		initBoutonPause
		initBoutonReset

		@varBoutonEnPlus=1
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-1,@sizeGridJeu,@sizeGridJeu+4)

		self.attach(@lblTime,@varDebutPlaceGrid,@varDebutPlaceGrid-2,@sizeGridJeu,1)

		self.attach(@btnPause,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)

		ajoutFondEcran
	end


	# Lance une nouvelle grille plus grande en mode aventure
	def jeuTermine
		lancementAventure(Grille.new(@tailleGrille+(@@NbPartie/5).to_i))
	end
end
