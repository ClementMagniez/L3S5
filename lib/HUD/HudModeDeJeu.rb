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
	def initialize
		super(Gtk::Orientation::VERTICAL)
 		self.setTitre
		@lblErr = CustomLabel.new("", "lblErr")

		initBoutonAventure
		initBoutonChargerSauvegarde
		initBoutonExplo
		initBoutonProfil
		initBoutonQuitter
		initBoutonRapide
		initBoutonRegle
		initBoutonTuto

			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.halign = Gtk::Align::END
			hBox.add(@btnRegle)
			hBox.add(@btnProfil)
		self.add(hBox)
		self.add(@lblErr)
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
		self.add(vBox2)
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
		self.add(hBox)
	end

	# Surcharge le setter du titre de la fentre afin qu'il affiche toujours le meme message
	# 	- str Le parametre est rendu inutil
	def setTitre(str=nil)
		super("#{@@joueur.login} - Choix du mode de jeu")
	end

private



	# Crée et connecte le bouton de lancement du mode aventure
	# Return self
	def initBoutonAventure
		@btnAventure = CustomButton.new("Mode Aventure") do
			lancementChoixDifficulte(:aventure)
		end
		self
	end

	# Crée et connecte le bouton de chargement d'une sauvegarde
	# Return self
	def initBoutonChargerSauvegarde
		@btnSauvegarde = CustomButton.new("Charger la dernière sauvegarde") do
			if !File.exist?("../saves/"+@@joueur.login+".txt")
				@lblErr.text = "Aucune sauvegarde trouvée"
			else
				begin
					File.open("../saves/"+@@joueur.login+".txt", 'r') do |f|
						dataLoaded=Marshal.load(f)
						grille=dataLoaded[0]
						@@joueur.mode=dataLoaded[1]
						@@joueur.difficulte=dataLoaded[2]
						timer=dataLoaded[3]

						
						self.send("lancement"+@@joueur.mode.to_s.capitalize, grille,timer)
					end
				rescue
					@lblErr.text="La sauvegarde est corrompue"
				end
			end
		end
		self
	end

	# Crée et connecte le bouton de lancement du mode explo
	# Return self
	def initBoutonExplo
		@btnExplo = CustomButton.new("Mode Exploration") do
			lancementChoixDifficulte(:exploration)
		end
		self
	end

	def initBoutonOptions
		super([:setTitre])
	end

	# Crée et connecte le bouton de lancement du mode chrono
	def initBoutonRapide
		@btnChrono = CustomButton.new("Mode Chrono") do
			lancementChoixDifficulte(:rapide)
		end
		self
	end

	def initBoutonRegle
		super([:setTitre])
	end

	# Crée et connecte le bouton de lancement du tutoriel
	# Return self
	def initBoutonTuto
		@btnTutoriel = CustomButton.new("Tutoriel") do
			#Niveau le plus facile : 6
			 lancementHudPresentationTutoriel(Grille.new(HudChoixDifficulte::TAILLE_FACILE))
		end
		self
	end

	# Ecrase Hud#initBoutonQuitter pour rediriger vers l'écran de connexion
	def initBoutonQuitter
		super do
			@@fenetre.updateData
			@@fenetre.updateConfig(@@config)
			@@fenetre.resize(480,270)
			@@config=nil
			self.lancementAccueil 
		end
	end
protected
	attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
