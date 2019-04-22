require_relative 'Case'
require_relative 'StatutVide'

# Implémente Case pour les cases apparaissant vides au joueur à la création de
# la grille. Un clic sur ces cases en modifie l'apparence et met à jour les
# valeurs du nombre de tentes (c'est-à-dire que cliquer sur une CaseVide pour en
# faire une tente décrémente le nombre de tentes restantes sur la ligne/colonne)
# Relativement à Case, une CaseVide dispose d'un statut visible en plus de son
# statut interne, ce qui permet de laisser au joueur la possibilité de se tromper.
class CaseVide < Case

	def initialize(etat,i,j)
		super(i,j)
		@statut=StatutVide.new(etat)
		@statutVisible=StatutVide.new(:VIDE)
	end

	# Fait cycler la case sur "vide->gazon->tente" et met à jour les indicateurs
	# de tente restante
	# - grille : la Grille de jeu
	# - return self
	def cycle(grille)
		self.statutVisible.cycle
		valeurScore={:'isTente?'=>5, :'isVide?'=>-10, :'isGazon?'=>1}

		self.updateNbTents(grille, :'isGazon?', :'isVide?', valeurScore)
		super(grille)
		self
	end
	# @see Case#cancel
	def cancel(grille)

		self.statutVisible.cancel
		
		valeurScore={:'isVide?'=>-1, :'isTente?'=>10, :'isGazon?'=>-5}

		self.updateNbTents(grille, :'isVide?', :'isGazon?', valeurScore)
		self
	end

	# Met à jour self, les varTentesCol et varTentesLigne de la grille selon le statut
	# de self, et vérifie la validité de la grille
	# - grille : la Grille de jeu
	# - beforeTent : symbole de 'isGazon?' ou 'isVide?' opposé à _afterTent_ ; 
	# sert au calcul du score
	# - afterTent : symbole de 'isGazon?' ou 'isVide?' déterminant quel type de case
	# vient après :TENTE dans le cycle ; permet de différencier cancel et cycle
	# - pointsHash : Hash liant un symbole de afterTent au nombre de points
	# gagné lors du passage à ce statut 
	# - return true si la grille est complète après mise à jour, false sinon
	def updateNbTents(grille, beforeTent, afterTent, pointsHash)
		
		if self.statutVisible.isTente? # le statut vient de devenir "tente"
			grille.varTentesLigne[self.x]-=1
			grille.varTentesCol[self.y]-=1
			grille.score.recupererPoints(pointsHash[:'isTente?'])
		elsif self.statutVisible.send(afterTent) # le statut était "tente"
			grille.varTentesLigne[self.x]+=1
			grille.varTentesCol[self.y]+=1
			grille.score.recupererPoints(pointsHash[afterTent])
		else # statut précédant tente
			grille.score.recupererPoints(pointsHash[beforeTent])
		end

		if grille.varTentesLigne[self.x]==0 && grille.varTentesCol[self.y]==0
			return grille.estComplete?
		end
		false
	end

	def affichage
		if self.statutVisible.isGazon?
			'../img/gazon.png'
		elsif self.statutVisible.isTente?
			'../img/tente.png'
		end
	end
end
