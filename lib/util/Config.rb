# Permet de manipuler un fichier .ini tel qu'utilisé dans l'application
class Config

	# - name : nom du fichier .ini placé dans ./config, qui sera créé s'il n'existe pas
	# - return une nouvelle instance de Config basée sur ce fichier
	def initialize(filename)
		if File.exist?("../config/#{filename}.ini")
			@file=IniFile.load("../config/#{filename}.ini", encoding: 'UTF-8')
		else
			@file=IniFile.new(filename: "../config/#{filename}.ini", encoding: 'UTF-8')
		end
	
		validateFile
	end
	
	# Renvoie le nom du fichier ini
	def filename
		self.file.filename
	end
	
	# Modifie le nom du fichier ini
	# - val : nouveau String à lui attribuer
	# - return self
	def filename=(val)
		self.file.filename=val
		self
	end

	# Enregistre les modifications de l'instance de Config dans un fichier physique
	# selon Config#filename
	# - return self
	def save
		self.file.write
		self
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
	
	# Génère un ensemble d'accesseurs en lecture à chaque clé du .ini _file_, de 
	# sorte que (ie.) _self.score_ renvoie self.file[{section}]['score']
	# - considère que chaque clé est unique : si tel n'est pas le cas, 
	# la dernière dans l'ordre de lecture de chaque groupe identique sera considérée
	# - file : un IniFile initialisé
	# - return self
	def self.genAccessors(file) 
		file.each do |section, param|
			define_method :"#{param}" do
				self.file[section][param]
			end
		end
		self
	end
	# Génère un .ini par défaut pour le profil _name_ et enregistre le fichier 
	# - name : nom d'un profil à enregistrer
	# - return un IniFile configuré par défaut 
	def self.initFile(name)
		content="[resolution]\n"+
						"width = 1280\n"+
						"height = 720\n" +
						"fullscreen = false\n"+
						"[shortcuts]\n"+
						"[misc]\n"+
						"score = true\n"+
						"[position]\n"+
						"x = 300\n"+
						"y = 300\n"
		filename="../config/#{name}.ini"
		IniFile.new(content: content, encoding: 'UTF-8', filename: filename).write
		
	end
	attr_accessor :file
	private
		
	# Vérifie la validité de chaque entrée du fichier 
	def validateFile
		validateEntry('resolution', 'width', 896)
		validateEntry('resolution', 'height', 504)
		validateEntry('resolution', 'fullscreen', false)
		validateEntry('misc', 'score', true)
		validateEntry('position', 'x', 300)
		validateEntry('position', 'y', 300)
		Config.genAccessors(self.file)
	end
	
	# Génère une entrée _param_=_val_ dans _section_ si elle n'existe pas
	# - section : bloc de données dans le .ini, exemple : [misc]
	# - param : clé dans une section, exemple : score
	# - val : valeur d'une clé 
	# - return self
	def validateEntry(section,param, val)
		if !self.file[section][param]
			self.file[section][param]=val
		end
		self
	end
end
