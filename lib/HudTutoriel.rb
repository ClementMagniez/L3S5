# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize(grille,timer=0)
		super(grille,timer)
		self.setTitre("Tutoriel")
		@@joueur.difficulte="Facile"
		@btnAide.sensitive = false
		@btnPause.sensitive = false
		@lblTimer.set_visible(false)
		self.afficherAide
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
					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).name="cellJeuSurbri"
					@caseSurbrillanceList.push(caseAide)
				end
			end
		end
	end
end
