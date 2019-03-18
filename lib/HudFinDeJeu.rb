class HudFinDeJeu < Hud
	#@btnRecommencer
	#@btnModeDeJeu

	def initialize(window,fenetrePrecedente)
		super(window)
		varX, varY = 0, 0
		@fenetrePrecedente = fenetrePrecedente

		initBoutonRecommencer
		initBoutonChangerModeDeJeu

		self.attach(@btnRecommencer,varX+1, varY+1, 1, 1)
		self.attach(@btnModeDeJeu, varX+1, varY+2, 1, 1)
	end

	def initBoutonRecommencer
		@btnRecommencer = Gtk::Button.new :label => "Recommencer"
		@btnRecommencer.signal_connect('clicked') {
			@fenetrePrecedente.reset
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
