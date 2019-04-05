require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille,temps)
		super(window,grille)
		@temps = temps*60
		@@malus = 15
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");
		@grille.score.estModeChrono()
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		@t=Thread.new{timer}
		self.setTitre("Partie rapide")

		initBoutonTimer
		initBoutonPause
		initBoutonAide
		initBoutonReset

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
			@horloge = (Time.now - @timer) + @stockHorloge
			@horloge = @temps - @horloge
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			@lblTime.set_label(strMinutes + ":" + strSecondes)
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
<<<<<<< HEAD
			@grille.score.appelerAssistant()
			tableau = @aide.cycle("rapide")
			caseAide = tableau.at(0)
			if caseAide != nil then

					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(scaleImage(caseAide.affichageSubr))
					puts(" X :" + caseAide.x.to_s + " Y :" +caseAide.y.to_s )

			end
			@lblAide.use_markup = true
			@lblAide.set_markup ("<span foreground='white' >"+tableau.at(1)+"</span>");
			@stockHorloge = @stockHorloge-5
=======
			@stockHorloge = @stockHorloge + @@malus
>>>>>>> origin/GTK
		}
	end
end
