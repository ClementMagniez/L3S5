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
		# varX, varY = 4,4
 		self.setTitre("Choix du mode de jeu")

		self.initBoutonChargerSauvegarde
		self.initBoutonTuto
		self.initBoutonAventure
		self.initBoutonRapide
		self.initBoutonExplo
		self.initBoutonProfil
		self.initBoutonQuitter

		# TODO - foutus nombres magiques
		debutMilieu = (@sizeGridWin/2)-2



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			@btnProfil.halign = Gtk::Align::END
		vBox.add(@btnProfil)
			vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			vBox2.halign = Gtk::Align::CENTER
				@btnSauvegarde.valign = Gtk::Align::CENTER
				@btnSauvegarde.vexpand = true
			vBox2.add(@btnSauvegarde)
				@btnTutoriel.valign = Gtk::Align::CENTER
				@btnTutoriel.vexpand = true
			vBox2.add(@btnTutoriel)
			vBox2.add(@btnAventure)
			vBox2.add(@btnChrono)
			vBox2.add(@btnExplo)
		vBox.add(vBox2)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
				@btnQuitter.valign = Gtk::Align::END
				@btnQuitter.halign = Gtk::Align::END
			hBox.add(@btnQuitter)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)

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
