class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		self.styleLabel(@lblAide,'white','normal','large','Bienvenue sur notre super jeu !')
		self.setTitre("Tutoriel")

		initBoutonAide

		@varBoutonEnPlus=1
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-3,@sizeGridJeu,@sizeGridJeu+4)

		self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		self.attach(@lblAide,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)
		
		image = Gtk::Image.new( :file => "../img/gris.png")
		image.pixbuf = image.pixbuf.scale((@winX/2.5),(@winY/@sizeGridWin)*2)
		self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		ajoutFondEcran
	end

	

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		taille = @grille.length
		@caseSurbrillanceList = Array.new

		@btnAide = Gtk::Button.new 
		styleBouton(@btnAide,Gtk::Label.new("Aide"),"white","ultrabold","x-large")
		@btnAide.signal_connect("clicked") {
			tableau = @aide.cycle("tuto")
			puts(tableau)
			premAide = tableau.at(0)
			puts("pouet")
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

		}
	end

end
