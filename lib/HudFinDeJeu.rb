class HudFinDeJeu < Hud

	# Nouvelle instance de fin de jeu
	
	def initialize()
		super(Gtk::Orientation::VERTICAL)
		finTuto = @@joueur.mode == :tutoriel
		lblTemps = CustomLabel.new("Votre temps : " + @@hudPrecedent.parseTimer)
		lblScore = CustomLabel.new("Votre score : #{@@joueur.score.to_i.to_s}")
	
			bVictoire=@@joueur.score > 0
			
		if !finTuto && @@config['misc']['score']==true && bVictoire
			@id = @@joueur.enregistrerScore
		end
		initChampScore
		@champScores.min_content_height = 200
		@champScores.min_content_width = 200
		initBoutonRecommencer
		initBoutonChangerModeDeJeu
		

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
			vBox2.add(@btnRecommencer)
			vBox2.add(@btnModeDeJeu)
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

	def initBoutonChangerModeDeJeu
		@btnModeDeJeu = CustomButton.new("Retour au menu") {
			self.lancementModeJeu
		}

	end

	def initBoutonRecommencer
		@btnRecommencer = CustomButton.new("Recommencer") {
			@@hudPrecedent.reset
			self.lancementHudPrecedent
		}
	end

	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		@champScores.name="boxScores"
		Stylizable::setStyle(@champScores)
		listeScores = @@joueur.rechercherScores(@@joueur.mode.to_s,@@joueur.difficulte)
		boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		listeScores.each do |score|
			lblScore = CustomLabel.new("#{score.profil.pseudonyme}\t#{score.montantScore}\t#{score.dateObtention}")
			lblScore.name = (score.id == @id) ? "lblInfo" : 'lblWhite'	if @id
			boxChamp.add(lblScore)
		end
		@champScores.add(boxChamp)
	end
end
