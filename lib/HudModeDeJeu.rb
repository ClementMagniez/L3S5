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
 		self.setTitre("Choix du mode de jeu")

		self.initBoutonAventure
		self.initBoutonRapide
		self.initBoutonTuto
		self.initBoutonQuitter
		self.initBoutonChargerSauvegarde
		self.initBoutonProfil
		self.initBoutonExplo

		# TODO - foutus nombres magiques
		debutMilieu = @sizeGridWin/2-2


		self.attach(@btnSauvegarde,debutMilieu,1, 1, 1)

		self.attach(@btnTutoriel,debutMilieu, 4, 2, 1)

		self.attach(@btnAventure,debutMilieu, 6,2, 1)

		self.attach(@btnChrono,debutMilieu, 9, 2, 1)

		self.attach(@btnExplo,debutMilieu, 12, 2, 1)
		
		self.attach(@btnOptions, 2, @sizeGridWin-1, 1, 1)
		self.attach(@btnQuitter, @sizeGridWin-2, @sizeGridWin-1, 1, 1)
		self.attach(@btnProfil, @sizeGridWin -2 , 1, 1, 1)

		ajoutFondEcran

	end

	# Crée et connecte le bouton de chargement d'une sauvegarde
	# Return self
	# TODO : gérer l'exception ERRNOENT si pas de fichier (afficher un popup)
	def initBoutonChargerSauvegarde
		@btnSauvegarde = Gtk::Button.new 
		styleBouton(@btnSauvegarde,Gtk::Label.new("Charger une sauvegarde"),"white","ultrabold","x-large")

		@btnSauvegarde.signal_connect('clicked') do
			File.open("saves/"+@@name+".txt", 'r') do |f|
				dataLoaded=Marshal.load(f)
				grille=dataLoaded[0]
				@@mode=dataLoaded[1]
				@difficulte=dataLoaded[2] # TODO ?????
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
		@btnAventure = Gtk::Button.new
		styleBouton(@btnAventure,Gtk::Label.new("Mode Aventure"),"white","ultrabold","x-large")
		@btnAventure.signal_connect('clicked') do
			lancementChoixDifficulte(:aventure)
		end
		self
	end
	# Crée et connecte le bouton de lancement du mode chrono
	def initBoutonRapide
		@btnChrono = Gtk::Button.new
		styleBouton(@btnChrono,Gtk::Label.new("Mode Chrono"),"white","ultrabold","x-large")
		@btnChrono.signal_connect('clicked') do
			lancementChoixDifficulte(:rapide)
		end
		self
	end
	
	# Crée et connecte le bouton de lancement du mode explo
	# Return self
	def initBoutonExplo
		@btnExplo = Gtk::Button.new
		styleBouton(@btnExplo,Gtk::Label.new("Mode Exploration"),"white","ultrabold","x-large")
		@btnExplo.signal_connect('clicked') do
			lancementChoixDifficulte(:explo)
		end
		self
	end

	# Crée et connecte le bouton de lancement du tutoriel
	# Return self
	def initBoutonTuto
		@btnTutoriel = Gtk::Button.new 
		styleBouton(@btnTutoriel,Gtk::Label.new("Tutoriel"),"white","ultrabold","x-large")
		@btnTutoriel.signal_connect('clicked') do
			puts "Lancement du mode tutoriel"
			#Niveau le plus facile : 6
			 lancementTutoriel(Grille.new(HudChoixDifficulte::TAILLE_FACILE))
		end
		self
	end
	
	protected 
		attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
