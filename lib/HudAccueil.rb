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

		initBoutonConnecter
		initBoutonInscription
		initBoutonQuitter



		#fond = Gtk::Image.new( :file => "../img/fond.png")
		#fond.pixbuf = fond.pixbuf.scale(@fenetre.size.fetch(0),@fenetre.size.fetch(1))


		self.attach(@btnConnecter,22,10,4,2)
		self.attach(@btnInscrire,18,10,4,2)
		self.attach(@btnQuitter,26,16,2,2)
		self.attach(@entryIdentifiant,22,6,4,2)
		self.attach(@entryMotDePasse,22,8,4,2)
		self.attach(Gtk::Label.new("Identifiant : "),18,6,4,2)
		self.attach(Gtk::Label.new("Mot de passe : "),18,8,4,2)
		#self.attach(fond,0,0,30,20)

		scaleFond
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
		@btnInscrire.signal_connect('clicked'){
			self.lancementInscription
		}
	end

	def initBoutonQuitter
		@btnQuitter = Gtk::Button.new :label => "Quitter"
		@btnQuitter.signal_connect('clicked') {	Gtk.main_quit }
	end

end
