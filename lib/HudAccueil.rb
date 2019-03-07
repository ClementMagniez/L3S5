class HudAccueil < Hud
	def initialize(window)
		super(window)

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

		#Bouton option
		@btnOption = Gtk::Button.new :label => "Options"
		@btnQuitter = Gtk::Button.new :label => "Quitter"

		self.attach(@btnOption,4,14,4,2)
		self.attach(@btnQuitter,14,14,4,2)

		self.initBoutonConnecter
		self.initBoutonQuitter
		self.initBoutonOptions
	end


	def initBoutonConnecter
		@btnConnecter.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudModeDeJeu.new(@fenetre))
		}
	end

	def initBoutonQuitter
		
		@btnQuitter.signal_connect('clicked') { 
			puts "Fermeture de l'application !"
			Gtk.main_quit
		}
	end

end
