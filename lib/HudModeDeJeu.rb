class HudModeDeJeu < Gtk::Grid
	def initialize (window)
		super()
		@fenetre=window

		#Label titre : MODE DE JEU
		@lblTitreMdj = Gtk::Label.new(" MODE DE JEU ")
		self.attach(@lblTitreMdj,1,0,4,2)

		#Bouton tutoriel : MODE TUTORIEL
		@btnTutoriel = Gtk::Button.new :label => " Tutoriel"
		self.attach(@btnTutoriel,2,2,2,2)

		#Label : MODE AVENTURE
		@lblAventure = Gtk::Label.new("Mode Aventure")
		self.attach(@lblAventure,2,4,2,2) 

		#Bouton difficulte : FACILE MOYEN DIFFICILE
		@btnFacile = Gtk::Button.new :label => " - Facile - "
		@btnMoyen = Gtk::Button.new :label => " - Moyen - "
		@btnDifficile = Gtk::Button.new :label => " - Difficile - "
		self.attach(@btnFacile,3,6,2,2)
		self.attach(@btnMoyen,3,8,2,2)
		self.attach(@btnDifficile,3,10,2,2)

		#Label : MODE RAPIDE
		@lblRapide = Gtk::Label.new("Mode Rapide")
		self.attach(@lblRapide,2,12,2,2)

		#Bouton difficulte : FACILE MOYEN DIFFICILE
		@btnFacile1 = Gtk::Button.new :label => " - Facile - "
		@btnMoyen1 = Gtk::Button.new :label => " - Moyen - "
		@btnDifficile1 = Gtk::Button.new :label => " - Difficile - "
		self.attach(@btnFacile1,3,14,2,2)
		self.attach(@btnMoyen1,3,16,2,2)
		self.attach(@btnDifficile1,3,18,2,2)
		
	end




end