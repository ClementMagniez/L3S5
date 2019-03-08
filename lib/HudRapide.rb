class HudRapide < HudJeu
	# @btnPause
	# @timer
	
	def initialize(window,grille)
		super(window,grille)
		@btnPause = Gtk::Button.new :label => "Pause"

		self.setTitre("Partie rapide")
		self.setDesc("Ici la desc du mode rapide")


		self.initBoutonOptions
		initBoutonPause

		self.attach(@btnPause,5,0,2,1)
	end

	def initBoutonPause
		@btnPause.signal_connect('clicked'){
			@timer.stop
			@btnPause.set_label("Play")
				@btnPause.signal_connect('clicked'){
					@timer.continue
				}
		}

	end


end
