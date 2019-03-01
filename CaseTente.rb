require_relative 'CaseVide'

class CaseTente < CaseVide
	def initialize
		super(TENTE)
	end
	def estTente
		return true
	end

end
