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
		@statutVisible=StatutVide.new(VIDE)
	end

	# TODO refactoriser cycle/cancel

	# Fait cycler la case sur "vide->gazon->tente" et met à jour les indicateurs
	# de tente restante
	def cycle(grille)
		self.statutVisible.cycle()
		i=self.x
		j=self.y


		if self.statutVisible.isGazon? # le statut vient de devenir "gazon"
			grille.score.recupererPoints(1)
		elsif self.statutVisible.isTente? # le statut vient de devenir "tente"
			grille.varTentesLigne[i]-=1
			grille.varTentesCol[j]-=1
			grille.score.recupererPoints(5)
		elsif self.statutVisible.isVide? # le statut vient de devenir "vide"
			grille.varTentesLigne[i]+=1
			grille.varTentesCol[j]+=1
			grille.score.recupererPoints(-10)
		end
		puts grille.score

		if grille.varTentesLigne[i]==0 && grille.varTentesCol[j]==0
			grille.estComplete?
		end
		super(grille)
		self
	end

	def cancel(grille)

		self.statutVisible.cancel
		i=self.x
		j=self.y

		if self.statutVisible.isGazon? # le statut vient de repasser à "gazon"
			grille.score.recupererPoints(-5)
		elsif self.statutVisible.isTente? # le statut vient de repasser à "tente"
			grille.varTentesLigne[i]-=1
			grille.varTentesCol[j]-=1
			grille.score.recupererPoints(10)
		elsif self.statutVisible.isVide? # le statut vient de repasser à "vide"
			grille.varTentesLigne[i]+=1
			grille.varTentesCol[j]+=1
			grille.score.recupererPoints(-1)
		end
		puts grille.score

		if grille.varTentesLigne[i]==0 && grille.varTentesCol[j]==0
			grille.estComplete?
		end
		self
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
		end
	end
end
