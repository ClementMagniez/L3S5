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
			lbl = CustomLabel.new("Bienvenue dans le mode tutoriel !")
			lbl.vexpand = true
		vBox.add(lbl)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.valign = Gtk::Align::CENTER
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
			hBox.add(@btnRegle)
			hBox.add(@btnContinuer)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)
		ajoutFondEcran
	end

	def initBoutonRegle
		@btnRegle = Gtk::Button.new(label: "Regle")
		@btnRegle.signal_connect('clicked'){
			lancementHudRegle
		}
	end

	def initBoutonContinuer
		@btnContinuer = Gtk::Button.new(label: "Continuer")
		@btnContinuer.signal_connect('clicked'){
			 lancementTutoriel(@grille)
		}
	end
end
