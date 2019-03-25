require_relative 'CaseVide'

class CaseGazon < CaseVide
	def initialize(i,j)
		super(GAZON,i,j)
	end
	
	def estValide?
		!self.statutVisible.isTente?
	end
end