require_relative 'CaseVide'

class CaseTente < CaseVide
	def initialize
		super(TENTE)
	end
	
	def to_s 
		"T"
	end
end
