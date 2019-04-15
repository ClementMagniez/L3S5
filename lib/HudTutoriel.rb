# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize (window,grille)
		super(window,grille)
		self.setTitre("Tutoriel")
		@@difficulte="Facile"
		@lblTime.set_visible(false)
	end

private

	# Redéfinition de la méthode aide de HudJeu
	def aide
		puts "HudTutoriel::aide"
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
