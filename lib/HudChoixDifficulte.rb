# Instance du menu de sélection de la difficulté : permet la sélection
# d'une des trois difficultés, l'accès au profil, aux options,
# et un retour au menu de sélection du mode de jeu (TODO)

class HudChoixDifficulte < Hud

	# Constantes décrivant le contexte des modes de difficulté : taille de grille
	# et, pour le mode chrono, temps imparti

	TAILLE_FACILE=6
	TAILLE_MOYEN=TAILLE_FACILE+3
	TAILLE_DIFFICILE=TAILLE_MOYEN+4


	# Instancie le menu de choix de la difficulté
	#
	# Paramètres :
	# - window : la Fenetre de l'application
	# - mode : un symbole ∈ { :rapide, :explo, :aventure } - détermine quel mode de jeu est lancé
	def initialize(window, mode)
		super(window)
		varX, varY = 4,4
 		self.setTitre("Choix de la difficulté - mode #{mode.to_s}")

 		# Définit la fonction de lancement utilisée selon le symbole fourni
		@mode="lancement"+mode.to_s.capitalize


		self.initBoutonsDifficulte
		self.initBoutonQuitter
		self.initBoutonProfil

		# TODO - foutus nombres magiques
		
		self.attach(@btnFacile,varX+1, varY+2, 1, 1)
		self.attach(@btnMoyen,varX+1, varY+3, 1, 1)
		self.attach(@btnDifficile,varX+1, varY+4, 1, 1)

		self.attach(@btnOptions, 1, varY+14, 1, 1)
		self.attach(@btnQuitter, varX+4, varY+14, 1, 1)
		self.attach(@btnProfil, varX+2, varY, 1, 1)

		self.attach(self.ajoutFondEcran,0,0,varX+6,varY+15)
	end

	# Crée et instancie les boutons de choix de la difficulté
	# Return self
	def initBoutonsDifficulte
		@btnFacile = Gtk::Button.new :label => "Facile"
		@btnMoyen = Gtk::Button.new :label => "Moyen"
		@btnDifficile = Gtk::Button.new :label => "Difficile"

		@btnFacile.signal_connect('clicked') do
			@@difficulte = "Facile"
			self.send(@mode, Grille.new(TAILLE_FACILE))
		end

		@btnMoyen.signal_connect('clicked') do
			@@difficulte = "Moyen"
			self.send(@mode, Grille.new(TAILLE_MOYEN))
		end

		@btnDifficile.signal_connect('clicked') do
			@@difficulte = "Difficile"
			self.send(@mode, Grille.new(TAILLE_DIFFICILE))
		end
		self
	end

	protected
		attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end