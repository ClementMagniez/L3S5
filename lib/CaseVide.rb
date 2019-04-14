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

	# TODO refactoriser cycle/cancel

	# Fait cycler la case sur "vide->gazon->tente" et met à jour les indicateurs
	# de tente restante
	# - grille : la Grille de jeu
	# - return self
	def cycle(grille)
		self.statutVisible.cycle

		self.updateNbTents(grille, :'isVide?')
		
		super(grille)
		self
	end
	# @see Case#cancel
	def cancel(grille)
	
		self.statutVisible.cancel
		self.updateNbTents(grille, :'isGazon?')
		

		self
	end
	
	# Met à jour les varTentesCol et varTentesLigne de la grille selon le statut
	# de self et vérifie la validité de la grille
	# - grille : la Grille de jeu
	# - afterTent : symbol de 'isGazon?' ou 'isVide?' déterminant quel type de case
	# vient après :TENTE dans le cycle ; permet de différencier cancel et cycle
	# - return true si la grille est complète, false sinon
	def updateNbTents(grille, afterTent)
		i=
		j=

		if self.statutVisible.isTente? # le statut vient de devenir "tente"
			grille.varTentesLigne[self.x]-=1
			grille.varTentesCol[self.y]-=1
		elsif self.statutVisible.send(afterTent) # le statut était "tente"
			grille.varTentesLigne[self.x]+=1
			grille.varTentesCol[self.y]+=1
		end

		if grille.varTentesLigne[self.x]==0 && grille.varTentesCol[self.y]==0
			return grille.estComplete?
		end
		false
	end
	


	def affichageSubr
		if self.statutVisible.isGazon?
			'../img/gazonSubr.png'
		elsif self.statutVisible.isTente?
			'../img/tenteSubr.png'
		else
			'../img/Subr.png'
		end
	end

	def affichage
		if self.statutVisible.isGazon?
			'../img/gazon.png'
		elsif self.statutVisible.isTente?
			'../img/tente.png'
		else
			'../img/gris.png'
		end
	end
end
