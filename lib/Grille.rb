require_relative 'Case'
require_relative 'CaseArbre'
require_relative 'CaseTente'
require_relative 'CaseGazon'
require_relative 'Pile'

# Parse le fichier de génération des grilles et l'implémente
# comme grille de jeu
class Grille

	attr_reader :varTentesCol, :tentesCol, :varTentesLigne, :tentesLigne, :grille,
						  :estValide, :stack


	# Obtient et génère la grille à partir du fichier filePath, ligne n
	# L'indexation se fait à partir de 1
	# n - ligne du fichier où se trouve la source de la grille
	# filePath - path du fichier de génération, typiquement "../grilles.txt"
	def initialize(n,filePath)
		raise("Indexer à 1") if 0==n

		result=nil # TODO - hideux, à remplacer
		matSize=n/100+6

		File.open(filePath,"r") do |file|
			n.times { result=file.gets }

		end
		@grille=Array.new(matSize) { Array.new(matSize) {0} }
		@tentesCol=Array.new(matSize)
		@tentesLigne=Array.new(matSize)
		parseText(result)
		@varTentesCol=@tentesCol.dup
		@varTentesLigne=@tentesLigne.dup
		@stack=Pile.new()
		@estValide=false
	end
		
	
	# Renvoie la taille n de la matrice n*n composant la grille de jeu
	def length
		return @grille.length
	end

	# Annule le dernier coup de l'utilisateur sur la grille 
	def cancel
		cell=self.stack.pop
		cell.cancel(cell.x, cell.y, self)
		self
	end

	# Renvoie true si la grille est complète et valide, false sinon
	def estComplete?
		res=true
		self.grille.each do |ligne|
			ligne.each do |cell|
				res=res && cell.estValide?
				break if !res
			end
		end
		self.estValide=res
	end

	def length
		return @grille.length
	end

	# Affiche la grille complète - pourra être supprimé quand on aura la GUI
	def to_s
		str=""
		self.grille.each_with_index do |ligne,i|
			str+=ligne.join(" | ")
			str+=" | "
			str+=self.tentesLigne[i].to_s + "\n"
		end
		self.tentesCol.each { |j| str+="#{j} | "}
		str
	end

	def [](val)
		self.grille.fetch(val)
	end

	private
	attr_writer :grille, :tentesCol, :tentesLigne, :estValide



	# Prend une ligne de texte sortie du fichier listant les grilles et la parse
	# de sorte à compléter la grille : matrice de jeu, arrays récapitulant les
	# lignes/colonnes
	def parseText(data)
		# format : lignes,colonnes;ligne1:nbtentesdsligne1:ligne2...;nbtentesdanscolonnes
		# On prend à partir de 6 afin de se débarrasser de la taille de la matrice,
		# qu'on connaît déjà
		data[6..-1].split(";").each_with_index do |elt,i|
			parseLigne(elt,i)
		end
	end

	# Prend un subset de la ligne passée à parseText, de la forme lignedejeu:nbtentes
	# ou "liste de chiffres" dans le cas du dernier élément
	def parseLigne(ligne,indexLigne)

		# forme : ["ligne de la grille", "nb tentes ds ligne"]
		# exception si dernière ligne du parsing, auquel cas forme : [/[0-9]*/]
		arrSplit=ligne.split(":")

		if arrSplit.length<2 # cas de la liste des nbTentes des colonnes
			arrSplit[0].chomp("\n").split(//).each_with_index do |nb,i|
				parseColNum(nb,i)
			end
		else  # cas général
			arrSplit[0].split(//).each_with_index do |cell,i|
				parseChar(cell,indexLigne,i)
			end
			parseLigneNum(arrSplit[1],indexLigne)
		end
	end

	# Prend un unique caractère de la ligne passée à parseLigne et génère une case
	# dans la matrice selon ce caractère
	def parseChar(chr, i,j)
		self.grille[i][j]=createCase(chr,i,j)
	end

	# Complète la liste des nombres de tentes par ligne
	# Exemple : si _nb_==5 et _index_==3, considère que la grille a 5 tentes en
	# ligne 3
	def parseLigneNum(nb,index)
		self.tentesLigne[index]=nb.to_i;
	end

	# Complète la liste des nombres de colonnes par ligne
	# Exemple : si _nb_==5 et _index_==3, considère que la grille a 5 tentes en
	# colonne 3
	def parseColNum(nb,index)
		self.tentesCol[index]=nb.to_i;
	end

	# Initialise une Case de la grille selon la valeur du caractère fourni
	# Associations : "A" > Arbre, "T" -> Tente, "_" -> Gazon
	# return la Case créée
	def createCase(chr,i,j)
		case chr
			when 'A' then return CaseArbre.new(i,j)
			when 'T' then return CaseTente.new(i,j)
			when '_' then return CaseGazon.new(i,j)
			else abort("Erreur de parsing : #{chr}")
		end
	end

end
