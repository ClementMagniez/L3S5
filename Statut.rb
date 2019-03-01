require_relative 'StatutConstantes'

# Définit un statut pour les Cases du jeu
# Un statut est ce que contient la case parmi les diverses possibilités du jeu :
# arbre (coché/décoché), rien, gazon, tente.
# Cette classe est à considérer abstraite.

class Statut
	include StatutConstantes

	# Constructeur appelé par Case#initialize
	def initialize(statut)
		@statut=statut
		@statutInitial=statut
	end
	
	# Return true si this et _statut_ sont égaux
	def ==(statut)
		self.statut==statut.statut
	end
	
	def reset
		self.statut=self.statutInitial
	end

	protected
	attr_reader :statutInitial
	attr_accessor :statut, :statutVisible
end
