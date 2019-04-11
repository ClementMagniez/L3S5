class HudPresentationTutoriel < Hud
	def initialize (window,grille)
		super(window)
			
		initBoutonRegle
		initBoutonContinuer(grille)

		self.attach(styleLabel(Gtk::Label.new,"black","ultrabold","x-large","Bienvenue dans le mode tutoriel, \ncliquez sur sur \"Continuer\" si vous voulez tester une grille \nou cliquez sur \"Règles\" pour lire les règles avant de jouer !"),0,(@sizeGridWin/4),@sizeGridWin,1)
		self.attach(@btnContinuer,(@sizeGridWin/4)*3,(@sizeGridWin/4)*3,1,1)
		self.attach(@btnRegle,@sizeGridWin/4,(@sizeGridWin/4)*3,1,1)

		ajoutFondEcran
	end

	#Fonction d'initialisation du bouton "Règles" vers la page des régles.
	#- Retourne : Self
	def initBoutonRegle
		@btnRegle = creerBouton(Gtk::Label.new("Règles"),"white","ultrabold","x-large")
		@btnRegle.signal_connect('clicked'){
			lancementHudRegle
		}
	end

#Fonction d'initialisation du bouton "Continuer" vers le tutoriel.
	#- Retourne : Self
	def initBoutonContinuer(grille)
		@btnContinuer = creerBouton(Gtk::Label.new("Continuer"),"white","ultrabold","x-large")
		@btnContinuer.signal_connect('clicked'){
			 lancementTutoriel(grille)
		}
	end
end