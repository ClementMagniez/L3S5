##
# @title TempsChrono
# @author KAJAK Rémi
# @version 0.1
#

##
# = Classe *Time*
#
# Pour simplifier la compréhension du code, on ajoute une méthode utile dans la classe *Time*.
#
class Time
  ##
  # == afficherTempsChrono(0)
  #
  # Cette méthode permet d'afficher un objet de la classe *Time* sous le format "minutes:secondes".
  #
  def afficherTempsChrono()
    return strftime("%M:%S")
  end
end

##
# = Classe *String*
#
# Pour pouvoir calculer un nombre à partir d'un temps donné, il est nécessaire d'ajouter une
# méthode à la classe *String*.
#
class String
  ##
  # == convertirTempsEnEntier(0)
  #
  # Cette méthode permet de transformer un objet de la classe *Time* en un entier représentant
  # le nombre total de secondes pour un temps donné en minutes et en secondes.
  #
  def convertirTempsEnEntier()
    minutes = true
    nbSecondes = 0

    split(":").each { |t|
      nbSecondes += (minutes == true) ? t.to_i * 60 : t.to_i
      minutes = false
    }

    return nbSecondes
  end
end
