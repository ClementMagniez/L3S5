class HudModeDeJeu < Hud
	# @@tailleFacile
	# @@tailleMoyen
	# @@tailleDifficile

	# @btnTutoriel
	# @btnAvFacile
	# @btnAvMoyen
	# @btnAvDifficile
	# @btnRapideFacile
	# @btnRapideMoyen
	# @btnRapideDifficile

	def initialize (window)
		super(window)
		@@tailleFacile = 6
		@@tailleMoyen = 9
		@@tailleDifficile = 12

		self.setDesc("Ici la description des modes de jeu")
		self.setTitre("MODE DE JEU")

		initBoutonsAventure
		initBoutonsRapide
		initBoutonTuto

		varX = 5;
		varY = 5

		self.attach(@btnTutoriel,0, 0, 2, 1)

		self.attach(Gtk::Label.new("Mode Aventure"),0, 1, 2, 1)
			self.attach(@btnAvFacile,1, 2, 1, 1)
			self.attach(@btnAvMoyen,1, 3, 1, 1)
			self.attach(@btnAvDifficile,1, 4, 1, 1)

		self.attach(Gtk::Label.new("Partie rapide"),0, 5, 2, 1)
			self.attach(@btnRapideFacile,1, 6, 1, 1)
			self.attach(@btnRapideMoyen,1, 7, 1, 1)
			self.attach(@btnRapideDifficile,1, 8, 1, 1)

		self.attach(@btnOptions, 0, 9, 1, 1)

		fond = scaleFond
		self.attach(fond,0,0,5,10)
	end


	def initBoutonsAventure
		@btnAvFacile = Gtk::Button.new :label => "Facile"
		@btnAvMoyen = Gtk::Button.new :label => "Moyen"
		@btnAvDifficile = Gtk::Button.new :label => "Difficile"

		@btnAvFacile.signal_connect('clicked') {
			puts "Lancement du mode facile d'Aventure"
			#Niveau entre 6 et 9
			# taille = 6 + Random.rand(3)
			lancementAventure(@@tailleFacile)
		}
		@btnAvMoyen.signal_connect('clicked') {
			puts "Lancement du mode moyen d'Aventure"
			#Niveau entre 9 et 12
			# taille = 9 + Random.rand(3)
			lancementAventure(@@tailleMoyen)
		}
		@btnAvDifficile.signal_connect('clicked') {
			puts "Lancement du mode difficile d'Aventure"
			#Niveau entre 12 et 16
			# taille = 12 + Random.rand(4)
			lancementAventure(@@tailleDifficile)
		}
	end

	def initBoutonsRapide
		@btnRapideFacile = Gtk::Button.new :label => "Facile"
		@btnRapideMoyen = Gtk::Button.new :label => "Moyen"
		@btnRapideDifficile = Gtk::Button.new :label => "Difficile"

		@btnRapideFacile.signal_connect('clicked') {
			puts "Lancement du mode facile de rapide"
			#Niveau entre 6 et 9
			# taille = 6 + Random.rand(3)
			lancementRapide(@@tailleFacile)
		}
		@btnRapideMoyen.signal_connect('clicked') {
			puts "Lancement du mode moyen de rapide"
			#Niveau entre 9 et 12
			# taille = 9 + Random.rand(3)
			lancementRapide(@@tailleMoyen)
		}
		@btnRapideDifficile.signal_connect('clicked') {
			puts "Lancement du mode difficile de rapide"
			#Niveau entre 12 et 16
			# taille = 12 + Random.rand(4)
			lancementRapide(@@tailleDifficile)
		}
	end

	def initBoutonTuto
		@btnTutoriel = Gtk::Button.new :label => " Tutoriel"
		@btnTutoriel.signal_connect('clicked') {
			puts "Lancement du mode tutoriel"
			#Niveau le plus facile : 6
			# taille = 6
			lancementTutoriel(@@tailleFacile)
		}
	end
end
