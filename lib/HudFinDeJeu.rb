class HudFinDeJeu < Hud

	# Nouvelle instance de fin de jeu
	# 	window : La Fenetre contenant le HudFinDeJeu
	# 	fenetrePrecedente : Le HudJeu qui appel ce constructeur, permet de recommencer une meme partie
	def initialize(window, fenetrePrecedente)
		super(window)
		varX, varY = 2, 2
		@fenetrePrecedente = fenetrePrecedente
		tpsMin = fenetrePrecedente.timer / 60
		tpsSec = fenetrePrecedente.timer % 60
		lblTemps = CustomLabel.new("Votre temps : " + tpsMin.to_i.to_s + ":" + (tpsSec > 10 ? "" : "0") + tpsSec.to_i.to_s)
		lblScore = CustomLabel.new("Score final = " + @@scoreTotal.to_s)
		# lblTableauScores = CustomLabel.new("Tableau à afficher")
		@@joueur.enregistrerScore(@@joueur.id,[@@mode,@@difficulte,@@scoreTotal])

		initChampScore
		initBoutonRecommencer
		initBoutonChangerModeDeJeu
		@champScores.set_min_content_height(200)

		@scorePartie = 0 # À placer après le champ des scores pour avoir la surbrillance de la ligne du score obtenu

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			lblTxt = CustomLabel.new("Bravo, vous avez fini !")
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

		ajoutFondEcran
	end

private

	def initBoutonChangerModeDeJeu
		@btnModeDeJeu = CustomButton.new("Retour au menu")
		@btnModeDeJeu.signal_connect('clicked'){
			self.lancementModeJeu
		}

	end

	def initBoutonRecommencer
		@btnRecommencer = CustomButton.new("Recommencer")
		@btnRecommencer.signal_connect('clicked') {
			@fenetrePrecedente.reset
			@fenetrePrecedente.grille.score.reset
			@fenetrePrecedente.reloadScore
			@fenetre.changerWidget(self,@fenetrePrecedente)
		}
	end

	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		listeScores = @@joueur.rechercherScores(@@mode.to_s,@@difficulte)
		boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		listeScores.each do |score|
			lblScore = CustomLabel.new("#{score.profil.pseudonyme}\t#{score.montantScore}\t#{score.dateObtention}")
			lblScore.color = (score.montantScore == @@scoreTotal && score.profil_id == @@joueur.id) ? "blue" : 'white'
			boxChamp.add(lblScore)
		end
		@champScores.add(boxChamp)
	end
end
