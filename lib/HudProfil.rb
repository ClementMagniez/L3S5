# Cette classe fait a peu pres les memes choses que HudInscription
require 'inifile'
require "rubygems"
require "digest/sha1"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"

class HudProfil < Hud
	
	def initialize(window)
		super(window)
		self.setTitre("Profil")
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new

		initChampScore
		initBoutonSauvegarderLogin
		initBoutonRetourMenu
		
		# Rend le mot de passe entré invisible
		@entMdp.set_visibility(false)

		# Affichage de l'identifiant de l'utilisateur connecté
		#@lblLogin = Gtk::Label.new($login)
		
		#self.attach(@lblLogin, 0, -1, 2, 1)
		self.attach(Gtk::Label.new("Compte"), 4, 0, 2, 1)
		self.attach(@lblDescription, 4, 1, 2, 1)
		self.attach(Gtk::Label.new("Nouveau nom"), 4, 2, 1, 1)
		self.attach(@entNom, 5, 2, 1, 1)
		self.attach(Gtk::Label.new("Nouveau mot de passe"), 4, 3, 1, 1)
		self.attach(@entMdp, 5, 3, 1, 1)
		self.attach(@btnSauvegardeeLogin, 4, 4, 2, 1)

#		self.attach(@champScores, 0, 4, 2, 4)

		self.attach(@btnRetour, 1, 11, 1, 1)
		
		ajoutFondEcran
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

	def initBoutonSauvegarderLogin
		@btnSauvegardeeLogin = Gtk::Button.new label: "Sauvegarder les modifications"
		@btnSauvegardeeLogin.signal_connect("clicked") {
			strNom = @entNom.text
			strMdp = @entMdp.text
			
			user = Profil.find_by(pseudonyme: $login)
			
			# Si aucun des champs n'est renseigné
			if strNom.empty? && strMdp.empty?
				self.setDesc("Vous devez remplir au moins un champ")
			# Si seul le champ "mot de passe" est renseigné
			elsif(strNom.empty?)
				# Enregistrement du mot de passe crypté
				user.mdpEncrypted = Digest::SHA1.hexdigest(strMdp)
				user.save
				self.setDesc("Modifications enregistrées !")
			# Si seul le champ "identifiant" est renseigné
			elsif(strMdp.empty?)
				# Si l'identifiant est déjà présent dans la base de données
				if Profil.find_by(pseudonyme: strNom) != nil
					self.setDesc("Cet identifiant existe déjà.")
				else
					user.pseudonyme = @entNom.text
					user.save
					
					# Modification de l'affichage de l'identifiant de l'utilisateur connecté
					#$login = strNom
					#@lblLogin.set_label($login)
					
					self.setDesc("Modifications enregistrées !")
				end
			# Si les deux champs sont renseignés
			else
				# Si l'identifiant est déjà présent dans la base de données
				if Profil.find_by(pseudonyme: strNom) != nil
					self.setDesc("Cet identifiant existe déjà.")
				else
					# Modification des informations concernant l'utilisateur dans la base de données
					user.pseudonyme = strNom
					user.mdpEncrypted = Digest::SHA1.hexdigest(strMdp)
					user.save
					
					# Modification de l'affichage de l'identifiant de l'utilisateur connecté
					#$login = strNom
					#@lblLogin.set_label($login)
					
					self.setDesc("Modifications enregistrées !")
				end			
			end
		}
	end

	def initBoutonRetourMenu
		@btnRetour = Gtk::Button.new label: "Retour"
		@btnRetour.signal_connect("clicked") {
			lancementModeJeu
		}
	end
	
	#				width=@menuResolution.split(*)[0].to_i
	#			height=@menuResolution.split(*)[1].to_i
end
