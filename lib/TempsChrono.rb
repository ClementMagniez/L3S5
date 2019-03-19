##
# @title TempsChrono
# @author KAJAK Rémi
# @version 0.1
#

##
# = Module *TempsChrono*
#
# Le module *TempsChrono* comporte des méthodes pour les classes concernées par le mode
# "Contre-la-montre" de l'application.
#
module TempsChrono
  ##
  # == convertirTempsEnEntier(0)
  #
  # Cette méthode permet de transformer un objet de la classe *Time* en un entier représentant
  # le nombre total de secondes pour un temps donné en minutes et en secondes.
  #
  def convertirTempsEnEntier()
    minutes = true
    nbSecondes = 0

    if(this.strftime("%M:%S").split(":").size == 2)
      this.strftime("%M:%S").split(":").each { |t|
         nbSecondes += (minutes == true) ? t.to_i * 60 : t.to_i
         minutes = false
      }
      return nbSecondes
    else
      puts "Format de temps incorrect : temps composé de minutes et de secondes attendu !"
    end
  end
end
