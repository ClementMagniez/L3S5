require_relative "HudJeu"

class HudExploration < HudJeu

	def initialize(grille,timer=0)
		super(grille,timer)
		# nombre d'aide demandé par l'utilisateur
		# Si ce nombre d'aide est trop élevé, les aides ne sont plus disponibles
		# Le maximum d'aide est proportionnel à la taille de la grille
		# nbAideMax = tailleGrille
		@nbAides = 0
	end

	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") do
			@grille.score.valeur=Math.sqrt(@grille.score.valeur).to_i
			self.reloadScore
			@nbAides += 1
			if @nbAides > @grille.length
				@btnAide.sensitive = false
				@lblAide.text = "Nombre maximal d'aide demandé !"
			end
		end
	end

end
