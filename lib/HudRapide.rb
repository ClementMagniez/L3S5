class HudRapide < HudJeu
	def initialize(window,grille,aide)
		super(window,grille,aide)

		#Label titre : MODE AVENTURE
		@lblTitreAv = Gtk::Label.new(" MODE RAPIDE ")
		self.attach(@lblTitreAv,6,2,4,2)
		#Bouton des aides et du reset de la grille
		# self.attach(@btnAide,taille+4,taille,2,1)
		# self.attach(@btnReset,taille+4,taille+1,2,1)

		#Timer
		#@lblTime = Gtk::Label.new (" Time : 0:00")
		#@timer = Gtk::Timer.new
		#@lblTime.set_label(@timer.start)

		#self.attach(@lblTime,taille+4,taille-2,2,1)

		#Bouton pause
		@btnPause = Gtk::Button.new :label => "Pause"
		self.attach(@btnPause,taille+4,taille-1,2,1)


		#Grille de jeu
		@gridJeu = Gtk::Table.new(taille+1,taille+1,true)
		self.attach(@gridJeu,2,4,taille+1,taille+1)

		#Bouton option
		@btnOption = Gtk::Button.new :label => "Options"
		self.attach(@btnOption,2,25,2,2)

		#Bouton retour aux choix de mode de jeu
		# => besoin de confirmation de choix "Etes vous sur de vouloir quitter votre grille?"
		# @btnRetour = Gtk::Button.new :label => "Retour"
		# self.attach(@btnRetour,16,25,2,2)

		#Chargement de la grille et mise en place de la liste de bouton que contient la grille
		# @listBouton = chargementGrille(grille,taille)
		self.chargementGrille
		#Label d'aide
		@lblAide = Gtk::Label.new("Bonjour et bienvenue sur notre super jeu !")
		self.attach(@lblAide,taille+15,taille/2+3,5,5)

		self.initBoutonOptions
		# self.initBoutonReset(taille,grille,@listBouton)
		# self.initBoutonAide(aide)
		self.initBoutonPause
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
