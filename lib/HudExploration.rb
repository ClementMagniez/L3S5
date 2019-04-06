require_relative "HudJeu"

class HudExploration < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		
		
		self.setTitre("Partie exploration")

		initBoutonAide
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-3,@sizeGridJeu,@sizeGridJeu+4)

		self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		ajoutFondEcran
	end


	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
	end
end
