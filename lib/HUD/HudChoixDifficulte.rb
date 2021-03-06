# Instance du menu de sélection de la difficulté : permet la sélection
# d'une des trois difficultés, l'accès au profil, aux options,
# et un retour au menu de sélection du mode de jeu (TODO)

class HudChoixDifficulte < Hud

	# Constantes décrivant le contexte des modes de difficulté : taille de grille
	# et, pour le mode chrono, temps imparti

	TAILLE_FACILE=6
	TAILLE_MOYEN=TAILLE_FACILE+3
	TAILLE_DIFFICILE=TAILLE_MOYEN+4


	# Instancie le menu de choix de la difficulté
	#
	# Paramètres :
	# - window : la Fenetre de l'application
	# - mode : un symbole ∈ { :rapide, :exploration, :aventure } - détermine quel mode de jeu est lancé
	def initialize(mode)
		super(Gtk::Orientation::VERTICAL)

 		self.setTitre("Choix de la difficulté - mode #{mode.to_s.capitalize}")
 		@@joueur.mode=mode
 		# Définit la fonction de lancement utilisée selon le symbole fourni
		@mode="lancement"+mode.to_s.capitalize

		initBoutonsDifficulte
		initBoutonRetour
		initBoutonProfil

			@btnProfil.halign = Gtk::Align::END
		self.add(@btnProfil)
			vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			vBox2.halign = Gtk::Align::CENTER
				@btnFacile.vexpand = true
				@btnFacile.valign = Gtk::Align::END
			vBox2.add(@btnFacile)
			vBox2.add(@btnMoyen)
			vBox2.add(@btnDifficile)
		self.add(vBox2)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
				@btnRetour.valign = Gtk::Align::END
				@btnRetour.halign = Gtk::Align::END
			hBox.add(@btnRetour)
		self.add(hBox)
	end

private

	# Crée et instancie les boutons de choix de la difficulté
	# Return self
	def initBoutonsDifficulte
		@btnFacile = CustomButton.new("Facile") do
			# TODO à améliorer
			@@joueur.difficulte = "Facile"
			self.send(@mode, Grille.new(TAILLE_FACILE))
		end

		@btnMoyen = CustomButton.new("Moyen") do
			@@joueur.difficulte = "Moyen"
			self.send(@mode, Grille.new(TAILLE_MOYEN))
		end

		@btnDifficile = CustomButton.new("Difficile") do
			@@joueur.difficulte = "Difficile"
			self.send(@mode, Grille.new(TAILLE_DIFFICILE))
		end
		self
	end

protected
	attr_reader :btnTutoriel, :btnExploFacile, :btnExploMoy
end
