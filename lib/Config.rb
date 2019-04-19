# Permet de manipuler un fichier .ini tel qu'utilisé dans l'application
class Config

	# - name : nom du fichier .ini placé dans ./config, qui sera créé s'il n'existe pas
	# - return une nouvelle instance de Config basée sur ce fichier
	def initialize(name)
		if File.exist?("../config/#{name}.ini")
			@file=IniFile.load("../config/#{name}.ini", encoding: 'UTF-8')
		else
			@file=IniFile.new(filename: "../config/#{name}.ini", encoding: 'UTF-8')
		end
	end
	
	# Entre dans [resolution] les nouvelles dimensions de la fenêtre
	# - width,height : les coordonnées en largeur*hauteur
	# - return self
	def writeResolution(width, height)
		self.file['resolution'].merge!({'width' => width, 
													'height' => height
												 })
		self.file.write
		self
	end
	
	# Entre dans [position] les nouvelles coordonnées de la fenêtre
	# - x,y : les coordonnées en abscisses/ordonnées
	# - return self
	def writePosition(x, y)
		self.file['position'].merge!({'x' => x, 
													'y' => y
												 })
		self.file.write
		self
	end
	
	# Entre dans [misc] le nouveau statut d'enregistrement du score du joueur 
	# (voir HudOptions)
	# - choix : true/false
	# - return self
	def writeEnregistrementScore(choix)
		self.file['misc'].merge!({'score'=>choix})
		self.file.write
		self
	end

	# Entre dans [resolution] le statut fullscreen (true/false) de la fenêtre
	# - choix : true/false
	# - width,height : les coordonnées en largeur*hauteur
	# - return self
	def writeFullScreen(choix)
		self.file['resolution'].merge!({'fullscreen'=>choix})
		self.file.write
		self
	end	
	
	# Accesseur au contenu de file, permet d'écrire Config[val]
	def [](val)
		self.file[val]
	end
	
#	def []=(key,val)
#		self.file[key]=val	
#	end
	attr_accessor :file
	private
end
