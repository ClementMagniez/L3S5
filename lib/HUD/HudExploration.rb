require_relative "HudJeu"

class HudExploration < HudJeu

	# @see HudJeu#initialize
	def initialize(grille,timer=0)
		super(grille,timer)
		# nombre d'aide demandé par l'utilisateur
		# Si ce nombre d'aide est trop élevé, les aides ne sont plus disponibles
		# Le maximum d'aide est proportionnel à la taille de la grille

		@nbAides = 0
	end

	# @see HudJeu#initBoutonAide ;
	# Génère @nbAides, compteur des appels à l'aide du joueur ; quand ceux-ci
	# dépassent la taille de la grille, rend le bouton d'aide irresponsif				
	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") do
			@grille.score.reduceScoreExplo
			self.reloadScore
			@nbAides += 1
			if @nbAides > @grille.length
				@btnAide.sensitive = false
				@lblAide.text = "Nombre maximal d'aide demandé !"
				desurbrillanceCase
				desurbrillanceIndice
			end
		end
	end
	
	# @see HudJeu#reset ; réinitialise @nbAides à 0
	def reset
		@nbAides=0
		super
	end
end
