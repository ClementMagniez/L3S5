require_relative 'Statut'

# Implémentation de Statut pour les cases 'tente' et 'gazon' qui apparaissent
# initialement vides au joueur
class StatutVide < Statut
	
	# Return true si le statut est "vide", false sinon
	def isVide?
		self.statut==VIDE
	end
	
	# Return true si le statut est "gazon", false sinon
	def isGazon?
		self.statut==GAZON
	end
	
	# Return true si le statut est "tente", false sinon
	def isTente?
		self.statut==TENTE
	end
	
			
	# Cycle d'un cran, sur le cycle "case vide -> gazon -> tente"
	# return self
	def cycle
		if statut.isTente?
			self.statut=VIDE
		elsif statut.isVide?
			self.statut=GAZON
		else
			self.statut=TENTE
		end
		self
	end

	
end
