# Définit un statut pour les Cases du jeu
# Un statut est ce que contient la case parmi les diverses possibilités du jeu :
# arbre (coché/décoché), rien, gazon, tente.
# Cette classe est à considérer abstraite.

class Statut

	# Constructeur appelé par Case#initialize
	def initialize(statut)
		@statut=statut
	end

	# Return true si this.statut et _statut.statut_ sont égaux
	def ==(statut)
		self.statut==statut.statut
	end

	def isVide?
		return false
	end

	# Cycle d'un cran sur array
	# return self
	def cycle(array)
		decalageCycle(1, array)
	end

	# Annule la dernière opération, donc recule dans array
	# return self
	def cancel(array)
		decalageCycle(-1, array)
	end



	protected

	# Utilitaire pour #cancel et #cycle : se déplace de offset à partir de
	# .statut dans array
	# return self
	def decalageCycle(offset, array)
		self.statut=array[(array.index(self.statut)+offset)%array.length]
		self
	end
	attr_accessor :statut, :statutVisible
end
