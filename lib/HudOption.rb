class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(window,fenetrePrecedente)
		super(window)
		@fenetrePrecedente = fenetrePrecedente
		@fullscreen = false

		self.setTitre("Options")
		@btnOptions.destroy

		initBoutonFenetre
		initBoutonRetour


		self.attach(@btnFenetre,6,4,2,2)
		self.attach(@btnRetour,14,14,4,2)
		self.attach(Gtk::Label.new("Mode : "),2,4,2,2)
	end

	def initBoutonFenetre
		@btnFenetre = Gtk::Button.new :label =>"Plein écran"
		@btnFenetre.signal_connect('clicked') {
			if @fullscreen
				@fenetre.unfullscreen
				@fullscreen = false
				@btnFenetre.set_label("Plein écran")
			else
				@fenetre.fullscreen
				@fullscreen = true
				@btnFenetre.set_label("Fenetré")
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
