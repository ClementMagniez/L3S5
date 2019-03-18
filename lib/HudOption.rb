class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(window,fenetrePrecedente)
		super(window)
		@fenetrePrecedente = fenetrePrecedente

		self.setTitre("Options")

		initBoutonFenetre
		initBoutonRetour


		self.attach(Gtk::Label.new("Mode : "),0, 0, 1, 1)
		self.attach(@btnFenetre,1, 0, 1, 1)

		self.attach(@btnRetour,2, 1, 1, 1)
		scaleFond
	end

	def initBoutonFenetre
		if @fenetre.isFullscreen?
			@btnFenetre = Gtk::Button.new :label =>"Fenêtré"
		else
			@btnFenetre = Gtk::Button.new :label =>"Plein écran"
		end
		@btnFenetre.signal_connect('clicked') {
			if @fenetre.isFullscreen?
				@fenetre.unfullscreen
				@btnFenetre.set_label("Plein écran")
			else
				@fenetre.fullscreen
				@btnFenetre.set_label("Fenêtré")
			end
		}
	end

	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") {
				@fenetre.changerWidget(self,@fenetrePrecedente)
		}
	end
end
