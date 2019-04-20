require_relative 'Case'
require_relative 'StatutArbre'

class CaseArbre < Case

	def initialize(i,j)
		super(i,j)
		@statut=StatutArbre.new(:ARBRE)
		@statutVisible=StatutArbre.new(:ARBREDECOCHE)
	end

	# Renvoie true, la case étant systématiquement valide
	def estValide?
		true
	end
	def isVide?
		return false
	end



	# Fait cycler la case sur "coché->décoché" et met à jour les indicateurs
	# de tente restante
	# TODO - vérifier que les i,j sont bien cohérents
	def cycle(grille)
		self.statutVisible.cycle
		super(grille)
	end

	def affichage
		if self.statutVisible.isArbreCoche?
			'../img/arbreCoche.png'
		else
			'../img/arbre.png'
		end
	end
end
