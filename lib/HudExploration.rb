require_relative "HudJeu"

class HudExploration < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		
		
		self.setTitre("Partie exploration")

		initBoutonAide
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-4,
								@sizeGridJeu,@sizeGridJeu+6)

		self.attach(@btnAide,@varFinPlaceGrid-1,@varDebutPlaceGrid-2,4,2)	
		ajoutFondEcran
	end


	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
	end
end
