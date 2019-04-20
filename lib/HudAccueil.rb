require_relative 'Config'

class HudAccueil < Hud
	def initialize(window)
		@@fenetre = window
#		window.resize(480,270)
		window.set_resizable(false)

		super(Gtk::Orientation::VERTICAL)
		@lblErr = CustomLabel.new("","lblErr")

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

		width = 150

			@lblErr.vexpand = true
			@lblErr.halign = Gtk::Align::CENTER
		self.add(@lblErr)
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
	# 	initialise sont comportement # TODO QUEL comportement ?
	def initBoutonConnecter
		@btnConnecter = CustomButton.new("Se connecter") {
			# Vérification de l'existence du profil dans la BDD
			# session = Connexion.new
			strId = @entryIdentifiant.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			strMdp = @entryMotDePasse.text
			if strId != @entryIdentifiant.text
				@lblErr.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
			elsif strId.length > 32
				@lblErr.text = "Identifiant trop long (> 32) !"
			elsif strId.empty?
				@lblErr.text = "L'identifiant ne peut être vide !"
			elsif strMdp.empty?
				@lblErr.text = "Le mot de passe ne peut être vide !"
			elsif(@@joueur.seConnecter(strId, strMdp) == false)
				@lblErr.text = "Echec : connexion impossible !"
			else
				@@fenetre.set_resizable(true)
				# S'assure que le répertoire est sain
				Dir.mkdir("../saves")	unless Dir.exist?("../saves")
				Dir.mkdir("../config")	unless Dir.exist?("../config")

				unless File.exist?("../config/#{strId}.ini")
					Config.initFile(strId)
				end
				@@config=Config.new(strId)
				@@fenetre.window_position=Gtk::WindowPosition::NONE

				@@fenetre.resize(@@config['resolution']['width'],
												 @@config['resolution']['height'])
				@@fenetre.move(@@config['position']['x'],
											 @@config['position']['y'])

				@@fenetre.fullscreen if @@config['resolution']['fullscreen']

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
