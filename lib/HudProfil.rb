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
		initChampScore(true,["rapide",nil])

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
	def initBoutonsChampScore
		@btnAventure = CustomButton.new("Aventure")
		@btnAventure.signal_connect("clicked") {
			# Recharge la liste avec les scores du mode éponyme
		}

		@btnExploration = CustomButton.new("Exploration")
		@btnExploration.signal_connect("clicked") {
			# Recharge la liste avec les scores du mode éponyme
		}

		@btnChrono = CustomButton.new("Chrono")
		@btnChrono.signal_connect("clicked") {
			# Recharge la liste avec les scores du mode éponyme
		}

		# À inclure dans la boucle de listeScores
		@btnSuppScore = CustomButton.new("X")
		@btnSuppScore.signal_connect("clicked") {
			# @@joueur.supprimerScore()
			# Recharge la liste avec les scores du mode éponyme
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
