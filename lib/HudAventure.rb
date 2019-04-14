class HudAventure < HudJeu
	def initialize(window,grille)
		super(window,grille)

		self.setTitre("Aventure")
		initBoutonTimer
		initBoutonPause
		initBoutonReset

		@varBoutonEnPlus=1
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-2,@sizeGridJeu,@sizeGridJeu+5)

		self.attach(@lblTime,@varDebutPlaceGrid,0,@sizeGridJeu,4)

		self.attach(@btnPause,@varFinPlaceGrid-1,@varDebutPlaceGrid-2,4,2)	
		
		ajoutFondEcran
	end


	# Lance une nouvelle grille plus grande en mode aventure
	def jeuTermine
		lancementAventure(Grille.new(@tailleGrille+1))
	end
end
