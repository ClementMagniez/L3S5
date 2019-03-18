class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)
		@lblAide = Gtk::Label.new("Bienvenue sur notre super jeu !")

		self.setTitre("Tutoriel")
		# self.setDesc("Ici la desc du mode tuto")

		# self.initBoutonOptions
		initBoutonAide

		self.attach(@btnAide,@varX+@tailleGrille,@varY,1,1)
		self.attach(@lblAide, @varX+1, @varY+@tailleGrille+2, @tailleGrille+1, 1)
	end

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		taille = @grille.length
		@caseSurbrillanceList = Array.new

		@btnAide = Gtk::Button.new :label => " Aide "
		@btnAide.signal_connect("clicked") {
			tableau = @aide.cycle("tuto")
			premAide = tableau.at(0)
			if premAide != nil then

				if premAide.class == CaseCoordonnees
					@gridJeu.get_child_at(premAide.getJ+1,premAide.getI+1).set_image(Gtk::Image.new :file => premAide.getCase.affichageSubr)
					# puts(" X :" + premAide.getI.to_s + " Y :" +premAide.getJ.to_s )

					@caseSurbrillanceList.push(premAide)
				else
					while not premAide.empty?
						caseAide = premAide.shift
						@gridJeu.get_child_at(caseAide.getJ+1,caseAide.getI+1).set_image(Gtk::Image.new :file => caseAide.getCase.affichageSubr)
						@caseSurbrillanceList.push(caseAide)
					end
				end

			end

			@lblAide.set_label(tableau.at(1))

		}
	end

end
