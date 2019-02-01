require_relative 'Statut'

# Implémentation de Statut pour les cases de type 'arbre'
class StatutArbre < Statut
	
	# Return "true" si le statut est "coché", false sinon
	def isArbreCoche?
		self.statut==ARBRECOCHE
	end
	
	# Cycle d'un cran, sur le cycle "décoché -> coché"
	# return self 
	def cycle
		if self.isArbreCoche?
			self.statut=ARBREDECOCHE
		else
			self.statut=ARBRECOCHE
		end
		self
	end

	def to_s
		case self.statut
			when ARBRECOCHE then '✓'
			when ARBREDECOCHE then 'A'
		end
	end
	
end
