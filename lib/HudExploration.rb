require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(window,grille)
		super(window,grille)
<<<<<<< HEAD


		self.setTitre("Partie exploration")
		initBoutonTimer
		initBoutonPause
		initBoutonAide
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-1,@sizeGridJeu,@sizeGridJeu+4)
		self.attach(@btnPause,@varFinPlaceGrid,@varFinPlaceGrid-6,1,1)
		self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		ajoutFondEcran
	end


	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
=======
		self.setTitre("Partie exploration")

		@btnPause.visible = false
		@btnPause.sensitive = false
>>>>>>> origin/Restructuration
	end
end
