class HudAccueil < Hud
	# @btnConnecter
	# @btnInscrire
	# @btnQuitter
	# @entryIdentifiant
	# @entryMotDePasse

	def initialize(window)
		super(window)
		@entryIdentifiant = Gtk::Entry.new
		@entryMotDePasse = Gtk::Entry.new

		self.initBoutonConnecter
		self.initBoutonInscription
		self.initBoutonQuitter

		self.attach(@btnConnecter,10,10,2,2)
		self.attach(@btnInscrire,8,10,2,2)
		self.attach(@btnQuitter,14,14,4,2)
		self.attach(@entryIdentifiant,10,6,2,2)
		self.attach(@entryMotDePasse,10,8,2,2)
		self.attach(Gtk::Label.new("Identifiant : "),8,6,2,2)
		self.attach(Gtk::Label.new("Mot de passe : "),8,8,2,2)
	end


	def initBoutonConnecter
		@btnConnecter = Gtk::Button.new :label => "Se connecter"
		@btnConnecter.signal_connect("clicked") {
				self.lancementModeJeu
		}
	end

	def initBoutonInscription
		puts "Inscription => Traitement manquant"
		@btnInscrire = Gtk::Button.new :label => "S'inscrire"
	end

	def initBoutonQuitter
		@btnQuitter = Gtk::Button.new :label => "Quitter"
		@btnQuitter.signal_connect('clicked') {	Gtk.main_quit }
	end

end
