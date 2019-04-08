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
		initBoutonAide
		initBoutonPause

		self.attach(@gridJeu,@varDebutPlaceGrid, @varDebutPlaceGrid-1,@sizeGridJeu,@sizeGridJeu+4)

		self.attach(@lblTime,@varDebutPlaceGrid,@varDebutPlaceGrid-2,@sizeGridJeu,1)

		self.attach(@btnAide,@varFinPlaceGrid,@varFinPlaceGrid-6,1,1)
		self.attach(@btnPause,@varFinPlaceGrid,@varFinPlaceGrid-5,1,1)

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
		@btnAide.signal_connect("clicked") {
			@stockHorloge = @stockHorloge - @@malus
		}
	end

	def initBoutonPause
		super
		@btnPause.signal_connect("clicked") {
			@gridJeu.set_visible(!@pause)
			@btnAide.set_sensitive(!@pause)
			@btnReset.set_sensitive(false)
			@btnCancel.set_sensitive(!@pause)
			@btnRemplissage.set_sensitive(!@pause)
		}
	end
end
