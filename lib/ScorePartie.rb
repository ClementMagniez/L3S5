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

  # @bonus, @malus, @nbAidesUsees, @valeur - Le pourcentage appliqué selon la difficulté sélectionnée, le
  # pourcentage appliqué pour pénaliser une utilisation trop répétitive des aides, le nombre d'aides utilisées
  # lors d'une partie, le montant numérique du score

  attr_reader :bonus, :malus, :nbAidesUsees, :valeur

  ##
	# == initialize(0)
	#
	# Comme nous n'avons pas besoin de privatiser la méthode *new*, nous pouvons directement redéfinir cette
  # méthode.
	#
	# === Attributs
	#
	# * +bonus+ - L'entier indiquant le pourcentage positif appliqué selon la difficulté
	# * +malus+ - L'entier indiquant le pourcentage négatif appliqué selon la difficulté
	# * +nbAidesUsees+ - L'entier indiquant le nombre de fois où l'assistant a été activé par le joueur
	# * +valeur+ - L'entier déterminant le score d'une partie
	#
  def initialize
    @bonus = 0
    @malus = 0
    @nbAidesUsees = 0
    @valeur = 0
  end

  ##
	# == definirPourcentages(1)
	#
	# Cette méthode permet d'attribuer des valeurs non-nulles aux pourcentages du bonus et du malus.
	#
	# === Paramètre
	#
	# * +taille+ - Un entier indiquant la taille de la grille (et donc, la difficulté de la partie)
	#
	# === Attributs
	#
	# * +bonus+ - L'entier indiquant le montant de la multiplication appliquée à la fin de la partie
	# * +malus+ - L'entier indiquant le pourcentage négatif appliqué à la fin de la partie
	#
  def definirPourcentages(taille)
    # FACILE
    if(taille < 9)
      @bonus = 1
      @malus = -0,03
    # DIFFICILE
    elsif(taille > 12)
      @bonus = 3
      @malus = -0,1
    # MOYEN
    else
      @bonus = 1,5
      @malus = -0,05
    end
  end

  ##
  # == appelerAssistant(0)
  #
  # Cette méthode permet d'incrémenter d'une unité le compteur lié aux aides. L'annulation de coups
  # par le joueur ne permet pas de diminuer ce compteur (le cas échéant, il s'agirait d'une triche).
  #
  def appelerAssistant
    ++@nbAidesUsees
  end

  ##
  # == calculerScoreFinal(1)
  #
  # Cette méthode retourne le résultat de la partie, calculé avec toutes les variables d'instance
  # initialisées et modifiées depuis la création de l'objet.
  #
  # === Paramètre
  #
  # * +tempsRestant+ - L'entier qui indique le nombres de secondes restantes (pour le mode chrono)
  #
  def calculerScoreFinal(tempsRestant)
    scoreFinal = (@score - @score * @malus) * @bonus
    return (tempsRestant == nil) ? scoreFinal : scoreFinal * (tempsRestant / 100)
  end

  ##
  # == reset(0)
  #
  # Cette méthode remet à zéro toutes les variables de l'objet appelant. Elle s'active lors
  # du reset d'une partie jouée.
  #
  # === Attributs
  #
  # * +bonus+ - L'entier indiquant le pourcentage positif appliqué selon la difficulté
  # * +malus+ - L'entier indiquant le pourcentage négatif appliqué selon la difficulté
  # * +nbAidesUsees+ - L'entier indiquant le nombre de fois où l'assistant a été activé par le joueur
  # * +valeur+ - L'entier déterminant le score d'une partie
  #
  def reset
    @bonus = 0
    @malus = 0
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
		return "Score actuel : #{@valeur} (bonus de #{@bonus}% ; #{@nbAidesUsees} aide(s) utilisée(s) => malus de #{@malus}%)"
	end
end