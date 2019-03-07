class HudAventure < Hud 
	def initialize(window,grille,taille,aide)
		super(window)

		#Label titre : MODE AVENTURE 
		@lblTitreAv = Gtk::Label.new(" MODE AVENTURE ")
		self.attach(@lblTitreAv,6,2,4,2)
		#Bouton des aides et du reset de la grille
		@btnAide = Gtk::Button.new :label => " Aide "
		@btnReset = Gtk::Button.new :label => " Reset "
		self.attach(@btnAide,14,4,2,2)
		self.attach(@btnReset,16,4,2,2)

		#Grille de jeu
		@gridJeu = Gtk::Table.new(taille+1,taille+1,true)
		self.attach(@gridJeu,2,8,taille+1,taille+1)

		#Bouton option
		@btnOption = Gtk::Button.new :label => "Options"
		self.attach(@btnOption,2,20,2,2)

		#Bouton retour aux choix de mode de jeu
		# => besoin de confirmation de choix "Etes vous sur de vouloir quitter votre grille?"
		@btnRetour = Gtk::Button.new :label => "Retour"
		self.attach(@btnRetour,16,20,2,2)

		chargementGrille(grille,taille)

	end


end