class HudOption < Gtk::Grid
	def initialize(window)
		super()
		@fenetre=window

		#Label titre : OPTIONS
		@lblTitreOpt = Gtk::Label.new(" Options ")
		self.attach(@lblTitreOpt,6,2,8,2)

		#label mode de la fenêtre : plein écran ou fenêtré
		@lblMode = Gtk::Label.new("Mode : ")
		self.attach(@lblMode,2,4,2,2)

		#Bouton : Plein écran
		@btnPlEcran = Gtk::Button.new :label =>"- Plein écran -"
		self.attach(@btnPlEcran,4,4,2,2)

		#Bouton : Fenetre
		@btnFenetre = Gtk::Button.new :label => "- Fenetre -"
		self.attach(@btnFenetre,6,4,2,2)

		#Bouton : Retour 
		@btnRetour = Gtk::Button.new :label => "- Retour -"
		self.attach(@btnRetour,14,14,4,2)

		self.initBoutonFenetre
		self.initBoutonPlEcran
		self.initBoutonRetour
	end

	def initBoutonFenetre
		@btnFenetre.signal_connect('clicked') {
			#voir pour differente taille de fenetre
			@fenetre.unfullscreen
		}
	end

	def initBoutonPlEcran
		 @btnPlEcran.signal_connect('clicked') {
		 	@fenetre.fullscreen
		 }
	end

	def initBoutonRetour
		#Pour l'instant il renvoie qu'au menu de connection
		@btnRetour.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudAccueil.new(@fenetre))
		}
	end
end