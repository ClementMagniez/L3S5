require_relative 'Statut'

# Définit une case de la grille de jeu ; chaque case est interactible d'un clic
# selon son statut réel (tente/arbre/gazon)
# Cette classe est à considérer abstraite.
class Case

	def initialize(i,j)
		@x=i
		@y=j
	end

	def to_s
		"#{self.statutVisible}"
	end

	# Renvoie true si la case est correcte, false si elle est erronée
	def estValide?
		self.statut==self.statutVisible
	end

	def cycle(grille)
		grille.stack.push(self)
	end

	# Effectue un cycle opposé à CaseVide#cycle
	# TODO - utilise deux cycles : vérifier cohérence avec calcul du score
	def cancel(grille)
		self.statutVisible.cancel
	end



	def reset
		self.statutVisible.reset
		self
	end


	attr_reader :statut, :statutVisible, :x, :y

end
