class HudFinDeJeu < Hud

	# Return une nouvelle instance de fin de jeu, aka un écran récapitulatif
	# de la partie
	def initialize
		super(Gtk::Orientation::VERTICAL)
		finTuto = @@joueur.mode == :tutoriel
		lblTemps = CustomLabel.new("Votre temps : " + @@hudPrecedent.parseTimer(:tempsRestant))
		lblScore = CustomLabel.new("Votre score : #{@@joueur.score.to_i.to_s}")
	
		bVictoire=@@joueur.score > 0 || @@joueur.mode!= :rapide
		if !finTuto && @@config.score==true && bVictoire # TODO est-ce que ça fonctionne seulement
			@id = @@joueur.enregistrerScore
		end
		initChampScore
		@champScores.min_content_height = 200
		@champScores.min_content_width = 200
		

		if bVictoire
			lblTxt = CustomLabel.new("Partie terminée !", "lblInfo")
		else
			lblTxt = CustomLabel.new("Défaite", "lblErr")
		end
		lblTxt.vexpand = true
		self.add(lblTxt)
		lblTemps.vexpand = true
		self.add(lblTemps)
		lblScore.vexpand = true
		self.add(lblScore)
		self.add(@champScores) if @champScores
			vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			vBox2.vexpand = true
			vBox2.hexpand = false
			vBox2.valign = Gtk::Align::CENTER
			vBox2.halign = Gtk::Align::CENTER
			vBox2.add(initBoutonRecommencer)
			vBox2.add(initBoutonChangerModeDeJeu)
		self.add(vBox2)
		self.hexpand = true
		self.vexpand = true
		self.valign = Gtk::Align::CENTER
		self.halign = Gtk::Align::CENTER

		if finTuto
			# On ne doit pas voir les scores à la fin du tuto
			lblScore.destroy
			@champScores.destroy
		end
	end

private
	# Génère un bouton de retour au menu de choix du mode de jeu
	# - return un CustomButton appelant Hud#lancementModeJeu au clic
	def initBoutonChangerModeDeJeu
		CustomButton.new("Retour au menu") { self.lancementModeJeu }

	end
	# Génère un bouton permettant de relancer la grille précédente
	# - return un CustomButton appelant Hud#lancementHudPrecedent au clic
	def initBoutonRecommencer
		CustomButton.new("Recommencer") do
			@@hudPrecedent.reset
			self.lancementHudPrecedent
		end
	end

	# Génère une liste des scores où le dernier en date du joueur (s'il les enregistre) est
	# mis en évidence
	# - return self
	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		@champScores.name="boxScores"
		listeScores = @@joueur.rechercherScores(@@joueur.mode.to_s,@@joueur.difficulte)
		boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		listeScores.each do |score|
			lblScore = CustomLabel.new("#{score.profil.pseudonyme}\t#{score.montantScore}\t#{score.dateObtention}")
			lblScore.name = (score.id == @id) ? "lblScorePerso" : 'lblWhite'	if @id
			boxChamp.add(lblScore)
		end
		@champScores.add(boxChamp)
		self
	end
end
