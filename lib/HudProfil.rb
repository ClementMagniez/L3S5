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
		@@mode = :aventure

		initBoutonRetourMenu
		initBoutonSauvegarderLogin
		initBoutonsChampScore
		initChampScore
		@champScores.set_min_content_height(150)

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
			hBox.add(@btnAventure)
			hBox.add(@btnExploration)
			hBox.add(@btnChrono)
		vBox.add(hBox)
		vBox.add(@champScores)
		vBox.add(@btnSauvegarde)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

	def refreshChampScore
		@champScores.remove(@champScores.child)		if @champScores.child != nil
		listeScores = @@joueur.rechercherScores(@@mode.to_s)
		unless listeScores.empty?
			boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			listeScores.each do |score|
				boxChamp.add(CustomLabel.new("#{score.montantScore} | #{score.dateObtention}"))
			end
			@champScores.add(boxChamp)
		else
			@champScores.add(CustomLabel.new("Aucun score trouvé pour ce mode !"))
		end
		@champScores.show_all
	end

private
	def initBoutonsChampScore
		@btnAventure = CustomButton.new("Aventure")
		@btnAventure.signal_connect("clicked") do
			@@mode = :aventure
			self.refreshChampScore
		end

		@btnExploration = CustomButton.new("Exploration")
		@btnExploration.signal_connect("clicked") do
			@@mode = :explo
			self.refreshChampScore
		end

		@btnChrono = CustomButton.new("Contre-la-montre")
		@btnChrono.signal_connect("clicked") do
			@@mode = :rapide
			self.refreshChampScore
		end
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

	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		self.refreshChampScore
	end
end
