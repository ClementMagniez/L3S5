class HudModeDeJeu < Hud
	def initialize (window)
		super(window)

		#Label titre : MODE DE JEU
		@lblTitreMdj = Gtk::Label.new(" MODE DE JEU ")
		self.attach(@lblTitreMdj,1,0,4,2)

		#Bouton tutoriel : MODE TUTORIEL
		@btnTutoriel = Gtk::Button.new :label => " Tutoriel"
		self.attach(@btnTutoriel,5,2,2,2)

		#Label : MODE AVENTURE
		@lblAventure = Gtk::Label.new("Mode Aventure")
		self.attach(@lblAventure,5,4,2,2) 

		#Bouton difficulte : FACILE MOYEN DIFFICILE
		@btnFacileAv = Gtk::Button.new :label => " - Facile - "
		@btnMoyenAv = Gtk::Button.new :label => " - Moyen - "
		@btnDifficileAv = Gtk::Button.new :label => " - Difficile - "
		self.attach(@btnFacileAv,7,6,2,2)
		self.attach(@btnMoyenAv,7,8,2,2)
		self.attach(@btnDifficileAv,7,10,2,2)

		#Label : MODE RAPIDE
		@lblRapide = Gtk::Label.new("Mode Rapide")
		self.attach(@lblRapide,5,12,2,2)

		#Bouton difficulte : FACILE MOYEN DIFFICILE
		@btnFacileRap = Gtk::Button.new :label => " - Facile - "
		@btnMoyenRap = Gtk::Button.new :label => " - Moyen - "
		@btnDifficileRap = Gtk::Button.new :label => " - Difficile - "
		self.attach(@btnFacileRap,7,14,2,2)
		self.attach(@btnMoyenRap,7,16,2,2)
		self.attach(@btnDifficileRap,7,18,2,2)

		#Bouton Option
		@btnOption = Gtk::Button.new :label => "Options"
		self.attach(@btnOption,2,20,2,2)
		self.initBoutonOptions
		self.initBoutonAventure

	end

	def initBoutonAventure
		@btnFacileAv.signal_connect('clicked') {		
			puts "Lancement du mode facile d'Aventure"
			#Niveau entre 6 et 9
			taille = 6 + Random.rand(3)
			lancementAventure(taille)
		
		}
		@btnMoyenAv.signal_connect('clicked') {
			puts "Lancement du mode facile d'Aventure"
			#Niveau entre 9 et 12
			taille = 9 + Random.rand(3)
			lancementAventure(taille)		
		}
		@btnDifficileAv.signal_connect('clicked') {
			puts "Lancement du mode facile d'Aventure"
			#Niveau entre 9 et 12
			taille = 12 + Random.rand(4)
			lancementAventure(taille)		
		}
	end


end