require_relative "HudJeu"

class HudRapide < HudJeu

	TEMPS_FACILE=60*15
	TEMPS_MOYEN=TEMPS_FACILE*2/3
	TEMPS_DIFFICILE=TEMPS_MOYEN/2

	def initialize(window,grille)
		super(window,grille)
		
		case grille.length
			when 6..8 then @temps=TEMPS_FACILE
			when 9..12 then @temps=TEMPS_MOYEN
			when 13..16 then @temps=TEMPS_DIFFICILE
		end
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");
		self.setTitre("Partie rapide")

		initBoutonTimer
		initBoutonPause
		initBoutonAide
		initBoutonResetRapide
		self.attach(@btnPause,@varPlaceGrid-3,0,1,1)
		self.attach(@lblTime,@varPlaceGrid-4,0,1,1)
		self.attach(@btnAide,@varPlaceGrid-2,0,1,1)
		self.attach(@lblAide,1,2, @varPlaceGrid, 1)
		fond = ajoutFondEcran
		self.attach(fond,0,0,@varPlaceGrid+2,5)
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
			@horloge = 
			@horloge = @temps - ((Time.now - @timer) - @stockHorloge)
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			@lblTime.set_label(strMinutes + ":" + strSecondes)
			if @horloge<=0
				jeuTermine
				return 0
			end
			sleep(1)
		end
	end

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
		@btnAide.signal_connect("clicked") {
			@stockHorloge-=5
		}
	end
end
