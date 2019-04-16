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
  # == getValeur(0)
  #
  # Getter de la variable d'instance +valeur+.
  #
  def getValeur
    return @valeur
  end

  ##
  # == appelerAssistant(0)
  #
  # Cette méthode permet d'incrémenter d'une unité le compteur lié aux aides. L'annulation de coups
  # par le joueur ne permet pas de diminuer ce compteur (le cas échéant, il s'agirait d'une triche).
  #
  def appelerAssistant
    @nbAidesUsees += 1
  end

  ##
  # == calculerScoreFinal(0)
  #
  # Cette méthode retourne le résultat de la partie, calculé avec toutes les variables d'instance
  # initialisées et modifiées depuis la création de l'objet.
  #
  def calculerScoreFinal
		puts self
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
    scoreFinal /= (@modeChrono) ? (@tempsDeJeu / 100.0) : @tempsDeJeu
		
    return scoreFinal.to_i * @bonus
  end

  ##
  # == estModeChrono(0)
  #
  # Cette méthode permet de passer le booléen du mode "contre-la-montre" à +true+.
  #
  # === Attribut
  #
  # * +modeChrono+ - Le booléen indiquant si le score final doit être calculé selon la règle du "contre-la-montre"
  #
  def estModeChrono
    @modeChrono = true
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
  def recupererPoints(pointsCase)
    @valeur += pointsCase
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
  def recupererTemps(tempsGrille)
    @tempsDeJeu = tempsGrille
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
  def reset
    @nbAidesUsees = 0
    @valeur = 0
  end

	##
	# == to_s
	#
	# On redéfinit la méthode *to_s* dans cette classe pour qu'elle puisse afficher les informations de
	# l'objet appelé.
	#
	def to_s
		return "Score : #{@valeur} (bonus #{@bonus}x ; #{@nbAidesUsees} aide(s) utilisée(s) => malus de #{@malus}%, #{@tempsDeJeu} secondes)"
	end
end
