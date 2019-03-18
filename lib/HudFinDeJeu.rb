class HudFinDeJeu < Hud
	#@btnRecommencer
	#@btnModeDeJeu

	def initialize(window,fenetrePrecedente)
		super(window)
		@fenetrePrecedente = fenetrePrecedente
		initBoutonRecommencer
		initBoutonChangerModeDeJeu
		self.attach(@btnRecommencer,8,12,2,2)

		scaleFond
	end

	def initBoutonRecommencer
		@btnRecommencer = Gtk::Button.new :label => "Recommencer"
		@btnRecommencer.signal_connect('clicked') {
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