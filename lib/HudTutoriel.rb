# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize (window,grille)
#		window.set_hexpand(false)
#		window.set_vexpand(false)

		super(window,grille)
		self.setTitre("Tutoriel")
	end


	# Redéfinition de la méthode aide de HudJeu
	def aide
		@caseSurbrillanceList = Array.new
		tableau = @aide.cycle("tuto")
		puts(tableau)
		premAide = tableau.at(0)
		puts(tableau.at(0))
		puts(premAide)

		if premAide != nil then
				@gridJeu.get_child_at(premAide.y+1,premAide.x+1).set_image(scaleImage(premAide.affichageSubr))
				# puts(" X :" + premAide.x.to_s + " Y :" +premAide.y.to_s )
				@caseSurbrillanceList.push(premAide)

	#		while not premAide.empty?
			#	caseAide = premAide

		#		@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(scaleImage( caseAide.getCase.affichageSubr))
			#	@caseSurbrillanceList.push(caseAide)
		#	end
		end

		@lblAide.use_markup = true
		styleLabel(@lblAide,'white','ultrabold','x-large',tableau.at(1))

		indice = tableau.at(3)

		if tableau.at(2) != nil
			if tableau.at(2) == false
				lblIndice = @gridJeu.get_child_at(0,indice).child
			else
				lblIndice = @gridJeu.get_child_at(indice,0).child
			end
			styleLabel(lblIndice,'red','ultrabold','x-large',lblIndice.text)
			@lblIndiceSubr = lblIndice
		end
	end
end
