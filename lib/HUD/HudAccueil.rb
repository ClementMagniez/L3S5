class HudAccueil < Hud
	def initialize(window)
		super(window)
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

		# Rend le mot de passe entré invisible
		@entryMotDePasse.set_visibility(false)

		@lblErreur = Gtk::Label.new("Connectez-vous !")

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
			#hBox.homogeneous = true
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
				@btnQuitter.valign = Gtk::Align::END
				@btnQuitter.halign = Gtk::Align::END
			hBox.add(@btnQuitter)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)

	end


private

	# Initialise le bouton de connection
	# 	ajoute une variable d'instance @btnConnecter
	# 	initialise sont comportement
	def initBoutonConnecter
		@btnConnecter = CustomButton.new("Se connecter") {
			# Vérification de l'existence du profil dans la BDD
			if @entryIdentifiant.text.empty? || @entryMotDePasse.text.empty?
				@lblErreur.set_text("Veuillez renseigner tous les champs.")
			elsif(@@joueur.seConnecter(@entryIdentifiant.text(), @entryMotDePasse.text()) == false)
				@lblErreur.set_text("Identifiant ou mot de passe incorrect.")
			else
				f=IniFile.load("../config/#{@@joueur.login}.ini", encoding: 'UTF-8')
				@@winX=f['resolution']['width']
				@@winY=f['resolution']['height']
				self.resizeWindow(@@winX, @@winY)
				self.lancementModeJeu
			end
		}
	end

	# Initialise le bouton d'Inscription
	# 	ajoute une variable d'instance @btnInscrire
	# 	initialise sont comportement
	def initBoutonInscription
		@btnInscrire = CustomButton.new("S'inscrire") do
			self.lancementInscription
		end
	end
end
