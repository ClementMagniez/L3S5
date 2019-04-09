require "rubygems"
require 'digest/sha1'
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"
require_relative "Connexion.rb"
require_relative "HudAccueil.rb"

# Cette classe fait a peut pres les memes choses que HudInscription
class HudProfil < Hud
	def initialize(window)
		super(window)
		self.setTitre("Profil")
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new



		initChampScore
		initBoutonSauvegarder
		initBoutonRetourMenu

		@lblLogin = Gtk::Label.new($login)
		
		self.attach(@lblLogin, 0, -1, 2, 1)

		self.attach(@lblDescription, 0, 0, 2, 1)
		self.attach(Gtk::Label.new("Nouvel identifiant"), 0, 1, 1, 1)
		self.attach(@entNom, 1, 1, 1, 1)
		self.attach(Gtk::Label.new("Nouveau mot de passe"), 0, 2, 1, 1)
		self.attach(@entMdp, 1, 2, 1, 1)

		self.attach(@champScores, 0, 4, 2, 4)

		self.attach(@btnSauvegarde, 0, 11, 2, 1)
		self.attach(@btnRetour, 0, 12, 2, 1)
	end

	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		@champScores.set_min_content_height(100)
			boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				0.upto(10) do |i|
					boxChamp.add(Gtk::Label.new("choix " + i.to_s))
				end
			@champScores.add(boxChamp)
		@champScores.set_visible(true)
	end

	def initBoutonSauvegarder
		@btnSauvegarde = Gtk::Button.new label: "Sauvegarder"
		@btnSauvegarde.signal_connect("clicked") {
			strNom = @entNom.text
			strMdp = @entMdp.text
			
			user = Profil.find_by(pseudonyme: $login)
			
			if(strNom.empty?)
				self.setDesc("L'identifiant ne peut etre vide !")
			elsif(strMdp.empty?)
				self.setDesc("Le mot de passe ne peut etre vide !")
			else
				if Profil.find_by(pseudonyme: strNom) != nil
					self.setDesc("Cet identifiant existe déjà.")
				else
					user.pseudonyme = strNom
					user.mdpEncrypted = Digest::SHA1.hexdigest(strMdp)
					user.save
					$login = strNom
					self.setDesc("Modifications enregistrées !")
					@lblLogin.set_label($login)
				end			
			end
		}
	end

	def initBoutonRetourMenu
		@btnRetour = Gtk::Button.new label: "Retour"
		@btnRetour.signal_connect("clicked") {
			puts "Retour au menu"
			lancementModeJeu
		}
	end
end
