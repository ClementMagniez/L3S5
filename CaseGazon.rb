require_relative 'CaseVide.rb'

class CaseGazon < CaseVide
	def initialize
		super(GAZON)
	end
	
	def to_s 
		"-"
	end
end
