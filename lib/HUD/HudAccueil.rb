require_relative '../util/Config'

class HudAccueil < Hud
	def initialize(window)
		@@fenetre = window

		window.set_resizable(false)

		super(Gtk::Orientation::VERTICAL)
		@lblErreur = CustomLabel.new("","lblErr")

		@entryIdentifiant = Gtk::Entry.new
		@entryMotDePasse = Gtk::Entry.new
		@entryMotDePasse.set_visibility(false)


		initBoutonInscription
		initBoutonConnecter
		initBoutonQuitter


		# Rend le mot de passe entré invisible
		@entryMotDePasse.set_visibility(false)

		width = 150

			@lblErreur.vexpand = true
			@lblErreur.halign = Gtk::Align::CENTER
		self.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			# hBox.homogeneous = true
				lbl = CustomLabel.new("Identifiant")
				lbl.valign = Gtk::Align::END
				lbl.halign = Gtk::Align::END
				lbl.width_request = width
			hBox.add(lbl)
				@entryIdentifiant.valign = Gtk::Align::END
				@entryIdentifiant.halign = Gtk::Align::START
			hBox.add(@entryIdentifiant)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			#hBox.homogeneous = true
				lbl = CustomLabel.new("Mot de passe")
				lbl.width_request = width
			hBox.add(lbl)
			hBox.add(@entryMotDePasse)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
				@btnInscrire.width_request = width
			hBox.add(@btnInscrire)
			hBox.add(@btnConnecter)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnQuitter.valign = Gtk::Align::END
				@btnQuitter.halign = Gtk::Align::END
			hBox.add(@btnQuitter)
		self.add(hBox)
	end


private

	# Initialise le bouton de connection
	# 	ajoute une variable d'instance @btnConnecter
	def initBoutonConnecter
		@btnConnecter = CustomButton.new("Se connecter") do
			# Vérification de l'existence du profil dans la BDD


			strNom = @entryIdentifiant.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			strMdp = @entryMotDePasse.text

			if strNom != @entryIdentifiant.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
			elsif strNom.length > 32
				@lblErreur.text = "Identifiant trop long (> 32) !"
			elsif strMdp.length < 2
				@lblErreur.text = "Le mot de passe doit faire au moins 2 caractères"
			elsif strNom.empty?
				@lblErreur.text = "L'identifiant ne peut être vide !"
			elsif !@@joueur.seConnecter(strNom, strMdp)
				@lblErreur.text = "Echec : connexion impossible !"
			else
				@@fenetre.set_resizable(true)
				# S'assure que le répertoire est sain
				Dir.mkdir("../saves")	 unless Dir.exist?("../saves")
				Dir.mkdir("../config") unless Dir.exist?("../config")
				Config.initFile(strNom) unless File.exist?("../config/#{strNom}.ini")
				
				@@config=Config.new(strNom)
				@@fenetre.window_position=Gtk::WindowPosition::NONE

				@@fenetre.resize(@@config.width,
												 @@config.height)
				@@fenetre.move(@@config.x,
											 @@config.y)

				@@fenetre.fullscreen if @@config.fullscreen

				self.lancementModeJeu
			end
		end
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
