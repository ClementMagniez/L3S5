# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize (window,grille)
#		window.set_hexpand(false)
#		window.set_vexpand(false)

		super(window,grille)
		self.setTitre("Tutoriel")
		@tutoriel = true

		afficherAideTutoriel

		@lblTime.set_visible(false)
	end

end
