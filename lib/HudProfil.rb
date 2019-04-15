# Cette classe fait a peut pres les memes choses que HudInscription
require 'inifile'

class HudProfil < Hud
	def initialize(window)
		super(window)
		self.setTitre("Profil")
		@lblErreur = Gtk::Label.new
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		@entMdp.set_visibility(false)

		initChampScore
		initBoutonSauvegarderLogin
		initBoutonRetourMenu

#		self.attach(Gtk::Label.new("Compte"), 4, 0, 2, 1)
#		self.attach(@lblDescription, 4, 1, 2, 1)
#		self.attach(Gtk::Label.new("Nouveau nom"), 4, 2, 1, 1)
#		self.attach(@entNom, 5, 2, 1, 1)
#		self.attach(Gtk::Label.new("Nouveau mot de passe"), 4, 3, 1, 1)
#		self.attach(@entMdp, 5, 3, 1, 1)
#		self.attach(@btnSauvegardeLogin, 4, 4, 2, 1)

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

	def initChampScore
		# Liste des scores récupérés dans la BDD
		session = Connexion.new()
		listeScores = session.rechercherScore(session.id)

		if(listeScores != nil)
			@champScores = Gtk::ScrolledWindow.new
			@champScores.set_min_content_height(100)
				boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
					0.upto(listeScores.size()) do |i|
						boxChamp.add(Gtk::Label.new(listeScores.at(i)))
					end
				@champScores.add(boxChamp)
		else
			@champScores = Gtk::Label.new("Aucun score trouvé")
		end
		@champScores.set_visible(true)
	end

	def initBoutonSauvegarderLogin
		@btnSauvegarde = Gtk::Button.new(label: "Sauvegarder les modifications")
		@btnSauvegarde.signal_connect("clicked") do
			strNom = @entNom.text
			strMdp = @entMdp.text
			if(strNom.empty?)
				puts "Le nom ne peut etre vide !"
				@lblErreur.text = "Le nom ne peut etre vide !"
			elsif(strMdp.empty?)
				puts "Le mot de passe ne peut etre vide !"
				@lblErreur.text = "Le mot de passe ne peut etre vide !"
			else
				puts "Sauvegarde dans la base !"
				@lblErreur.text = "Sauvegarde dans la base !"
			end
		end
	end

	def initBoutonRetourMenu
		@btnRetour = Gtk::Button.new label: "Retour"
		@btnRetour.signal_connect("clicked") do
			lancementModeJeu
		end
	end
	
end
