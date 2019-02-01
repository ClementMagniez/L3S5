require_relative 'Case'
require_relative 'StatutArbre'

class CaseArbre < Case

	def initialize
		@statut=StatutArbre.new(ARBRE)
		@statutVisible=StatutArbre.new(ARBREDECOCHE)
	end
		
	# Fait cycler la case sur "coché->décoché" et met à jour les indicateurs
	# de tente restante
	# TODO - vérifier que les i,j sont bien cohérents
	def cycle(i,j,arrayColonnes, arrayLignes)
		self.statutVisible.cycle
	end

	protected
		attr_reader :statutVisible

end
