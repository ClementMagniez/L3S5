require_relative "HudJeu"

class HudRapide < HudJeu
	# @btnPause
	# @timer

	def initialize(window,grille)
		super(window,grille)
		@btnPause = Gtk::Button.new :label => "Pause"
		@lblTime = Gtk::Label.new(" 0:0 ")
		@lblAide = Gtk::Label.new("Bienvenue sur notre super jeu !")
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		self.setTitre("Partie rapide")
		# self.setDesc("Ici la desc du mode rapide")


		# self.initBoutonOptions
		initBoutonPause
		initBoutonAide

		self.attach(@btnAide,@tailleGrille,0,1,1)
		self.attach(@btnPause,@tailleGrille-1,0,1,1)
		self.attach(@lblTime,@tailleGrille-2,0,1,1)

		self.attach(@lblAide, 1, @tailleGrille+2, @tailleGrille+1, 1)

		@t=Thread.new{timer}
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
			@grille.score.appelerAssistant()
			tableau = @aide.cycle("rapide")
			caseAide = tableau.at(0)
			if caseAide != nil then
				puts ("pouetpouetpouet")
				if caseAide.class == CaseCoordonnees

					@gridJeu.get_child_at(caseAide.getJ+1,caseAide.getI+1).set_image(Gtk::Image.new :file => caseAide.getCase.affichageSubr)
					puts(" X :" + caseAide.getI.to_s + " Y :" +caseAide.getJ.to_s )

					@caseSurbrillance =caseAide
				end

			end

			@lblAide.set_label(tableau.at(1))

		}
	end
end
