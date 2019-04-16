require_relative 'CustomLabel'

class Timer

	# Initialise le timer et le label associé au timer.
	# - start : par défaut 0, le temps de départ du timer
	def initialize(start=0)
		@timer = start
		@lblTime = CustomLabel.new(self.parseTimer, "white")
		self.startTimer
	end
	
	# Lance le décompte du temps
	# - return self
	def startTimer
		GLib::Timeout.add(1000) do
			self.increaseTimer
		end
		self
	end
	# Incrémente le timer et met @lblTime à jour
	# - modeCalcul : symbole { :+, +- } déterminant si le timer est croissant
	# ou décroissant - par défaut croissant
	# - return !@pause
	def increaseTimer(modeCalcul = :'+' )
		return false if @pause # interrompt le décompte en cas de pause
		@timer=@timer.send(modeCalcul, 1)
		@lblTime.text=self.parseTimer
		return true
	end

	# Rend lisible le temps écoulé @timer et renvoie le String calculé
	# - return un String contenant un temps mm:ss
	def parseTimer
		[@timer/60, @timer%60].map { |t| t.to_s.rjust(2,'0') }.join(':')
	end

	# Réinitialise le timer à 0
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def resetTimer(start=0)
		@timer=start
		@lblTime.text=self.parseTimer
		self
	end

	# Inverse le statut 
	def reversePause
		@pause=!@pause
	end

end
