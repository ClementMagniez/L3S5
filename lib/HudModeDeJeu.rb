class HudModeDeJeu < Hud
	# @btnTutoriel
	# @btnAvFacile
	# @btnAvMoyen
	# @btnAvDifficile
	# @btnRapideFacile
	# @btnRapideMoyen
	# @btnRapideDifficile

	def initialize (window)
		super(window)

		self.setDesc("Ici la description des modes de jeu")
		self.setTitre("MODE DE JEU")

		initBoutonsAventure
		initBoutonsRapide
		initBoutonTuto

		self.attach(@btnAvFacile,7,6,2,2)
		self.attach(@btnAvMoyen,7,8,2,2)
		self.attach(@btnAvDifficile,7,10,2,2)
		self.attach(@btnTutoriel,5,2,2,2)
		self.attach(@btnRapideFacile,7,14,2,2)
		self.attach(@btnRapideMoyen,7,16,2,2)
		self.attach(@btnRapideDifficile,7,18,2,2)
		self.attach(Gtk::Label.new("Mode Aventure"),5,4,2,2)
		self.attach(Gtk::Label.new("Partie rapide"),5,12,2,2)
	end


	def initBoutonsAventure
		@btnAvFacile = Gtk::Button.new :label => "Facile"
		@btnAvMoyen = Gtk::Button.new :label => "Moyen"
		@btnAvDifficile = Gtk::Button.new :label => "Difficile"

		@btnAvFacile.signal_connect('clicked') {
			puts "Lancement du mode facile d'Aventure"
			#Niveau entre 6 et 9
			taille = 6 + Random.rand(3)
			lancementAventure(taille)
		}
		@btnAvMoyen.signal_connect('clicked') {
			puts "Lancement du mode moyen d'Aventure"
			#Niveau entre 9 et 12
			taille = 9 + Random.rand(3)
			lancementAventure(taille)
		}
		@btnAvDifficile.signal_connect('clicked') {
			puts "Lancement du mode difficile d'Aventure"
			#Niveau entre 12 et 16
			taille = 12 + Random.rand(4)
			lancementAventure(taille)
		}
	end

	def initBoutonsRapide
		@btnRapideFacile = Gtk::Button.new :label => "Facile"
		@btnRapideMoyen = Gtk::Button.new :label => "Moyen"
		@btnRapideDifficile = Gtk::Button.new :label => "Difficile"

		@btnRapideFacile.signal_connect('clicked') {
			puts "Lancement du mode facile de rapide"
			#Niveau entre 6 et 9
			taille = 6 + Random.rand(3)
			lancementRapide(taille)
		}
		@btnRapideMoyen.signal_connect('clicked') {
			puts "Lancement du mode moyen de rapide"
			#Niveau entre 9 et 12
			taille = 9 + Random.rand(3)
			lancementRapide(taille)
		}
		@btnRapideDifficile.signal_connect('clicked') {
			puts "Lancement du mode difficile de rapide"
			#Niveau entre 12 et 16
			taille = 12 + Random.rand(4)
			lancementRapide(taille)
		}
	end

	def initBoutonTuto
		@btnTutoriel = Gtk::Button.new :label => " Tutoriel"
		@btnTutoriel.signal_connect('clicked') {
			puts "Lancement du mode tutoriel"
			#Niveau le plus facile : 6
			taille = 6
			lancementTutoriel(taille)
		}
	end
end
