class HudPresentationTutoriel < Hud
	def initialize(grille)
		super(Gtk::Orientation::VERTICAL)
		@@joueur.mode = :tutoriel
		@grille=grille

		initBoutonRegle
		initBoutonRetour
		initBoutonContinuer
		@btnRegle.set_text("Règles")


			lbl = CustomLabel.new("Bienvenue dans le mode tutoriel, \ncliquez sur sur \"Continuer\" si vous voulez tester une grille \nou cliquez sur \"Règles\" pour lire les règles avant de jouer !", "lblWhite")
			lbl.vexpand = true
		self.add(lbl)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.valign = Gtk::Align::CENTER
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
			hBox.add(@btnRegle)
			hBox.add(@btnContinuer)
				hbox2=Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				hbox2.valign=Gtk::Align::CENTER
				hbox2.halign=Gtk::Align::END
				hbox2.add(@btnRetour)
			hBox.add(hbox2)
		self.add(hBox)
		self.hexpand = true
		self.vexpand = true
		self.valign = Gtk::Align::CENTER
		self.halign = Gtk::Align::CENTER
	end

private

	def initBoutonContinuer
		@btnContinuer = CustomButton.new("Continuer") do
			 lancementTutoriel(@grille)
		end
	end

	# def initBoutonRegle
	# 	@btnRegle = CustomButton.new("Règles") do
	# 		lancementHudRegle
	# 	end
	# end
end
