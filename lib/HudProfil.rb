# Cette classe fait à peu près les mêmes choses que HudInscription
require 'inifile'

class HudProfil < Hud
	def initialize(window)
		super(window)
		self.setTitre("Profil")
		@lblErreur = CustomLabel.new
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		@entMdp.set_visibility(false)

		initBoutonRetourMenu
		initBoutonSauvegarderLogin

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
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			initBoutonsChampScore(vBox)
			hBox.add(@btnAventure)
			hBox.add(@btnExploration)
			hBox.add(@btnChrono)
		vBox.add(hBox)
		vBox.add(@btnSauvegarde)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

private
	def initBoutonsChampScore(container)
		@btnAventure = CustomButton.new("Aventure")
		@btnAventure.signal_connect("clicked") {
			initChampScore(true,["aventure",nil])
			container.add(@champScores)
		}

		@btnExploration = CustomButton.new("Exploration")
		@btnExploration.signal_connect("clicked") {
			initChampScore(true,["explo",nil])
			container.add(@champScores)
		}

		@btnChrono = CustomButton.new("Contre-la-montre")
		@btnChrono.signal_connect("clicked") {
			initChampScore(true,["rapide",nil])
			container.add(@champScores)
		}
	end

	def initBoutonRetourMenu
		@btnRetour = CustomButton.new("Retour")
		@btnRetour.signal_connect("clicked") do
			lancementModeJeu
		end
	end

	def initBoutonSauvegarderLogin
		@btnSauvegarde = CustomButton.new("Sauvegarder les modifications")
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
end
