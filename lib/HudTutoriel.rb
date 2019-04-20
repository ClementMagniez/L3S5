# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - grille : une Grille de jeu
	# - timer : temps au début de la partie, par défaut 0
	# - return une nouvelle instance de HudTutoriel 
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
	# @see HudJeu#initIndice ; de plus, affiche l'aide
	# - return self
	def initIndice(i, isRow)
		super { self.afficherAide }
	end

	# @see HudJeu#chargementGrille ; de plus, affiche l'aide
	# - return self
	def chargementGrille
		super { self.afficherAide }
	end
	
	# @see HudJeu#initIndice ; de plus, affiche  l'aide
	# - return self
	def initBoutonCancel
		super do
			self.afficherAide
		end
	end


	# @see HudJeu#afficherAide ; génère par ailleurs un tableau de cases surlignées
	# - return self
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
	self
	end
end
