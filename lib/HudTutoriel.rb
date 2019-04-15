# Menu de jeu du tutoriel
class HudTutoriel < HudJeu

	# Génère le menu de jeu
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize (window,grille)
		super(window,grille)
		self.setTitre("Tutoriel")
		@tutoriel = true


		afficherAideTutoriel
		@btnAide.sensitive = false
	@btnPause.sensitive = false
		@lblTime.set_visible(false)
	end

end
