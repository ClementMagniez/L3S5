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
		self.resizeWindow(960, 540)
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

		self.attach(@btnSauvegarde,varX,varY-2,2,1)

		self.attach(@btnTutoriel,varX, varY+1, 2, 1)

		self.attach(@btnAventure,varX, varY+3, 2, 3)

		self.attach(@btnChrono,varX, varY+6, 2, 3)

		self.attach(@btnExplo,varX, varY+9, 2, 3)
		
		self.attach(@btnOptions, 1, varY+14, 1, 1)
		self.attach(@btnQuitter, varX+4, varY+14, 1, 1)
		self.attach(@btnProfil, varX+4, varY-4, 1, 1)

		self.attach(@fond,0,0,varX+6,varY+15)
	end

	# Crée et connecte le bouton de chargement d'une sauvegarde
	# Return self
	# TODO : gérer l'exception ERRNOENT si pas de fichier (afficher un popup)
	def initBoutonChargerSauvegarde
		@btnSauvegarde = Gtk::Button.new :label => "Charger une sauvegarde"
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
		@btnAventure = Gtk::Button.new(:label => "Mode Aventure")
		@btnAventure.signal_connect('clicked') do
			lancementChoixDifficulte(:aventure)
		end
		self
	end
	# Crée et connecte le bouton de lancement du mode chrono
	def initBoutonRapide
		@btnChrono = Gtk::Button.new(:label => "Mode Chrono")
		@btnChrono.signal_connect('clicked') do
			lancementChoixDifficulte(:rapide)
		end
		self
	end
	
	# Crée et connecte le bouton de lancement du mode explo
	# Return self
	def initBoutonExplo
		@btnExplo = Gtk::Button.new(:label => "Mode Exploration")
		@btnExplo.signal_connect('clicked') do
			lancementChoixDifficulte(:explo)
		end
		self
	end

	# Crée et connecte le bouton de lancement du tutoriel
	# Return self
	def initBoutonTuto
		@btnTutoriel = Gtk::Button.new :label => " Tutoriel"
		@btnTutoriel.signal_connect('clicked') do
			puts "Lancement du mode tutoriel"
			#Niveau le plus facile : 6
			lancementTutoriel(Grille.new(TAILLE_FACILE))
		end
		self
	end
	
	protected 
		attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
