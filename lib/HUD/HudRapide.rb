require_relative "HudJeu"

class HudRapide < HudJeu

	TEMPS_FACILE=60*15
	TEMPS_MOYEN=TEMPS_FACILE*2/3
	TEMPS_DIFFICILE=TEMPS_MOYEN/2

	# @see HudJeu#initialize
	# - timer : par défaut -1, auquel cas @temps est généré selon la taille de la grille ;
	# si différent de -1, @temps prend pour valeur timer (sert au chargement des sauvegardes)
	def initialize(grille,timer=-1)
		case grille.length
			when 6..8 then @temps=TEMPS_FACILE
			when 9..12 then @temps=TEMPS_MOYEN
			when 13..16 then @temps=TEMPS_DIFFICILE
		end
		if timer != -1
			@temps = timer
		end
		
		super(grille,@temps)
		@grille.score.estModeChrono
		# malus de temps (en seconde) lors d'une demande d'aide
		@malus = 15
	end

	# @see HudJeu#initBoutonAide : de plus, réduit le timer de façon linéaire
	# (15*1.2x secondes, x le nombre de demandes d'aide) à chaque clic
	# - return self
	def initBoutonAide
		super
		@btnAide.signal_connect("clicked") do
			@timer -= @malus
			@malus *= 1.2
		end
		self
	end

	# Redéfinit l'accesseur HudJeu#tempsRestant pour indiquer le temps restant et non
	# le temps écoulé
	# - return le temps de départ moins le temps écoulé, en secondes
	def tempsRestant
		return @temps-@timer
	end


	# @see HudJeu#initBoutonPause ; de plus, masque la grille durant la pause
	# - return self
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
		self
	end

	# Surcharge la méthode d'initialisation du timer,
	# l'affichage de celui-ci se fait en compte à rebours
	# - return self
	def initTimer(timer=@temps)
		super(timer)
	end

	# Surcharge HudJeu#increaseTimer : décrémente le timer et lance HudJeu#jeuTermine
	# quand il atteint 0
	# - return false si le timer est à 0, !@pause sinon
	def increaseTimer
		buff=super(:-)
		if self.timer<=0
			self.jeuTermine
			return false
		end
		buff
	end

	# Réinitialise le timer à son temps initial @temps plutôt qu'à 0
	# - return self
	def resetTimer
		super(@temps)
	end
end
