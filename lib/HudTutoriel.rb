class HudTutoriel < HudJeu
	def initialize (window,grille)
		super(window,grille)
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		self.styleLabel(@lblAide,'white','normal','large','Bienvenue sur notre super jeu !')
		self.setTitre("Tutoriel")
		@tutoriel = true

		aideTutoriel

		@varBoutonEnPlus=1
		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-3,@sizeGridJeu,@sizeGridJeu+4)

		self.attach(@lblAide,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		image = Gtk::Image.new( :file => "../img/gris.png")
		image.pixbuf = image.pixbuf.scale((@winX/2.5),(@winY/@sizeGridWin)*2)
		self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		ajoutFondEcran
	end

end
