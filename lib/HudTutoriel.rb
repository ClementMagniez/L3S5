class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");
		self.setTitre("Tutoriel")



		initBoutonAide



		self.attach(@btnAide,@varPlaceGrid-2,0,1,1)
		self.attach(@lblAide,1,2, @varPlaceGrid, 1)
			fond = ajoutFondEcran
		self.attach(fond,0,0,@varPlaceGrid+2,5)
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
					@gridJeu.get_child_at(premAide.getJ+1,premAide.getI+1).set_image(scaleImage(Gtk::Image.new :file => premAide.getCase.affichageSubr))
					@caseSurbrillanceList.push(premAide)
				else
					while not premAide.empty?
						caseAide = premAide.shift
						@gridJeu.get_child_at(caseAide.getJ+1,caseAide.getI+1).set_image(scaleImage(Gtk::Image.new :file => caseAide.getCase.affichageSubr))
						@caseSurbrillanceList.push(caseAide)
					end
				end

			end
			@lblAide.use_markup = true
			@lblAide.set_markup ("<span foreground='white' >"+tableau.at(1)+"</span>");
		}
	end

end
