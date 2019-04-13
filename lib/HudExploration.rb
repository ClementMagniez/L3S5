require_relative "HudJeu"

class HudExploration < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)


		self.setTitre("Partie exploration")

		initBoutonAide
		initBoutonTimer
		# self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-3,@sizeGridJeu,@sizeGridJeu+4)
		#
		# self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				@lblTime.hexpand = true
				@lblTime.halign = Gtk::Align::CENTER
			hBox.add(@lblTime)
			hBox.add(@btnRegle)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox2.valign = Gtk::Align::CENTER
				vBox2.add(@btnAide)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
			hBox.add(vBox2)
		vBox.add(hBox)
		vBox.add(@lblAide)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
				@btnRetour.valign = Gtk::Align::END
				@btnRetour.halign = Gtk::Align::END
			hBox.add(@btnRetour)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end


	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
	end
end
