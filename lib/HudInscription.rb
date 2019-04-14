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
		@lblErreur = Gtk::Label.new

		initBoutonEnregistrement
		initBoutonRetour



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(CustomLabel.new("Identifiant"))
			hBox.add(@entId)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
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
	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") do
			self.lancementAccueil
		end
	end

	#Créé et initialise le bouton s'enregistrer
	def initBoutonEnregistrement
		#Bouton : Enregistrer
		@btnEnr = Gtk::Button.new :label => "S'enregistrer"
		@btnEnr.signal_connect("clicked") do
			if @entMdp.text.empty? || @entId.text.empty?
				@lblErreur.set_label("Veuillez renseigner toutes les informations.")
			else
				#@lblErreur.set_label("Enregistrement base de donnée à faire.")
				session = Connexion.new
				
				id = @entId.text
				mdp = @entMdp.text
				mdp = session.crypterMdp(mdp)
				#mdp = mdp.crypt(mdp)
			
				if Profil.find_by(pseudonyme: id) != nil
					@lblErreur.set_label("Cet identifiant existe déjà.")
				else
					user = Profil.new(
						pseudonyme: id,
						mdpEncrypted: mdp
					)
					# Sauvegarde du profil dans la BDD
					user.save
					# TODO : créer le fichier de config non-vide (fullscreen / résolution)		
#					File.open("../config/#{id}.ini", "w+") # Création du fichier de config (vide)

					self.lancementModeJeu
				end
			end
		end
	end
end
