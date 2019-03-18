class HudAccueil < Hud
	# @btnConnecter
	# @btnInscrire
	# @btnQuitter
	# @entryIdentifiant
	# @entryMotDePasse

	def initialize(window)
		super(window)
		varX, varY = 0, 0
		@entryIdentifiant = Gtk::Entry.new
		@entryMotDePasse = Gtk::Entry.new

		initBoutonConnecter
		initBoutonInscription
		initBoutonQuitter



		#fond = Gtk::Image.new( :file => "../img/fond.png")
		#fond.pixbuf = fond.pixbuf.scale(@fenetre.size.fetch(0),@fenetre.size.fetch(1))



		self.attach(Gtk::Label.new("Identifiant : "),varX+1, varY+1, 1, 1)
		self.attach(@entryIdentifiant,varX+2, varY+1, 1, 1)

		self.attach(Gtk::Label.new("Mot de passe : "),varX+1, varY+2, 1, 1)
		self.attach(@entryMotDePasse,varX+2, varY+2, 1, 1)


		self.attach(@btnInscrire,varX+1, varY+3, 1, 1)
		self.attach(@btnConnecter,varX+2, varY+3, 1, 1)

		self.attach(@btnOptions, varX, varY+4, 1, 1)
		self.attach(@btnQuitter,varX+3, varY+4, 1, 1)
		# self.attach(fond,0,0,30,20)

		fond = scaleFond
		self.attach(fond,0,0,5,5)
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
