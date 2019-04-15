require_relative 'CaseVide'

# Classe implémentant CaseVide : représente une case engazonnée, valide
# tant qu'elle n'affiche pas une tente
class CaseGazon < CaseVide
	# Appelle CaseVide#initialize avec :GAZON
	# - i,j : coordonnées de la case
	def initialize(i,j)
		super(:GAZON,i,j)
	end
	
	# Return false si le statut visible de self est :TENTE, true sinon
	def estValide?
		!self.statutVisible.isTente?
	end
end
