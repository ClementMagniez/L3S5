# Cette classe fait a peut pres les memes choses que HudInscription
require 'inifile'
require "rubygems"
require "digest/sha1"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"

class HudProfil < Hud
	def initialize
		super()
		self.setTitre("Profil")
		@lblErreur = CustomLabel.new
		@lblErreur.color = 'red'
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		@entMdp.set_visibility(false)

		initBoutonRetour
		initBoutonSauvegarderLogin
		initChampScore


		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Nouveau nom"))
			hBox.add(@entNom)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Nouveau mot de passe"))
			hBox.add(@entMdp)
		vBox.add(hBox)
		vBox.add(@champScores)
		vBox.add(@btnSauvegarde)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end


private
	def initBoutonSauvegarderLogin
		@btnSauvegarde = CustomButton.new("Sauvegarder les modifications") do
			strNom = @entNom.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			strMdp = @entMdp.text
			@lblErreur.color = 'red'
			user = Profil.find_by(pseudonyme: @@name)
			if strNom != @entNom.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
				puts "Insription : Caractère(s) non autorisé(s)"
			elsif strNom.length > 32
				@lblErr.text = "Identifiant trop long (> 32) !"
				puts "Connexion : L'identifiant trop long !"
			elsif(strNom.empty? && strMdp.empty?)
				puts "Vous devez remplir au moins un champ !"
				@lblErreur.text = "Vous devez remplir au moins un champ !"
			else
				unless strMdp.empty?
					# Enregistrement du mot de passe crypté
					user.mdpEncrypted = Digest::SHA1.hexdigest(strMdp)
					user.save
				end
				unless strNom.empty?
					# Enregistrement du pseudo
					# Si l'identifiant est déjà présent dans la base de données
					if Profil.find_by(pseudonyme: strNom) != nil
						self.setDesc("Cet identifiant existe déjà.")
					else
						user.pseudonyme = strNom
						user.save
						puts "renommage des fichiers"
						File.rename("../config/#{@@name}.ini", "../config/#{strNom}.ini")
						File.rename("../saves/#{@@name}.txt", "../saves/#{strNom}.txt")		if File.exist?("../saves/#{@@name}.txt")
						@@name = strNom
					end
				end
				puts "Modifications enregistrées !"
				@lblErreur.color = 'green'
				@lblErreur.text = "Modifications enregistrées !"
			end
		end
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
end
