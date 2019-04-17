# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize(grille,timer=0)
		super(grille,timer)
		self.setTitre("Tutoriel")
		@@difficulte="Facile"
		@btnAide.sensitive = false
		@btnPause.sensitive = false
		@lblTimer.set_visible(false)
		self.afficherAide
	end

	# Surcharge de la méthode jeuTermine de HudJeu
	# pour que le menu de fin de jeu n'affiche pas certains éléments
	def jeuTermine
		self.lancementFinDeJeu(true)
	end

	def reset
		super
		self.afficherAide
	end

protected

	def initIndice(i, isRow)
		super { self.afficherAide }
	end

	def chargementGrille
		super { self.afficherAide }
	end


	# Affiche l'aide pour le mode Tutoriel
	def afficherAide

		super("tuto") do |tableau|
			#Met une liste de case en surbrillance
			listCase = tableau.at(LISTCASES)
			if listCase != nil
				while not listCase.empty?
					caseAide = listCase.pop
					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).replace(scaleImage('../img/Subr.png'))
					@caseSurbrillanceList.push(caseAide)
				end
			end
		end
	end
end
