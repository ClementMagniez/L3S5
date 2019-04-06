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
 		self.setTitre("Choix de la difficulté - mode #{:mode.to_s}")
 		
 		# Définit la fonction de lancement utilisée selon le symbole fourni
		@mode="lancement"+mode.to_s.capitalize
		
		
		self.initBoutonsDifficulte
		self.initBoutonRetour
		self.initBoutonProfil

		# TODO - foutus nombres magiques
		debutMilieu = (@sizeGridWin/2)-1

		self.attach(@btnFacile,debutMilieu, debutMilieu-1, 1, 1)
		self.attach(@btnMoyen,debutMilieu, debutMilieu, 1, 1)
		self.attach(@btnDifficile,debutMilieu, debutMilieu+1, 1, 1)

		self.attach(@btnOptions, 1, @sizeGridWin, 1, 1)
		self.attach(@btnRetour, @sizeGridWin-1, @sizeGridWin-1, 1, 1)
		self.attach(@btnProfil, @sizeGridWin -1 , 1, 1, 1)


		ajoutFondEcran
	end
	
	# Crée et instancie les boutons de choix de la difficulté
	# Return self
	def initBoutonsDifficulte
		@btnFacile = Gtk::Button.new 
		styleBouton(@btnFacile,Gtk::Label.new("Facile"),"white","ultrabold","x-large")
		@btnMoyen = Gtk::Button.new
		styleBouton(@btnMoyen,Gtk::Label.new("Moyen"),"white","ultrabold","x-large")
		@btnDifficile = Gtk::Button.new
		styleBouton(@btnDifficile,Gtk::Label.new("Difficile"),"white","ultrabold","x-large")

		@btnFacile.signal_connect('clicked') do
			self.send(@mode, Grille.new(TAILLE_FACILE))
		end

		@btnMoyen.signal_connect('clicked') do
			self.send(@mode, Grille.new(TAILLE_MOYEN))
		end

		@btnDifficile.signal_connect('clicked') do
			self.send(@mode, Grille.new(TAILLE_DIFFICILE))
		end
		self
	end
	
	protected 
		attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
