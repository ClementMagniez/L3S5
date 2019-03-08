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
		self.setDesc("Ici la description des options")
		@btnOptions.destroy

		initBoutonFenetre
		initBoutonPlEcran
		initBoutonRetour


		self.attach(@btnFenetre,6,4,2,2)
		self.attach(@btnPlEcran,4,4,2,2)
		self.attach(@btnRetour,14,14,4,2)
		self.attach(Gtk::Label.new("Mode : "),2,4,2,2)
	end

	def initBoutonFenetre
		@btnFenetre = Gtk::Button.new :label => "Fenetre"
		@btnFenetre.signal_connect('clicked') {
			#voir pour differente taille de fenetre
			@fenetre.unfullscreen
		}
	end

	def initBoutonPlEcran
		@btnPlEcran = Gtk::Button.new :label =>"Plein écran"
		@btnPlEcran.signal_connect('clicked') {
			if @fullscreen
				@fenetre.unfullscreen
				@fullscreen = false
			else
				@fenetre.fullscreen
				@fullscreen = true
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
