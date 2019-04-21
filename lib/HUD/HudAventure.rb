class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(grille,timer=0)
		super(grille,timer)
		@@NbPartie += 1
		@btnAide.destroy
		self.initBoutonAide
	end

	# Redéfinie la méthode jeuTermine de HudJeu.
	# La méthode va maintenant lancer une autre grille (toujours en mode aventure) de plus en plus grande
	def jeuTermine
		@@joueur.score = @@joueur.score + @grille.score.calculerScoreFinal
		lancementAventure(Grille.new(@grille.length+(@@NbPartie % 5 == 0 ? 1 : 0).to_i), @timer)
	end

	def reloadScore
		@lblScore.set_text("Score : " + (@grille.score.getValeur + @@joueur.score).to_i.to_s)
	end

	# Redéfinis l'initialisation du bouton retour pour que celui-ci lance le menu de fin de jeu
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour") do
			self.lancementFinDeJeu
		end
	end
end
