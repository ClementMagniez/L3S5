#require "rubygems"
require_relative "../DB/Connexion"
require_relative "../util/Config"

class HudInscription < Hud

	def initialize
		super(Gtk::Orientation::VERTICAL)
		self.setTitre("Inscription")
		@entId = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		# Rend le mot de passe entré invisible
		@entMdp.set_visibility(false)
		@lblErreur = CustomLabel.new('', 'lblErr')

		initBoutonEnregistrement
		initBoutonRetour


		self.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Identifiant"))
			hBox.add(@entId)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Mot de passe"))
			hBox.add(@entMdp)
		self.add(hBox)
		self.add(@btnEnr)
		self.add(@btnRetour)
		self.hexpand = true
		self.vexpand = true
		self.valign = Gtk::Align::CENTER
		self.halign = Gtk::Align::CENTER
	end

private

	#Créé et initialise le bouton s'enregistrer
	def initBoutonEnregistrement
		#Bouton : Enregistrer
		@btnEnr = CustomButton.new("S'enregistrer") do
			id = @entId.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			mdp = @entMdp.text
			if id != @entId.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
				# puts "Insription : Caractère(s) non autorisé(s)"
			elsif id.length > 32
				@lblErr.text = "Identifiant trop long (> 32) !"
				# puts "Connexion : L'identifiant trop long !"
			elsif id.empty?
				@lblErreur.text = "L'identifiant ne peut être vide !"
				# puts "Insription : L'identifiant ne peut être vide !"
			elsif mdp.empty?
				@lblErreur.text = "Le mot de passe ne peut être vide !"
				# puts "Insription : Le mot de passe ne peut être vide !"
			else
				session = Connexion.new
				mdp = session.crypterMdp(mdp)
				if Profil.find_by(pseudonyme: id) != nil
					@lblErreur.text = "Cet identifiant existe déjà !"
				else
					user = Profil.new(
						pseudonyme: id,
						mdpEncrypted: mdp
					)
					# Sauvegarde du profil dans la BDD
					user.save

					# Création du fichier ini par défaut
					Config.initFile(id)

					self.lancementAccueil
				end
			end
		end
	end

	# Le bouton retour lance le menu connexion (HudAccueil) est non plus le menu pricipal (HudModeDeJeu)
	def initBoutonRetour
		super { self.lancementAccueil }
	end
end
