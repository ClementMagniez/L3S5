require_relative 'Case'

# Implémente Case pour les cases apparaissant vides au joueur à la création de 
# la grille. Un clic sur ces cases en modifie l'apparence et met à jour les
# valeurs du nombre de tentes (c'est-à-dire que cliquer sur une CaseVide pour en
# faire une tente décrémente le nombre de tentes restantes sur la ligne/colonne)
# Relativement à Case, une CaseVide dispose d'un statut visible en plus de son
# statut interne, ce qui permet de laisser au joueur la possibilité de se tromper. 
class CaseVide < Case
	
	def initialize(etat)
		super
		@statutVisible=Statut.new(VIDE)
	end
		
	# Fait cycler la case sur "vide->gazon->tente" et met à jour les indicateurs
	# de tente restante
	# TODO - vérifier que les i,j sont bien cohérents
	def cycle(i,j,arrayColonnes, arrayLignes)
		self.statutVisible.cycle
		
		if self.statutVisible.isTente? # le statut vient de devenir "tente" 
			arrayColonnes[i]+=1
			arrayLignes[j]+=1
		elsif self.statutVisible.isVide? # le statut était "tente" 
			arrayColonnes[i]-=1
			arrayLignes[j]-=1
		end	
		self
	end

	protected
	attr_reader :statutVisible

end
