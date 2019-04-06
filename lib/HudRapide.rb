require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer
	def initialize(window,grille,temps)
		super(window,grille)
		@temps = temps*60
		@@malus = 15
		
		self.setTitre("Partie rapide")

		initBoutonTimer
		initBoutonPause
		initBoutonAide
		initBoutonReset
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
			@horloge = (Time.now - @timer) + @stockHorloge
			@horloge = @temps - @horloge
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
			@stockHorloge = @stockHorloge + @@malus
		}
	end
end
