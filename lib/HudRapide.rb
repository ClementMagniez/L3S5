require_relative "HudJeu"

class HudRapide < HudJeu

	TEMPS_FACILE=60*15
	TEMPS_MOYEN=TEMPS_FACILE*2/3
	TEMPS_DIFFICILE=TEMPS_MOYEN/2

	def initialize(window,grille)
		super(window,grille)

		@@malus = 15
		case grille.length
			when 6..8 then @temps=TEMPS_FACILE
			when 9..12 then @temps=TEMPS_MOYEN
			when 13..16 then @temps=TEMPS_DIFFICILE
		end

		self.setTitre("Partie rapide")

		initBoutonTimer

		initBoutonPause
		initBoutonAide
		
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hbox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				@lblTime.hexpand = true
				@lblTime.halign = Gtk::Align::CENTER
			hbox.add(@lblTime)
			hbox.add(@btnRegle)
		vBox.add(hbox)
			hbox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hbox.halign = Gtk::Align::CENTER
			hbox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox2.valign = Gtk::Align::CENTER
				vBox2.add(@btnAide)
					@btnPause.vexpand = true
				vBox2.add(@btnPause)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
			hbox.add(vBox2)
		vBox.add(hbox)
		vBox.add(@lblAide)
			hbox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hbox.vexpand = true
			hbox.hexpand = true
			hbox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hbox.add(@btnOptions)
				@btnRetour.valign = Gtk::Align::END
				@btnRetour.halign = Gtk::Align::END
			hbox.add(@btnRetour)
		vBox.add(hbox)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran			

	end

	def initBoutonTimer
		super()
		if @temps < 10
			@lblTime.set_label("0" + @temps.to_s + ":00")
		else
			@lblTime.set_label(@temps.to_s + ":00")
		end
	end

	def timer
		while true do
			@horloge = @temps - ((Time.now - @timer) - @stockHorloge)
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			styleLabel(@lblTime,"white","ultrabold","xx-large",strMinutes + ":" + strSecondes)
			if @horloge<=0
				jeuTermine
				return 0
			end

			sleep 1

		end
	end

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
		@btnAide.signal_connect("clicked") do
			@stockHorloge = @stockHorloge - @@malus
		end
	end

	def initBoutonPause
		super
		@btnPause.signal_connect("clicked") do
			@gridJeu.set_visible(!@pause)
			@btnAide.set_visible(!@pause)
			@btnReset.set_visible(!@pause)
			@btnCancel.set_visible(!@pause)
			@btnRemplissage.set_visible(!@pause)
			@btnSauvegarde.set_visible(!@pause)
			@lblAide.set_visible(!@pause)
		end
	end
end
