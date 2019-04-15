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
		lblScore = CustomLabel.new("Score = " + @@scoreTotal.to_s)
		session = Connexion.new
		session.enregistrerScore(session.id,[@@name,@@difficulte,@@mode,@@scoreTotal])


		initBoutonRecommencer
		initBoutonChangerModeDeJeu


		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			lblTxt = CustomLabel.new("Bravo, vous avez fini !")
			lblTxt.vexpand = true
		vBox.add(lblTxt)
			lblTemps.vexpand = true
		vBox.add(lblTemps)
			lblScore.vexpand = true
		vBox.add(lblScore)
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
			@fenetre.changerWidget(self,@fenetrePrecedente)
		}

	end
end
