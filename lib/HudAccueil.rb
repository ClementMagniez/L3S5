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



		fond = Gtk::Image.new( :file => "../img/fond.png")
		#fond.pixbuf = fond.pixbuf.scale(@fenetre.size.fetch(0),@fenetre.size.fetch(1))



		self.attach(Gtk::Label.new("Identifiant : "),1, 1, 1, 1)
		self.attach(@entryIdentifiant,2, 1, 1, 1)

		self.attach(Gtk::Label.new("Mot de passe : "),1, 2, 1, 1)
		self.attach(@entryMotDePasse,2, 2, 1, 1)


		self.attach(@btnInscrire,1, 3, 1, 1)
		self.attach(@btnConnecter,2, 3, 1, 1)

		self.attach(@btnOptions, 0, 4, 1, 1)
		self.attach(@btnQuitter,3, 4, 1, 1)
		# self.attach(fond,0,0,30,20)
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
