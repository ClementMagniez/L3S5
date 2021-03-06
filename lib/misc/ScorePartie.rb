##
# @title ScorePartie
# @author KAJAK Rémi
# @version 0.1
#

##
# = Classe *ScorePartie*
#
# La classe *ScorePartie* a pour rôle de gérer l'évolution du score d'une partie. Une instance peut récupérer
# diverses informations depuis l'interface et mettre à jour ses données en fonction des paramètres envoyés.
#
class ScorePartie

	attr_reader :valeur

  # @bonus, @malus, @modeChrono, @nbAidesUsees, @taille, @tempsDeJeu, @valeur - Le pourcentage appliqué selon la difficulté
  # sélectionnée, le pourcentage appliqué pour pénaliser une utilisation trop répétitive des aides, le nombre d'aides
  # utilisées lors d'une partie, le booléen déterminant le type de chronomètre, la taille de la grille liée, le temps de jeu
  # selon le mode, le montant numérique du score

  ##
	# == initialize(0)
	#
	# Comme nous n'avons pas besoin de privatiser la méthode *new*, nous pouvons directement redéfinir cette
  # méthode.
	#
	# === Paramètre
	#
	# * +tailleMatrice+ - Un entier strictement positif
	#
	# === Attributs
	#
	# * +bonus+ - L'entier indiquant le pourcentage positif appliqué selon la difficulté
	# * +malus+ - L'entier indiquant le pourcentage négatif appliqué selon la difficulté
	# * +modeChrono+ - Le booléen indiquant si le score final doit être calculé selon la règle du "contre-la-montre"
	# * +nbAidesUsees+ - L'entier indiquant le nombre de fois où l'assistant a été activé par le joueur
	# * +taille+ - L'entier indiquant la taille de la matrice liée
	# * +tempsDeJeu+ - Le nombre de secondes indiquant le temps de jeu total (varie selon le mode)
	# * +valeur+ - L'entier déterminant le score d'une partie
	#
  def initialize(tailleMatrice)
    @modeChrono, @nbAidesUsees, @taille, @tempsDeJeu, @valeur = false, 0, tailleMatrice, 100, 0
    # FACILE - Bonus x1, 3% de malus
    if(@taille < 9)
      @bonus = 1
      @malus = 0.03
    # DIFFICILE - Bonus x3, 10% de malus
    elsif(@taille >= 12)
      @bonus = 3
      @malus = 0.1
    # MOYEN - Bonus x1.5, 5% de malus
    else
      @bonus = 1.5
      @malus = 0.05
    end
  end

  ##
  # == appelerAssistant(0)
  #
  # Cette méthode permet d'incrémenter d'une unité le compteur lié aux aides. L'annulation de coups
  # par le joueur ne permet pas de diminuer ce compteur (le cas échéant, il s'agirait d'une triche).
  #
  # Return self
  def appelerAssistant
    @nbAidesUsees += 1
    self
  end

  ##
  # == calculerScoreFinal(0)
  #
  # Cette méthode retourne le résultat de la partie, calculé avec toutes les variables d'instance
  # initialisées et modifiées depuis la création de l'objet.
  #
	# Return un Integer décrivant le score final de la partie
  def calculerScoreFinal
    # FACILE
    if(@taille < 9 && @nbAidesUsees > 1)
      nbMalus = @nbAidesUsees - 1
    # MOYEN
    elsif(@taille >= 9 && @taille < 12 && @nbAidesUsees > 2)
      nbMalus = @nbAidesUsees - 2
    # DIFFICILE
    elsif(@taille >= 12 && @nbAidesUsees > 3)
      nbMalus = @nbAidesUsees - 3
    # PAR DÉFAUT
    else
      nbMalus = 0
    end
    scoreFinal = @valeur - @valeur * (@malus * nbMalus)

		if(@modeChrono)
			coefTemps = @tempsDeJeu / 100.0
		else
			if(@tempsDeJeu >= 1 && @tempsDeJeu <= 9)
				coefTemps = (10 - @tempsDeJeu)
			elsif(@tempsDeJeu >= 10 && @tempsDeJeu <= 99)
				coefTemps = (100 - @tempsDeJeu) * 0.01
			elsif(@tempsDeJeu >= 100 && @tempsDeJeu <= 899)
				coefTemps = (1000 - @tempsDeJeu) * 0.001
			else
				coefTemps = 0
			end
		end
    scoreFinal = (@modeChrono) ? scoreFinal / coefTemps : scoreFinal * coefTemps

    return scoreFinal.to_i * @bonus
  end

  ##
  # == setModeChrono(0)
  #
  # Cette méthode permet de passer le booléen du mode "contre-la-montre" à +true+.
  #
  # === Attribut
  #
  # * +modeChrono+ - Le booléen indiquant si le score final doit être calculé selon la règle du "contre-la-montre"
  #
  # Return self
  def setModeChrono
    @modeChrono = true
    self
  end

  ##
  # == recupererPoints(1)
  #
  # Cette méthode permet d'additionner les points d'une case au montant du score d'une grille.
  #
  # === Paramètre
  #
  # * +pointsCase+ - Un entier positif ou négatif
  #
  # === Attribut
  #
  # * +valeur+ - L'entier déterminant le score d'une partie
  #
  # Return self
  def recupererPoints(pointsCase)
    @valeur += pointsCase
    self
  end

  ##
  # == recupererTemps(1)
  #
  # Cette méthode permet de récupérer un temps donné et de l'enregistrer en tant que chaîne de
  # caractères.
  #
  # === Paramètre
  #
  # * +tempsGrille+ - Un nombre réel strictement positif
  #
  # === Attribut
  #
  # * +tempsDeJeu+ - Le nombre de secondes indiquant le temps de jeu total (varie selon le mode)
  #
  # Return self
  def recupererTemps(tempsGrille)
    @tempsDeJeu = tempsGrille
    self
  end


	##
	# == reduceScoreExplo(0)
	#
	# Méthode donnant un accesseur restreint à @valeur, réduite à sa racine 
	# lors d'un appel d'aide en mode exploration
	# Return self
	def reduceScoreExplo
		@valeur=Math.sqrt(@valeur).to_i
		self
	end


  ##
  # == reset(0)
  #
  # Cette méthode remet le score et le nombre d'aides utilisées de l'objet appelant à zéro. Elle s'active
  # lors du reset d'une partie jouée.
  #
  # === Attributs
  #
  # * +nbAidesUsees+ - L'entier indiquant le nombre de fois où l'assistant a été activé par le joueur
  # * +valeur+ - L'entier déterminant le score d'une partie
  #
  # Return self
  def reset
    @nbAidesUsees = 0
    @valeur = 0
    self
  end

	##
	# == to_s
	#
	# Return les données décrivant self sous forme de String
	#
	def to_s
		return "Score : #{@valeur} (bonus #{@bonus}x ; #{@nbAidesUsees} aide(s) utilisée(s) => malus de #{@malus}%, #{@tempsDeJeu} secondes)"
	end
end
