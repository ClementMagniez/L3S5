require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(grille)
		super(grille)
		self.setTitre("Partie exploration")
		# nombre d'aide demandé par l'utilisateur
		# Si ce nombre d'aide est trop élevé, les aides ne sont plus disponibles
		# Le maximum d'aide est proportionnel à la taille de la grille
		# nbAideMax = tailleGrille
		@nbAides = 0
	end

	# @see HudJeu#reset ; de plus, efface l'aide
	def reset
		super
		@lblAide.text=""
	end

	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") {
			@nbAides += 1
			if @nbAides > @grille.length
				@btnAide.sensitive = false
				@lblAide.text = "Nombre maximal d'aide demandé !"
			end
		}
	end

end
