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
		# malus de temps (en seconde) lors d'une demande d'aide
		@@malus = 15
	end

	# Surcharge la méthode d'initialisation du bouton aide,
	# cela à pour but de diminuer le temps restant (systeme de malus) à chaque demande d'aide
	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") do
			@timer -= @@malus
			self.jeuTermine		if @timer <= 0
			@@malus *= 1.2
		end
	end

	# Redéfinit l'accesseur HudJeu#timer pour afficher le temps restant et non
	# le temps écoulé
	def timer
		puts @timer
		return @temps-@timer
	end


	# Surcharge la méthode d'init do bouton pause,
	# la grille de jeu ainsi qu'une partie des boutons ne sont plus visibles (ceci à pour but d'éviter la triche)
	def initBoutonPause
		super
		@btnPause.signal_connect("clicked") do
			@gridJeu.set_visible(!@pause)
			@btnAide.set_visible(!@pause)
			@btnReset.set_visible(!@pause)
			@btnCancel.set_visible(!@pause)
			@btnRemplissage.set_visible(!@pause)
			@btnSauvegarde.set_visible(!@pause)
			@lblAide.set_visible(!@pause)
		end
	end

	# Surcharge la méthode d'initialisation du timer,
	# l'affichage de celui-ci se fait en compte à rebours
	def initTimer
		super(@temps)
	end

	def increaseTimer
		buff=super(:-)
		if self.timer>=@temps
			self.jeuTermine
			return false
		end
		buff
	end

	def resetTimer
		super(@temps)
	end
end
