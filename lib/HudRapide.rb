require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		@btnPause = Gtk::Button.new :label => "Pause"
		@lblTime = Gtk::Label.new(" 00:00 ")
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		@t=Thread.new{timer}
		self.setTitre("Partie rapide")



		initBoutonPause
		initBoutonAide



		self.attach(@btnPause,@varPlaceGrid-3,0,1,1)
		self.attach(@lblTime,@varPlaceGrid-4,0,1,1)
		self.attach(@btnAide,@varPlaceGrid-2,0,1,1)
		self.attach(@lblAide,1,2, @varPlaceGrid, 1)
			fond = ajoutFondEcran
		self.attach(fond,0,0,@varPlaceGrid+2,5)
	end

	def timer
		while true do
			@horloge = (Time.now - @timer) + @stockHorloge
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			@lblTime.set_label(strMinutes + ":" + strSecondes)
			sleep 1
		end
	end

	def initBoutonPause
		@btnPause.signal_connect('clicked'){
			if @pause
				@timer = Time.now
				@t = Thread.new{timer}
				@btnPause.set_label("Pause")
				@pause = false
			else
				@stockHorloge = @stockHorloge + (Time.now - @timer)
				@t.kill
				@btnPause.set_label("Play")
				@pause = true
			end
		}

	end
	def initBoutonReset
		super()
		@btnReset.signal_connect("clicked") {
			@t.kill
			@stockHorloge =0
			@timer = Time.now
			@t = Thread.new{timer}
			if @pause
				@btnPause.set_label("Pause")
			end
		}

	end
	# Créé et initialise le bouton d'aide
	def initBoutonAide
		aide
		@btnAide.signal_connect("clicked") {
			@stockHorloge = @stockHorloge-5
		}
	end
end
