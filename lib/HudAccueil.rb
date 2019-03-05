class HudAccueil < Gtk::Grid
	def initialize(window)
		super()
		@fenetre=window
		#Boutons : S'inscrire et Se connecter
		@btnInscrire = Gtk::Button.new
		@btnInscrire.set_label("S'inscrire")
		@btnConnecter = Gtk::Button.new
		@btnConnecter.set_label("Se connecter")

		#Mise des boutons dans la grille
		self.attach(@btnInscrire,8,10,2,2)
		self.attach(@btnConnecter,10,10,2,2)

		#Entrée de texte : Identifiant et Mot de passe
		@entIdentifiant = Gtk::Entry.new
		@entMotDePasse = Gtk::Entry.new

		#Mise des entrées dans la grille
		self.attach(@entIdentifiant,8,6,4,2)
		self.attach(@entMotDePasse,8,8,4,2)

		self.initBoutonConnecter
	end


	def initBoutonConnecter
		@btnConnecter.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudModeDeJeu.new(@fenetre))
		}
	end
end
