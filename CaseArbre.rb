require_relative 'Case'

class CaseArbre < Case

	def initialize
		super(ARBRE)
		@statutVisible=Statut.new(ARBRECOCHE)
	end
		
	# Fait cycler la case sur "coché->décoché" et met à jour les indicateurs
	# de tente restante
	# TODO - vérifier que les i,j sont bien cohérents
	def cycle(i,j,arrayColonnes, arrayLignes)
		self.statutVisible.cycle
	end
	
	def to_s 
		"A"
	end
	
end
