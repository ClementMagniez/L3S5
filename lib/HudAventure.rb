class HudAventure < HudJeu
	@@NbPartie = 0

	def initialize(window,grille)
		super(window,grille)
		@@NbPartie += 1


		self.setTitre("Aventure")
		initBoutonTimer
		initBoutonPause
		initBoutonReset

		@varBoutonEnPlus=1
		# self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-1,@sizeGridJeu,@sizeGridJeu+4)
		#
		# self.attach(@lblTime,@varDebutPlaceGrid,@varDebutPlaceGrid-2,@sizeGridJeu,1)
		#
		# self.attach(@btnPause,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@lblTime)
			hBox.add(@btnRegle)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox2.add(@btnPause)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
			hBox.add(vBox2)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@btnOptions)
			hBox.add(@btnRetour)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end


	# Lance une nouvelle grille plus grande en mode aventure
	def jeuTermine
		lancementAventure(Grille.new(@tailleGrille+(@@NbPartie/5).to_i))
	end
end
