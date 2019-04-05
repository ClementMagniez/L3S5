class HudFinDeJeu < Hud
	#@btnRecommencer
	#@btnModeDeJeu

	def initialize(window,fenetrePrecedente)
		super(window)
		varX, varY = 2, 2
		@fenetrePrecedente = fenetrePrecedente
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		@lblAide.set_markup ("<span foreground='black' weight='ultrabold' size='x-large' > Bravo vous avez fini ! !</span>");


		initBoutonRecommencer
		initBoutonChangerModeDeJeu

		self.attach(@lblAide,0,0,1,1)
		self.attach(@btnRecommencer,varX+1, varY+1, 1, 1)
		self.attach(@btnModeDeJeu, varX+1, varY+2, 1, 1)
			fond = ajoutFondEcran
		self.attach(fond,0,0,varX+3,varY+4)
	end

	def initBoutonRecommencer
		@btnRecommencer = Gtk::Button.new :label => "Recommencer"
		@btnRecommencer.signal_connect('clicked') {
			@fenetrePrecedente.reset
			#@fenetrePrecedente.raz
			@fenetre.changerWidget(self,@fenetrePrecedente)
		}

	end

	def initBoutonChangerModeDeJeu
		@btnModeDeJeu = Gtk::Button.new :label => "Changer de grille"
		@btnModeDeJeu.signal_connect('clicked'){
			self.lancementModeJeu
		}

	end



end
