class HudFinDeJeu < Hud
	#@btnRecommencer
	#@btnModeDeJeu

	# Nouvelle instance de fin de jeu
	# 	window : La Fenetre contenant le HudFinDeJeu
	# 	fenetrePrecedente : Le HudJeu qui appel ce constructeur, permet de recommencer une meme partie
	def initialize(window, fenetrePrecedente)
		super(window)
		varX, varY = 2, 2
		@fenetrePrecedente = fenetrePrecedente
		@lblAide = Gtk::Label.new
		# @lblAide.use_markup = true
		# @lblAide.set_markup ("<span foreground='black' weight='ultrabold' size='x-large' > Bravo vous avez fini ! !</span>");
		lblScore = CustomLabel.new("Votre score : 0")
		# lblScore = Gtk::Label.new("Score = " + fenetrePrecedente.grille.calculerScoreFinal)

		initBoutonRecommencer
		initBoutonChangerModeDeJeu

		# self.attach(@lblAide,0,0,1,1)
		# self.attach(lblScore, varX, varY, 1, 1)
		# self.attach(@btnRecommencer,varX+1, varY+1, 1, 1)
		# self.attach(@btnModeDeJeu, varX+1, varY+2, 1, 1)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			lblTxt = CustomLabel.new("Bravo, vous avez fini !")
			lblTxt.vexpand = true
		vBox.add(lblTxt)
			lblScore.vexpand = true
		vBox.add(lblScore)
			@btnRecommencer.hexpand = false
			@btnRecommencer.halign = Gtk::Align::CENTER
		vBox.add(@btnRecommencer)
			@btnModeDeJeu.vexpand = true
			@btnModeDeJeu.hexpand = false
			@btnModeDeJeu.halign = Gtk::Align::CENTER
			@btnModeDeJeu.valign = Gtk::Align::START
		vBox.add(@btnModeDeJeu)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

	def initBoutonRecommencer
		@btnRecommencer = creerBouton(Gtk::Label.new("Recommencer"),"white","ultrabold","x-large")
		@btnRecommencer.signal_connect('clicked') {
			@fenetrePrecedente.reset
			#@fenetrePrecedente.raz
			@fenetre.changerWidget(self,@fenetrePrecedente)
		}

	end

	def initBoutonChangerModeDeJeu
		@btnModeDeJeu = creerBouton(Gtk::Label.new("Retour au menu"),"white","ultrabold","x-large")
		@btnModeDeJeu.signal_connect('clicked'){
			self.lancementModeJeu
		}

	end



end
