require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		@btnPause = Gtk::Button.new :label => "Pause"
		@lblTime = Gtk::Label.new(" 0:0 ")
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
			@lblTime.set_label((@horloge/60).to_i.to_s + ":" + (@horloge%60).to_i.to_s)
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
		taille = @grille.length
		@btnAide = Gtk::Button.new :label => " Aide "
		@btnAide.signal_connect("clicked") {
			tableau = @aide.cycle("rapide")
			caseAide = tableau.at(0)
			if caseAide != nil then
				
					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(Gtk::Image.new :file => caseAide.getCase.affichageSubr)
					puts(" X :" + caseAide.x.to_s + " Y :" +caseAide.y.to_s )

			end
			@lblAide.use_markup = true
			@lblAide.set_markup ("<span foreground='white' >"+tableau.at(1)+"</span>");
		}
	end
end
