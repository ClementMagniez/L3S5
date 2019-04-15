require "rubygems"
#require_relative "connectSqlite3.rb"
#require_relative "Profil.rb"
require_relative "Connexion.rb"

class HudInscription < Hud

	def initialize(fenetre)
		super(fenetre)
		self.setTitre("Inscription")
		@entId = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		# Rend le mot de passe entré invisible
		@entMdp.set_visibility(false)
		@lblErreur = CustomLabel.new
		@lblErreur.color = 'red'

		initBoutonEnregistrement
		initBoutonRetour



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Identifiant"))
			hBox.add(@entId)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Mot de passe"))
			hBox.add(@entMdp)
		vBox.add(hBox)
		vBox.add(@btnEnr)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

private

	#Créé et initialise le bouton s'enregistrer
	def initBoutonEnregistrement
		#Bouton : Enregistrer
		@btnEnr = CustomButton.new("S'enregistrer")
		@btnEnr.signal_connect("clicked") do
			session = Connexion.new
			id = @entId.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			mdp = @entMdp.text
			if id != @entId.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
				puts "Insription : Caractère(s) non autorisé(s)"
			elsif id.length > 32
				@lblErr.text = "Identifiant trop long (> 32) !"
				puts "Connexion : L'identifiant trop long !"
			elsif id.empty?
				@lblErreur.text = "L'identifiant ne peut être vide !"
				puts "Insription : L'identifiant ne peut être vide !"
			elsif mdp.empty?
				@lblErreur.text = "Le mot de passe ne peut être vide !"
				puts "Insription : Le mot de passe ne peut être vide !"
			else
				mdp = session.crypterMdp(mdp)
				if Profil.find_by(pseudonyme: id) != nil
					@lblErreur.set_text("Cet identifiant existe déjà.")
				else
					user = Profil.new(
						pseudonyme: id,
						mdpEncrypted: mdp
					)
					# Sauvegarde du profil dans la BDD
					user.save

					f=IniFile.new(filename:"../config/#{id}.ini", encoding: 'UTF-8')

					# Résolution par défaut - option paresseuse, pourrait dépendre
					# de la taille de la fenêtre
					f['resolution']={'width' => 1280,
													 'height'=> 720}
					f.write

					self.lancementAccueil
				end
			end
		end
	end

	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour")
		@btnRetour.signal_connect("clicked") do
			self.lancementAccueil
		end
	end
end
