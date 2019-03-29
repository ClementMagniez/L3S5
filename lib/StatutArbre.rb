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
	
	# Compare self et _statut_
	# Return true si _statut_ est un arbre, appelle Statut#== sinon 
	def ==(statut)

		if statut.statut==ARBRE
			return true;
		end
		return super(statut);
	end
	
	def cancel
		if self.isArbreCoche?
			self.statut=ARBREDECOCHE
		else
			self.statut=ARBRECOCHE
		end
		self
	end
	
	def reset
		self.statut=ARBREDECOCHE
		self
	end

	def to_s
		case self.statut
			when ARBRECOCHE then '✓'
			when ARBREDECOCHE then 'X'
			when ARBRE then 'A'
		end
	end
	
end
