# Instance du menu de sélection des modes de jeu : permet la sélection 
# entre l'un des quatre modes, le chargement d'une sauvegarde, l'accès au profil, 
# aux options, et un retour au menu de connexion

# TODO : bouton d'accès au menu de connexion
# virer le choix de la difficulté : le remettre dans un autre menu auquel on accède
# en choisissant l'un des trois modes de jeu
class HudModeDeJeu < Hud


	# Instancie le menu de sélection
	#
	# Paramètre : window - la Fenetre de l'application
	def initialize(window)
		super(window)
		varX, varY = 4,4
 		self.setTitre("Choix du mode de jeu")

		self.initBoutonAventure
		self.initBoutonRapide
		self.initBoutonTuto
		self.initBoutonQuitter
		self.initBoutonChargerSauvegarde
		self.initBoutonProfil
		self.initBoutonExplo

		# TODO - foutus nombres magiques
		debutMilieu = (@sizeGridWin/2)-2

		self.attach(@btnSauvegarde,debutMilieu,1, 4, 1)

		self.attach(@btnTutoriel,debutMilieu, 4, 4, 1)

		self.attach(@btnAventure,debutMilieu, 6, 4, 3)

		self.attach(@btnChrono,debutMilieu, 9, 4, 3)

		self.attach(@btnExplo,debutMilieu, 12, 4, 3)
		
		self.attach(@btnOptions, 1, @sizeGridWin, 1, 1)
		self.attach(@btnQuitter, @sizeGridWin-1, @sizeGridWin-1, 1, 1)
		self.attach(@btnProfil, @sizeGridWin -1 , 1, 1, 1)

		ajoutFondEcran

	end

	# Crée et connecte le bouton de chargement d'une sauvegarde
	# Return self
	# TODO : gérer l'exception ERRNOENT si pas de fichier (afficher un popup)
	def initBoutonChargerSauvegarde
		@btnSauvegarde = creerBouton(Gtk::Label.new("Charger une sauvegarde"),"white","ultrabold","x-large")

		@btnSauvegarde.signal_connect('clicked') do
			File.open("saves/"+@@name+".txt", 'r') do |f|
				dataLoaded=Marshal.load(f)
				grille=dataLoaded[0]
				@@mode=dataLoaded[1]
				@difficulte=dataLoaded[2]
				case @@mode
					when :explo then lancementExplo(grille)
					when :rapide then lancementRapide(grille)
					when :tutoriel then lancementTutoriel(grille)
					when :aventure then lancementAventure(grille)
				end
			end
		end
		self
	end

	# Crée et connecte le bouton de lancement du mode aventure
	# Return self
	def initBoutonAventure
		@btnAventure = creerBouton(Gtk::Label.new("Mode Aventure"),"white","ultrabold","x-large")
		@btnAventure.signal_connect('clicked') do
			lancementChoixDifficulte(:aventure)
		end
		self
	end
	# Crée et connecte le bouton de lancement du mode chrono
	def initBoutonRapide
		@btnChrono = creerBouton(Gtk::Label.new("Mode Chrono"),"white","ultrabold","x-large")
		@btnChrono.signal_connect('clicked') do
			lancementChoixDifficulte(:rapide)
		end
		self
	end
	
	# Crée et connecte le bouton de lancement du mode explo
	# Return self
	def initBoutonExplo
		@btnExplo = creerBouton(Gtk::Label.new("Mode Exploration"),"white","ultrabold","x-large")
		@btnExplo.signal_connect('clicked') do
			lancementChoixDifficulte(:explo)
		end
		self
	end

	# Crée et connecte le bouton de lancement du tutoriel
	# Return self
	def initBoutonTuto
		@btnTutoriel = creerBouton(Gtk::Label.new("Tutoriel"),"white","ultrabold","x-large")
		@btnTutoriel.signal_connect('clicked') do
			puts "Lancement du mode tutoriel"
			#Niveau le plus facile : 6
			 lancementHudPresentationTutoriel(Grille.new(HudChoixDifficulte::TAILLE_FACILE))
		end
		self
	end
	
	protected 
		attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
