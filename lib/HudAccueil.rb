require_relative "connectSqlite3.rb"
require_relative "Profil.rb"
require_relative "Connexion.rb"

class HudAccueil < Hud
	def initialize(window)
		super(window)
		# varX, varY = 0, 0
		@entryIdentifiant = Gtk::Entry.new
		@entryMotDePasse = Gtk::Entry.new
		@entryMotDePasse.set_visibility(false)

		# TODO TEMPORAIRE - confort de tests
		@entryIdentifiant.text="test"
		@entryMotDePasse.text="test"
		####################################

		initBoutonInscription
		initBoutonConnecter
		initBoutonQuitter



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(Gtk::Label.new("Identifiant"))
			hBox.add(@entryIdentifiant)
			hBox.width_request = 100
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(Gtk::Label.new("Mot de passe : "))
			hBox.add(@entryMotDePasse)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@btnInscrire)
			hBox.add(@btnConnecter)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@btnOptions)
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::END
			hBox.add(@btnQuitter)
				@btnQuitter.valign = Gtk::Align::END
				@btnQuitter.halign = Gtk::Align::END
		vBox.add(hBox)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end


	def initBoutonConnecter
		@btnConnecter = Gtk::Button.new :label => "Se connecter"
		@btnConnecter.signal_connect("clicked") {
			# Vérification de l'existence du profil dans la BDD
			session = Connexion.new

			if @entryIdentifiant.text.empty? || @entryMotDePasse.text.empty?
				puts "Veuillez renseigner tous les champs."
			elsif(session.seConnecter(@entryIdentifiant.text(), @entryMotDePasse.text()) == 1)
				@@name=@entryIdentifiant.text
				self.lancementModeJeu
			else
				# Ici, il faudrait afficher un message d'erreur sur la fenêtre
				puts "Echec : connexion impossible"
			end
		}
	end

	def initBoutonInscription
		@btnInscrire = Gtk::Button.new :label => "S'inscrire"
		@btnInscrire.signal_connect('clicked') do
			self.lancementInscription
		end
	end
end
