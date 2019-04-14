require_relative "HudJeu"

class HudRapide < HudJeu

	TEMPS_FACILE=60*15
	TEMPS_MOYEN=TEMPS_FACILE*2/3
	TEMPS_DIFFICILE=TEMPS_MOYEN/2

	def initialize(window,grille)
		case grille.length
			when 6..8 then @temps=TEMPS_FACILE
			when 9..12 then @temps=TEMPS_MOYEN
			when 13..16 then @temps=TEMPS_DIFFICILE
		end

		super(window,grille)
		self.setTitre("Partie rapide")

		@@malus = 15
	end

	# Surcharge la méthode d'initialisation du bouton aide,
	# cela à pour but de diminuer le temps restant (systeme de malus) à chaque demande d'aide
	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") {
			@stockHorloge = @stockHorloge - @@malus
		}
	end

	# Surcharge la méthode d'init do bouton pause,
	# la grille de jeu ainsi qu'une partie des boutons ne sont plus visibles (ceci à pour but d'éviter la triche)
	def initBoutonPause
		super
		@btnPause.signal_connect("clicked") {
			@gridJeu.set_visible(!@pause)
			@btnAide.set_visible(!@pause)
			@btnReset.set_visible(!@pause)
			@btnCancel.set_visible(!@pause)
			@btnRemplissage.set_visible(!@pause)
			@btnSauvegarde.set_visible(!@pause)
			@lblAide.set_visible(!@pause)
		}
	end

	# Surcharge la méthode d'initialisation du timer,
	# l'affichage de celui-ci se fait en compte à rebours
	def initTimer
		super
		if @temps < 10
			@lblTime.set_text("0" + @temps.to_s + ":00")
		else
			@lblTime.set_text(@temps.to_s + ":00")
		end
	end

	# Redéfinie la méthode timer,
	# le timer est cette fois-ci un compte à rebours
	def timer
		while true do
			@horloge = @temps - ((Time.now - @timer) - @stockHorloge)
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			@lblTime.text = strMinutes + ":" + strSecondes
			if @horloge<=0
				jeuTermine
				return 0
			end
			sleep 1
		end
	end
end
