require_relative 'Case'
require_relative 'StatutArbre'

class CaseArbre < Case

	def initialize
		@statut=StatutArbre.new(ARBRE)
		@statutVisible=StatutArbre.new(ARBREDECOCHE)
	end
	
	# Renvoie true, la case étant systématiquement valide
	def estValide?
		true
	end
	
	# Fait cycler la case sur "coché->décoché" et met à jour les indicateurs
	# de tente restante
	# TODO - vérifier que les i,j sont bien cohérents
	def cycle(i,j,arrayColonnes, arrayLignes)
		self.statutVisible.cycle
	end

	def affichage
		if self.statutVisible.isArbreCoche?
			'img/arbreCoche.png'
		else
			'img/arbre.png'
		end
	end
	
end