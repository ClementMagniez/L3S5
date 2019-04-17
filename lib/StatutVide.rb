require_relative 'Statut'

# Implémentation de Statut pour les cases 'tente' et 'gazon' qui apparaissent
# initialement vides au joueur
class StatutVide < Statut
	# Constante de classe, permet de déplacer le statut sur le cycle
	# VIDE -> GAZON -> TENTE à chaque interaction
	CYCLE=[:VIDE, :GAZON, :TENTE].freeze


	# Return true si le statut est "vide", false sinon
	def isVide?
		self.statut==:VIDE
	end

	# Return true si le statut est "gazon", false sinon
	def isGazon?
		self.statut==:GAZON
	end

	# Return true si le statut est "tente", false sinon
	def isTente?
		self.statut==:TENTE
	end

	# Cf. Statut#cycle ; utilise la constante StatutVide#CYCLE
	# return self

	def cycle
		super(CYCLE)
	end

	# Cf. Statut#cancel ; utilise la constante StatutVide#CYCLE
	# return self
	def cancel
		super(CYCLE)
	end

	# Réinitialise le statut à VIDE
	# return self
	def reset
		self.statut=:VIDE
		self
	end


	# Affiche le statut - utilisé à des fins de logging
	def to_s
		case self.statut
			when :VIDE then '-'
			when :GAZON then '#'
			when :TENTE then 'T'
		end
	end



end
