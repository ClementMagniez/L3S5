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



		self.attach(@lblDescription, 0, 0, 2, 1)
		self.attach(Gtk::Label.new("Nouveau nom"), 0, 1, 1, 1)
		self.attach(@entNom, 1, 1, 1, 1)
		self.attach(Gtk::Label.new("Nouveau mot de passe"), 0, 2, 1, 1)
		self.attach(@entMdp, 1, 2, 1, 1)

		self.attach(@champScores, 0, 4, 2, 4)

		self.attach(@btnSauvegarde, 0, 10, 2, 1)
		self.attach(@btnRetour, 0, 11, 2, 1)

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

	def initBoutonSauvegarder
		@btnSauvegarde = Gtk::Button.new label: "Sauvegarder"
		@btnSauvegarde.signal_connect("clicked") {
			strNom = @entNom.text
			strMdp = @entMdp.text
			if(strNom.empty?)
				puts "Le nom ne peut etre vide !"
				self.setDesc("Le nom ne peut etre vide !")
			elsif(strMdp.empty?)
				puts "Le mot de passe ne peut etre vide !"
				self.setDesc("Le mot de passe ne peut etre vide !")
			else
				puts "Sauvegarde dans la base !"
				self.setDesc("Sauvegarde dans la base !")
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
