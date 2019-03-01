require_relative 'Statut'


# On veut pouvoir ecrire Case.statut==VIDE ou Case.statut==Case.statut
#
#
#



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
	
	def ==(statut)

		#print " nig rgr \n"
		if statut.statutVisible==ARBRECOCHE || statut.statutVisible==ARBREDECOCHE
			#print " aofjaefjegz \n"
			return true;
		end
		return super(statut);
	end
	

	def to_s
		case self.statut
			when ARBRECOCHE then '✓'
			when ARBREDECOCHE then 'X'
			when ARBRE then 'A'
		end
	end
	
end