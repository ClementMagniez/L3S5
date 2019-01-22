class GrilleDeJeu
	def initialize(n,filePath)
		result=nil
		File.open(filePath,"r") do |file| 
			((n-6)*10+rand(100)).times do 
				result=file.gets
			end
		end
		@grille=Array.new(n) { Array.new(n) {0} }
		@tentesCol=Array.new(n)
		@tentesLigne=Array.new(n)
		parseText(result)			
					
	end
	attr_accessor :grille, :tentesCol, :tentesLigne
	
	private
	
	# Prend une ligne de texte sortie du fichier listant les grilles et la parse
	# de sorte à compléter la grille : matrice de jeu, arrays récapitulant les
	# lignes/colonnes
	def parseText(data)
		# format : lignes,colonnes;ligne1:nbtentesdsligne1:ligne2...;nbtentesdanscolonnes
		data[6..-1].split(";").each_with_index do |elt,i|
			parseLigne(elt,i)
		end
	end
	
	# Prend un subset de la ligne passée à parseText, de la forme lignedejeu:nbtentes 
	# ou "liste de chiffres" dans le cas du dernier élément
	def parseLigne(ligne,indexLigne)
		
		arrSplit=ligne.split(":") # forme : ["ligne de la grille", "nb tentes ds ligne"]
			# exception si dernière ligne du parsing, auquel cas forme : [/[0-9]*/]
	
		if arrSplit.length<2 # cas où est sur la liste des nbTentes des colonnes
			arrSplit[0].chomp("\n").split(//).each_with_index do |nb,i|
				parseColNum(nb,i)
			end
		else  #
			arrSplit[0].split(//).each_with_index do |cell,i|
					parseChar(cell,indexLigne,i)
			end
			parseLigneNum(arrSplit[1],indexLigne)
			
		end

	
	end	
	
	# Prend un unique caractère de la ligne passée à parseLigne et génère une case
	# dans la matrice selon ce caractère
	def parseChar(chr, i,j)
		self.grille[i][j]=(chr=="_" ? "-" : chr); # TODO - Case.new(chr), en gros
	end
	
	def parseLigneNum(nb,index)
		self.tentesLigne[index]=nb.to_i;
	end
	
	def parseColNum(nb,index)
		self.tentesCol[index]=nb.to_i;
	end	
	
	def to_s
		str=""
		grille.each { |ligne| str+=ligne.join(" | ") + "\n" }
		str
	end
end

# Démo

grille=GrilleDeJeu.new(6,"grilles.txt");
print "\n", grille
print grille.tentesCol, "\n"

print grille.tentesLigne, "\n"

