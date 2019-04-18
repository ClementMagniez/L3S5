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
		self.file['resolution']={'width' => width, 
													'height' => height
												 }
		self.file.write
		self
	end
	
	# Entre dans [position] les nouvelles coordonnées de la fenêtre
	# - x,y : les coordonnées en abscisses/ordonnées
	# - return self
	def writePosition(x, y)
		self.file['position']={'x' => x, 
													'y' => y
												 }
		self.file.write
		self
	end
	
	# Entre dans [misc] le nouveau statut d'enregistrement du score du joueur 
	# (voir HudOptions)
	# - choix : "Oui" ou "Non"
	# - return self
	def writeEnregistrementScore(choix)
		self.file['misc']={'score'=>choix}
		self.file.write
	end
	
	def [](val)
		self.file[val]
	end
	
#	def []=(key,val)
#		self.file[key]=val	
#	end
	attr_accessor :file
	private
end
