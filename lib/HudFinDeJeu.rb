class HudFinDeJeu < Hud

	# Nouvelle instance de fin de jeu
	# 	window : La Fenetre contenant le HudFinDeJeu
	# 	fenetrePrecedente : Le HudJeu qui appel ce constructeur, permet de recommencer une meme partie
	def initialize()
		super()
		finTuto = @@joueur.mode == :tutoriel
		lblTemps = CustomLabel.new("Votre temps : " + @@hudPrecedent.parseTimer)
		lblScore = CustomLabel.new("Votre score : #{@@joueur.score.to_i.to_s}")

		unless finTuto
			@id = @@joueur.enregistrerScore
			initChampScore
		end
		initBoutonRecommencer
		initBoutonChangerModeDeJeu
		@champScores.set_min_content_height(200)

		# @scorePartie = 0 # À placer après le champ des scores pour avoir la surbrillance de la ligne du score obtenu

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			lblTxt = CustomLabel.new("Partie terminée !")
			lblTxt.vexpand = true
		vBox.add(lblTxt)
			lblTemps.vexpand = true
		vBox.add(lblTemps)
			lblScore.vexpand = true
		vBox.add(lblScore)
		vBox.add(@champScores)
			vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			vBox2.vexpand = true
			vBox2.hexpand = false
			vBox2.valign = Gtk::Align::CENTER
			vBox2.halign = Gtk::Align::CENTER
			vBox2.add(@btnRecommencer)
			vBox2.add(@btnModeDeJeu)
		vBox.add(vBox2)

		self.attach(vBox, 0, 0, 1, 1)


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
		listeScores = @@joueur.rechercherScores(@@joueur.mode.to_s,@@joueur.difficulte)
		boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		listeScores.each do |score|
			lblScore = CustomLabel.new("#{score.profil.pseudonyme}\t#{score.montantScore}\t#{score.dateObtention}")
			# Le nouveau score du joueur est mis en évidence
			lblScore.color = (score.id == @id) ? "blue" : 'white'
			boxChamp.add(lblScore)
		end
		@champScores.add(boxChamp)
	end
end
