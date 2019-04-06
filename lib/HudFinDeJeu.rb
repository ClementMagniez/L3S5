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
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='black' weight='ultrabold' size='x-large' > Bravo vous avez fini ! !</span>");
		lblScore = Gtk::Label.new("Score = 0")
		# lblScore = Gtk::Label.new("Score = " + fenetrePrecedente.grille.calculerScoreFinal)

		initBoutonRecommencer
		initBoutonChangerModeDeJeu

		self.attach(@lblAide,0,0,1,1)
		self.attach(lblScore, varX, varY, 1, 1)
		self.attach(@btnRecommencer,varX+1, varY+1, 1, 1)
		self.attach(@btnModeDeJeu, varX+1, varY+2, 1, 1)
		ajoutFondEcran
	end

	def initBoutonRecommencer
		@btnRecommencer = Gtk::Button.new 
		styleBouton(@btnRecommencer,Gtk::Label.new("Recommencer"),"white","ultrabold","x-large")
		@btnRecommencer.signal_connect('clicked') {
			@fenetrePrecedente.reset
			#@fenetrePrecedente.raz
			@fenetre.changerWidget(self,@fenetrePrecedente)
		}

	end

	def initBoutonChangerModeDeJeu
		@btnModeDeJeu = Gtk::Button.new 
		styleBouton(@btnModeDeJeu,Gtk::Label.new("Changer de grille"),"white","ultrabold","x-large")
		@btnModeDeJeu.signal_connect('clicked'){
			self.lancementModeJeu
		}

	end



end