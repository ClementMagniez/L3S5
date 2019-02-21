# require_relative 'Grille'
 
class Aide
 
  include StatutConstantes
 
  def initialize(grille)
    @grille=grille
  end
 
  # renvoie le nombre d'erreur qu'il y a dans la grille (lorsque la case est "vide", ce n'est pas une erreur)
  def casesIncorrect
 
    nbErr = 0
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    @grille.grille.each do | ligne |
      ligne.each do | cases |
 
          # print cases.class.to_s + "   " + cases.to_s + "\n"
          # print cases.statut.class.to_s + "   " + cases.statut.to_s + "\n"
          # print cases.statutVisible.class.to_s + "   " + cases.statutVisible.to_s + "\n\n"
       
        #######################################################################################################
        # Là on rajoute 1 erreur si le statut visible de la case n'est pas identique a son statut véritable
        # et seulement si la case n'est pas vide ou qu'il ne s'agisse pas d'un arbre
        #######################################################################################################
        nbErr += 1 if (cases.statutVisible != cases.statut && cases.statutVisible != newStatutVide && cases.statut != newStatutArbre)
      end
    end
    return nbErr
  end
 
  # indique la ligne où il ne reste plus que des tentes à mettre, sinon renvoie 0
  def resteQueTentesLigne
    resteQueLigne(TENTE)
  end
 
  # indique la ligne où il ne reste plus que de l'herbe à mettre, sinon renvoie 0
  def resteQueHerbeLigne
    resteQueLigne(GAZON)
  end
 
 
  # indique la colonne où il ne reste plus que des tentes à mettre, sinon renvoie 0
  def resteQueTentesColonne
    resteQueColonne(TENTE)
  end
 
  # indique la colonne où il ne reste plus que de l'herbe à mettre, sinon renvoie 0
  def resteQueHerbeColonne
    resteQueColonne(GAZON)
  end
 
    # cf resteQue, col?==false
    def resteQueLigne(gazonOuTente)
        resteQue(gazonOuTente, false)
    end
 
    # cf resteQue, col?==true
    def resteQueColonne(gazonOuTente)
    resteQue(gazonOuTente, true)
  end
 
 
    # Metaméthode O(N²) : parcourt la grille en ligne ou en colonne selon col?
    # et renvoie une valeur dépendant de gazonOuTente :
    # * TENTE - cf. resteQueTentesColonne et resteQueTentesLigne
    # * GAZON - cf. resteQueHerbeColonne et resteQueHerbeLigne
    # * autres - 0
    def resteQue(gazonOuTente, col)
   
      num = 0

      newStatutVide = StatutVide.new(VIDE)
      newStatutTente = StatutVide.new(TENTE)
     
      grille=@grille.grille
      grille=grille.transpose if col
       
      grille.each_with_index do | array,i |
        nbCasesVide = 0
        nbCasesTente = 0
        array.each do | cases |
         
          nbCasesVide += 1 if cases.statutVisible == newStatutVide
          nbCasesTente += 1 if cases.statutVisible == newStatutTente
         
        end
        # print "Valeur de grille " + @grille.tentesCol[i].to_s + "\n"
        # print "Nombre cases vide = " + nbCasesVide.to_s + " Nombre cases tentes = " + nbCasesTente.to_s + "\n\n"

        if col
          if gazonOuTente==GAZON
            num = i+1 if nbCasesTente == @grille.tentesCol[i] && nbCasesVide != 0
          elsif gazonOuTente==TENTE
            num = i+1 if nbCasesVide == @grille.tentesCol[i]-nbCasesTente && nbCasesVide != 0
          end
        else
          if gazonOuTente==GAZON
            num=i+1 if nbCasesTente == @grille.tentesLigne[i] && nbCasesVide!=0
          elsif gazonOuTente==TENTE
            num=i+1 if nbCasesVide == @grille.tentesLigne[i]-nbCasesTente && nbCasesVide!=0
          end
        end

        
      end
      return num
    end
 
 
  # renvoie la premiere case qui n'est pas a cote d'un arbre, il s'agit donc de gazon
  def casePasACoteArbre
 
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    grille=@grille.grille
 
    for i in 0..grille.length-1
      for j in 0..grille.length-1
        ok = true
        if (grille[i][j].statutVisible == newStatutVide)
          # print "Valeur de ligne = " + ligne.class.to_s + "\n\n"
         
          if (i-1 >= 0 && grille[i-1][j].statut == newStatutArbre) || (j-1 >= 0 && grille[i][j-1].statut == newStatutArbre) || (i+1 <= grille.length-1 && grille[i+1][j].statut == newStatutArbre) || (j+1 <= grille.length-1 && grille[i][j+1].statut == newStatutArbre)
            ok = false
          end            
          print "\n\nValeur de i et j = " + i.to_s + " " + j.to_s + "\n" if ok
 
          return grille[i][j] if ok
 
 
          # return @grille.grille[i][j] if (@grille.grille[i][j-1].statut != newStatutArbre && @grille.grille[i][j+1].statut != newStatutArbre && @grille.grille[i-1][j].statut != newStatutArbre && @grille.grille[i+1][j].statut != newStatutArbre)
        end
      end
    end
    return 0
 
  end
 
  # renvoie la premiere case où il n'existe qu'une seule possibilité pour un arbre
  def uniquePossibiliteArbre
 
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    newStatutTente = StatutVide.new(TENTE)
   
    grille=@grille.grille
   
    for i in 0..grille.length-1
      for j in 0..grille.length-1
        nbCasesVide = 0
        nbCasesTente = 0
        if (grille[i][j].statut == newStatutArbre)
         
          if (i-1 >= 0)
            nbCasesVide += 1 if (grille[i-1][j].statutVisible == newStatutVide)
            nbCasesTente += 1 if (grille[i-1][j].statutVisible == newStatutTente)
          end
          if (i+1 <= grille.length-1)
            nbCasesVide += 1 if (grille[i+1][j].statutVisible == newStatutVide)
            nbCasesTente += 1 if (grille[i+1][j].statutVisible == newStatutTente)
          end
          if (j-1 >= 0)
            nbCasesVide += 1 if (grille[i][j-1].statutVisible == newStatutVide)
            nbCasesTente += 1 if (grille[i][j-1].statutVisible == newStatutTente)
          end
          if (j+1 <= grille.length-1)
            nbCasesVide += 1 if (grille[i][j+1].statutVisible == newStatutVide)
            nbCasesTente += 1 if (grille[i][j+1].statutVisible == newStatutTente)
          end
           
          print "\n\nValeur de i et j = " + i.to_s + " " + j.to_s + "\n" if (nbCasesVide == 1 && nbCasesTente == 0)
 
          return grille[i][j] if (nbCasesVide == 1 && nbCasesTente == 0)
 
 
          # return @grille.grille[i][j] if (@grille.grille[i][j-1].statut != newStatutArbre && @grille.grille[i][j+1].statut != newStatutArbre && @grille.grille[i-1][j].statut != newStatutArbre && @grille.grille[i+1][j].statut != newStatutArbre)
        end
      end
    end
    return 0
 
  end
 
  # renvoie la premiere case où tous les arbres autour de la case possèdent leur tente, donc la case contient de l'herbe
  # def arbreAutourCasePossedeTente
 
  # end
 
  # renvoie la premiere case où les dispositions possibles de la ligne obligeront la case à etre de l'herbe
  # def dispositionPossibleLigneHerbe
 
  # end
 
  # renvoie la premiere case où les dispositions possibles de la colonne obligeront la case à etre de l'herbe
  # def dispositionPossibleColonneHerbe
 
  # end
 
  def cycle
 
    if (funcReturn=self.casesIncorrect) != 0
      return "Il y a " + funcReturn.to_s + " erreur(s)"
    elsif (funcReturn=self.resteQueTentesLigne) != 0
      return "Il ne reste que des tentes à placer sur la ligne " + funcReturn.to_s
    elsif (funcReturn=self.resteQueTentesColonne) != 0
      return "Il ne reste que des tentes à placer sur la colonne "+ funcReturn.to_s
    elsif (funcReturn=self.resteQueHerbeLigne) != 0
      return "Il ne reste que du gazon à placer sur la ligne " + funcReturn.to_s
    elsif (funcReturn=self.resteQueHerbeColonne) != 0
      return "Il ne reste que du gazon à placer sur la colonne " + funcReturn.to_s
    elsif (funcReturn=self.casePasACoteArbre) != 0
      return "La case " + funcReturn.class.to_s + " est forcement du gazon\n"
    elsif (funcReturn=self.uniquePossibiliteArbre) != 0
      return "Il n'y a qu'une seule possibilité de placer une tente pour l'arbre " + funcReturn.class.to_s
    else
      return "Aucune aide disponible ..."
    end
     
  end
end