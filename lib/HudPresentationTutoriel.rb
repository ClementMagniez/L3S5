class HudPresentationTutoriel < Hud
	def initialize (window,grille)
		super(window)
		@grille=grille


		initBoutonRegle
		initBoutonContinuer


		# self.attach(styleLabel(Gtk::Label.new,"white","ultrabold","x-large","Bienvenue dans le mode tutoriel !"),0,0,1,1)
		# self.attach(@btnContinuer,(@sizeGridWin/4)*2,(@sizeGridWin/4)*3,1,1)
		# self.attach(@btnRegle,@sizeGridWin/4,(@sizeGridWin/4)*3,1,1)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(styleLabel(Gtk::Label.new,"white","ultrabold","x-large","Bienvenue dans le mode tutoriel !"))
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@btnContinuer)
			hBox.add(@btnRegle)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)
		ajoutFondEcran
	end

	def initBoutonRegle
		@btnRegle = creerBouton(Gtk::Label.new("Regle"),"white","ultrabold","x-large")
		@btnRegle.signal_connect('clicked'){
			lancementHudRegle
		}
	end

	def initBoutonContinuer
		@btnContinuer = creerBouton(Gtk::Label.new("Continuer"),"white","ultrabold","x-large")
		@btnContinuer.signal_connect('clicked'){
			 lancementTutoriel(@grille)
		}
	end
end
