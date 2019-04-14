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


		width = 150

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
				lbl = CustomLabel.new("Identifiant")
				lbl.valign = Gtk::Align::END
				lbl.halign = Gtk::Align::END
				lbl.width_request = width
			hBox.add(lbl)
				@entryIdentifiant.valign = Gtk::Align::END
				@entryIdentifiant.halign = Gtk::Align::START
			hBox.add(@entryIdentifiant)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
				lbl = CustomLabel.new("Mot de passe")
				lbl.width_request = width
			hBox.add(lbl)
			hBox.add(@entryMotDePasse)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
				@btnInscrire.width_request = width
			hBox.add(@btnInscrire)
			hBox.add(@btnConnecter)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
				@btnQuitter.valign = Gtk::Align::END
				@btnQuitter.halign = Gtk::Align::END
			hBox.add(@btnQuitter)
		vBox.add(hBox)


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
				f=IniFile.load("../config/#{@@name}.ini", encoding: 'UTF-8')
				@@winX=f['resolution']['width']
				@@winY=f['resolution']['height']
				self.resizeWindow(@@winX, @@winY)
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
