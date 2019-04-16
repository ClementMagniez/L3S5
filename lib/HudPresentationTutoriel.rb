class HudPresentationTutoriel < Hud
	def initialize (grille)
		super()
		@grille=grille

		initBoutonRegle
		initBoutonContinuer


		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			lbl = CustomLabel.new("Bienvenue dans le mode tutoriel, \ncliquez sur sur \"Continuer\" si vous voulez tester une grille \nou cliquez sur \"Règles\" pour lire les règles avant de jouer !")
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

private

	def initBoutonContinuer
		@btnContinuer = CustomButton.new("Continuer")
		@btnContinuer.signal_connect('clicked') do
			 lancementTutoriel(@grille)
		end
	end

	def initBoutonRegle
		@btnRegle = CustomButton.new("Règles")
		@btnRegle.signal_connect('clicked') do
			lancementHudRegle
		end
	end
end
