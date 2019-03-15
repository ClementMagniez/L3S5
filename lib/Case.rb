require_relative 'Statut'
require_relative 'StatutConstantes'

# Définit une case de la grille de jeu ; chaque case est interactible d'un clic
# selon son statut réel (tente/arbre/gazon)
# Cette classe est à considérer abstraite.
class Case
	include StatutConstantes


	def to_s
		"#{self.statutVisible}"
	end

	# Renvoie true si la case est correcte, false si elle est erronée
	def estValide?
		self.statut==self.statutVisible
	end

	def reset
		self.statutVisible.reset
		self
	end

	attr_reader :statut, :statutVisible, :points

end
