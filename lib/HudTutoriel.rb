# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize (window,grille)
		super(window,grille)
		self.setTitre("Tutoriel")
		@@difficulte="Facile"
		@lblTimer.set_visible(false)
	end

	# Surcharge de la méthode jeuTermine de HudJeu
	# pour que le menu de fin de jeu n'affiche pas certains éléments
	def jeuTermine
		self.lancementFinDeJeu(true)
	end

private

	# Redéfinition de la méthode aide de HudJeu
	def afficherAide
		@caseSurbrillanceList = Array.new
		tableau = @aide.cycle("tuto")
		puts(tableau)
		premAide = tableau.at(0)
		puts(tableau.at(0))
		puts(premAide)

		if premAide != nil then
				@gridJeu.get_child_at(premAide.y+1,premAide.x+1).set_image(scaleImage(premAide.affichageSubr))
				@caseSurbrillanceList.push(premAide)
		end

		@lblAide.text = tableau.at(1).to_s

		indice = tableau.at(3)

		if tableau.at(2) != nil
			if tableau.at(2) == false
				lblIndice = @gridJeu.get_child_at(0,indice).child
			else
				lblIndice = @gridJeu.get_child_at(indice,0).child
			end
			lblIndice.color = 'red'
			@lblIndiceSubr = lblIndice
		end
	end
end
