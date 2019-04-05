require_relative 'Statut'


# Implémentation de Statut pour les cases de type 'arbre'
class StatutArbre < Statut
	
	# Constante de classe, permet de cocher/décocher les arbres
	CYCLE=[ARBRECOCHE, ARBREDECOCHE]
	
	# Return "true" si le statut est "coché", false sinon
	def isArbreCoche?
		self.statut==ARBRECOCHE
	end
	
	# Cf. Statut#cycle ; utilise la constante StatutArbre#CYCLE
	def cycle
		super(CYCLE)
	end
	
	# Cf. Statut#cancel ; utilise la constante StatutArbre#CYCLE
	def cancel
		super(CYCLE)
	end

	
	# Compare self et _statut_
	# Return true si _statut_ est un arbre, appelle Statut#== sinon 
	def ==(statut)
			return true if statut.statut==ARBRE
		return super(statut)
	end

	# Réinitialise le statut à ARBREDECOCHE
	# return self
	def reset
		self.statut=ARBREDECOCHE
		self
	end

	# Affiche le statut selon son état
	def to_s
		case self.statut
			when ARBRECOCHE then '✓'
			when ARBREDECOCHE then 'X'
			when ARBRE then 'A'
		end
	end

	
	private


	
	
end
