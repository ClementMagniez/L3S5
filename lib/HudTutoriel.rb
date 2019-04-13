class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		self.styleLabel(@lblAide,'white','normal','large','Bienvenue sur notre super jeu !')
		self.setTitre("Tutoriel")

		initBoutonAide
		aideTutoriel

		@varBoutonEnPlus=1
		# self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-3,@sizeGridJeu,@sizeGridJeu+4)
		#
		# self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		# self.attach(@lblAide,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)
		#
		# image = Gtk::Image.new( :file => "../img/gris.png")
		# image.pixbuf = image.pixbuf.scale((@winX/2.5),(@winY/@sizeGridWin)*2)
		# self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(@btnRegle)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox2.add(@btnAide)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
			hBox.add(vBox2)
		vBox.add(hBox)
		vBox.add(@lblAide)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@btnOptions)
			hBox.add(@btnRetour)
		vBox.add(hBox)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end


	def aideTutoriel
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



	# Créé et initialise le bouton d'aide
	def initBoutonAide
		taille = @grille.length
		@caseSurbrillanceList = Array.new

		@btnAide = creerBouton(Gtk::Label.new("Aide"),"white","ultrabold","x-large")
		@btnAide.signal_connect("clicked") {
			aideTutoriel
		}
	end

end
