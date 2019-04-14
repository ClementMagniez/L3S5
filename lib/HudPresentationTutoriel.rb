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
			hBox.add(@btnRegle)
			hBox.add(@btnContinuer)
		vBox.add(hBox)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)
		ajoutFondEcran
	end

	def initBoutonRegle
		@btnRegle = creerBouton(Gtk::Label.new("Regle"),"white","ultrabold","x-large")
		@btnRegle.signal_connect('clicked') do
			lancementHudRegle
		end
	end

	def initBoutonContinuer
		@btnContinuer = creerBouton(Gtk::Label.new("Continuer"),"white","ultrabold","x-large")
		@btnContinuer.signal_connect('clicked') do
			 lancementTutoriel(@grille)
		end
	end
end
