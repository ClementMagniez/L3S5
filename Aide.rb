 
class Aide
 
  include StatutConstantes
 
  #####################################################################################################
  # Class CaseCoordonnees permettant de lier une case avec ces coordonnées en abscisse et en ordonnée
  Object.const_set("CaseCoordonnees", Class.new)
  laClasse = Object.const_get("CaseCoordonnees")
  
  laClasse::module_eval{ 
    define_method(:initialize) do |cases, i, j|
      @cases, @i, @j = cases, i, j
    end

    define_method(:getCase){ 
      return @cases
    }

    define_method(:getI){ 
      return @i
    }

    define_method(:getJ){ 
      return @j
    }

  }
  #####################################################################################################

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
        #######################################################################################################
        # Là on rajoute 1 erreur si le statut visible de la case n'est pas identique a son statut véritable
        # et seulement si la case n'est pas vide ou qu'il ne s'agisse pas d'un arbre
        #######################################################################################################
        nbErr += 1 if (cases.statutVisible != cases.statut && cases.statutVisible != newStatutVide && cases.statut != newStatutArbre)
        # case.estValide? à tester
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
          # print "\n\nValeur de i et j = " + i.to_s + " " + j.to_s + "\n" if ok

          # MODIF EN TEST
          caseCoord = CaseCoordonnees.new(grille[i][j], i, j)
          return caseCoord if ok
          # return grille[i][j] if ok
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
           
          # print "\n\nValeur de i et j = " + i.to_s + " " + j.to_s + "\n" if (nbCasesVide == 1 && nbCasesTente == 0)
 
          return grille[i][j] if (nbCasesVide == 1 && nbCasesTente == 0)
        end
      end
    end

    return 0
  end
 
  # renvoie la premiere case où tous les arbres autour de la case possèdent leur tente, donc la case contient de l'herbe
  def arbreAutourCasePossedeTente
    arbreAssocieTente("vide")
  end

  # renvoie la première caseArbre qui n'a pas placer sa tente et qui ne possède qu'une case seule caseVide à côté d'elle
  def caseArbreAssocieTente
    arbreAssocieTente("arbre")
  end


  def arbreAssocieTente(arbreOuVide)

    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    newStatutTente = StatutVide.new(TENTE)
   
    grille=@grille.grille
    hashArbreTente = Hash.new
    compt = 0

    # Tant que la taille de la table de hashage est différente du nombre de tentes de la grille, on boucle ...
    while hashArbreTente.size != @grille.tentesCol.sum
      compt += 1
      # On parcourt toutes les cases de la grille  
      for i in 0..grille.length-1
        for j in 0..grille.length-1

          nbCasesTente = 0

          # Si la case est une caseArbre
          if grille[i][j].statut == newStatutArbre
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_key?(grille[i][j])
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseTente et qu'elle ne soit pas déjà dans la table
              if i-1 >= 0
                nbCasesTente += 1 if grille[i-1][j].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i-1][j]))
                derniereCoordI = i-1 if grille[i-1][j].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i-1][j]))
              end
              if i+1 <= grille.length-1
                nbCasesTente += 1 if grille[i+1][j].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i+1][j]))
                derniereCoordI = i+1 if grille[i+1][j].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i+1][j]))
              end
              if j-1 >= 0
                nbCasesTente += 1 if grille[i][j-1].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i][j-1]))
                derniereCoordJ = j-1 if grille[i][j-1].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i][j-1]))
              end
              if j+1 <= grille.length-1
                nbCasesTente += 1 if grille[i][j+1].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i][j+1]))
                derniereCoordJ = j+1 if grille[i][j+1].statut == newStatutTente && (! hashArbreTente.has_value?(grille[i][j+1]))
              end
              # On rajoute la caseArbre actuelle si seulement elle ne s'est associée qu'à une seule autre caseTente
              hashArbreTente[grille[i][j]] = grille[derniereCoordI][derniereCoordJ] if nbCasesTente == 1
            end
          # Sinon si la case est une caseTente
          elsif grille[i][j].statut == newStatutTente
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_value?(grille[i][j])
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseArbre et qu'elle ne soit pas déjà dans la table
              if i-1 >= 0
                nbCasesTente += 1 if grille[i-1][j].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i-1][j]))
                derniereCoordI = i-1 if grille[i-1][j].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i-1][j]))
              end
              if i+1 <= grille.length-1
                nbCasesTente += 1 if grille[i+1][j].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i+1][j]))
                derniereCoordI = i+1 if grille[i+1][j].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i+1][j]))
              end
              if j-1 >= 0
                nbCasesTente += 1 if grille[i][j-1].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i][j-1]))
                derniereCoordJ = j-1 if grille[i][j-1].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i][j-1]))
              end
              if j+1 <= grille.length-1
                nbCasesTente += 1 if grille[i][j+1].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i][j+1]))
                derniereCoordJ = j+1 if grille[i][j+1].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[i][j+1]))
              end
              # On rajoute la caseTente actuelle si seulement elle ne s'est associée qu'à une seule autre caseArbre
              hashArbreTente[grille[derniereCoordI][derniereCoordJ]] = grille[i][j] if nbCasesTente == 1

            end
          end
        end
      end
    end


    if arbreOuVide == "arbre"

      for i in 0..grille.length-1
        for j in 0..grille.length-1

          nbCasesVide = 0

          # Si la case est une caseArbre et que sa tente associée est en caseVide
          if grille[i][j].statut == newStatutArbre && hashArbreTente.fetch(grille[i][j]).statutVisible == newStatutVide
              # On prend connaissance pour les 4 cases adjacentes
              if i-1 >= 0
                nbCasesVide += 1 if grille[i-1][j].statutVisible == newStatutVide
              end
              if i+1 <= grille.length-1
                nbCasesVide += 1 if grille[i+1][j].statutVisible == newStatutVide
              end
              if j-1 >= 0
                nbCasesVide += 1 if grille[i][j-1].statutVisible == newStatutVide
              end
              if j+1 <= grille.length-1
                nbCasesVide += 1 if grille[i][j+1].statutVisible == newStatutVide
              end
              return grille[i][j] if nbCasesVide == 1
          end
        end
      end

    elsif arbreOuVide == "vide"

      for i in 0..grille.length-1
        for j in 0..grille.length-1

          isOk = 1

          # Si la case est une caseVide
          if grille[i][j].statutVisible == newStatutVide
              # On prend connaissance pour les 4 cases adjacentes
              if i-1 >= 0
                if hashArbreTente.member?(grille[i-1][j])
                  isOk = 0 if hashArbreTente.fetch(grille[i-1][j]).statutVisible != newStatutTente
                end
              end
              if i+1 <= grille.length-1
                if hashArbreTente.member?(grille[i+1][j])
                  isOk = 0 if hashArbreTente.fetch(grille[i+1][j]).statutVisible != newStatutTente
                end
              end
              if j-1 >= 0
                if hashArbreTente.member?(grille[i][j-1])
                  isOk = 0 if hashArbreTente.fetch(grille[i][j-1]).statutVisible != newStatutTente
                end
              end
              if j+1 <= grille.length-1
                if hashArbreTente.member?(grille[i][j+1])
                  isOk = 0 if hashArbreTente.fetch(grille[i][j+1]).statutVisible != newStatutTente
                end
              end
              return grille[i][j] if isOk == 1
          end
        end
      end # FinForI

    end # FinElse
    return 0
  end

 
  # renvoie la premiere case où les dispositions possibles de la ligne obligeront la case à etre de l'herbe
  def dispositionPossibleLigne
    dispositionPossible(false)
  end
 
  # renvoie la premiere case où les dispositions possibles de la colonne obligeront la case à etre de l'herbe
  def dispositionPossibleColonne
    dispositionPossible(true)
  end


  def dispositionPossible(col)

    newStatutVide = StatutVide.new(VIDE)
    newStatutTente = StatutVide.new(TENTE)
    grille=@grille.grille
    grille=grille.transpose if col

    for i in 0..grille.length-1
      nbCasesTente = 0
      casePrecedente = false
      nbCaseVideSucc = 0
      nbTentePoss = 0
      hashGroupeCase = Hash.new # => la table de hashage contient comme clé la première case vide et en valeur le nombre de case(s) vide(s) qui suive(nt) la première case (inclus)
      for j in 0..grille.length-1
        
          nbCasesTente += 1 if grille[i][j].statutVisible == newStatutTente
          if grille[i][j].statutVisible == newStatutVide
            nbTentePoss += 1 if nbCaseVideSucc%2 == 0
            nbCaseVideSucc += 1
          else
            nbCaseVideSucc = 0
          end
          
          if grille[i][j].statutVisible == newStatutVide && casePrecedente == false
            premiereCase = CaseCoordonnees.new(grille[i][j], i, j)
            hashGroupeCase[premiereCase] = 1
            casePrecedente = true
          elsif grille[i][j].statutVisible == newStatutVide && casePrecedente == true
            hashGroupeCase[premiereCase] = hashGroupeCase.values_at(premiereCase).pop.to_i+1
          elsif grille[i][j].statutVisible != newStatutVide
            casePrecedente = false
          end

      end

      # on alloue la mémoire des tableaux
      if col
        tabCaseEnTente = Array.new(@grille.tentesCol[i]-nbCasesTente)
      else
        tabCaseEnTente = Array.new(@grille.tentesLigne[i]-nbCasesTente)
      end
      tabCaseEnGazon1 = Array.new(20)
      tabCaseEnGazon2 = Array.new(20)

      # pour chaque groupe de case(s) vide(s)
      hashGroupeCase.each {|key, value| 
        # correspond aux coordonnées de la case "clé"
        i = key.getI
        j = key.getJ

        # si le nombre de case(s) successive(s) est impaire
        if value%2 != 0
          k = 1
          # on met dans la table une case sur 2 qui deviendront potentiellement une tente
          while k <= value
            tabCaseEnTente.unshift(grille[i][j+k-1])
            k += 2
          end
        # sinon si c'est pair
        else
          # on met dans la table les cases au dessus et en dessous dans la table des cases qui deviendront potentiellement du gazon
          for k in 0..value-1
            tabCaseEnGazon1.unshift(grille[i+1][j+k]) if grille[i+1][j+k].statutVisible == newStatutVide && i+1 <= grille.length-1
            tabCaseEnGazon1.unshift(grille[i-1][j+k]) if grille[i-1][j+k].statutVisible == newStatutVide && i-1 >= 0
          end
        end

        # si le nombre de case(s) successive(s) est impaire et supérieure à 1
        if value%2 != 0 && value > 1
          k = 1
          while k < value
            if i+1 <= grille.length-1 && j+1 <= grille.length-1
              tabCaseEnGazon2.unshift(grille[i+1][j+k]) if grille[i+1][j+k].statutVisible == newStatutVide
            end
            if i-1 >= 0 && j+1 <= grille.length-1
              tabCaseEnGazon2.unshift(grille[i-1][j+k]) if grille[i-1][j+k].statutVisible == newStatutVide
            end
            k += 2
          end
        # sinon si le nombre de case(s) successive(s) est impaire et égal à 1
        elsif value%2 != 0 && value == 1
          if j+2 <= grille.length-1
            if grille[i][j+2].statutVisible == newStatutVide
              sontEgaux = false
              nbCaseVideSuivante = 1
              hashGroupeCase.each { |key2, value2| 
                if sontEgaux
                  nbCaseVideSuivante = value2
                  sontEgaux = false
                end
                sontEgaux = true if key == key2
              }
              if i+1 <= grille.length-1
                tabCaseEnGazon2.unshift(grille[i+1][j+1]) if grille[i+1][j+1].statutVisible == newStatutVide && nbCaseVideSuivante%2 != 0
              end
              if i-1 >= 0
                tabCaseEnGazon2.unshift(grille[i-1][j+1]) if grille[i-1][j+1].statutVisible == newStatutVide && nbCaseVideSuivante%2 != 0
              end
            end
          end
        end
      }#FinEach


      # On enleve le surplus de place alloué
      tabCaseEnTente.compact!
      tabCaseEnGazon1.compact!
      tabCaseEnGazon2.compact!


      if col
        if nbTentePoss == @grille.tentesCol[i]-nbCasesTente
          if ! tabCaseEnTente.empty?
            return tabCaseEnTente.shift
          elsif ! tabCaseEnGazon1.empty?
            return tabCaseEnGazon1.shift
          end
        elsif nbTentePoss == @grille.tentesCol[i]-nbCasesTente+1
          if ! tabCaseEnGazon2.empty?
            return tabCaseEnGazon2.shift
          end
        end
      else
        if nbTentePoss == @grille.tentesLigne[i]-nbCasesTente
          if ! tabCaseEnTente.empty?
            return tabCaseEnTente.shift
          elsif ! tabCaseEnGazon1.empty?
            return tabCaseEnGazon1.shift
          end
        elsif nbTentePoss == @grille.tentesLigne[i]-nbCasesTente+1
          if ! tabCaseEnGazon2.empty?
            return tabCaseEnGazon2.shift
          end
        end
      end
    end # FinForI

    return 0
  end

  # permet de faire le cycle des aides (ne pas modifier l'ordre sous peine d'être maudit par l'auteur de ce document)
  def cycle
 
    tableau = Array.new

    if (funcReturn=self.casesIncorrect) != 0
      # return "Il y a " + funcReturn.to_s + " erreur(s)"
      tableau.push(nil, "Il y a " + funcReturn.to_s + " erreur(s)")
      return tableau
    elsif (funcReturn=self.resteQueTentesLigne) != 0
      # return "Il ne reste que des tentes à placer sur la ligne " + funcReturn.to_s
      tableau.push(nil, "Il ne reste que des tentes à placer sur la ligne " + funcReturn.to_s)
      return tableau
    elsif (funcReturn=self.resteQueTentesColonne) != 0
      # return "Il ne reste que des tentes à placer sur la colonne " + funcReturn.to_s
      tableau.push(nil, "Il ne reste que des tentes à placer sur la colonne " + funcReturn.to_s)
      return tableau
    elsif (funcReturn=self.resteQueHerbeLigne) != 0
      # return "Il ne reste que du gazon à placer sur la ligne " + funcReturn.to_s
      tableau.push(nil, "Il ne reste que du gazon à placer sur la ligne " + funcReturn.to_s)
      return tableau
    elsif (funcReturn=self.resteQueHerbeColonne) != 0
      # return "Il ne reste que du gazon à placer sur la colonne " + funcReturn.to_s
      tableau.push(nil, "Il ne reste que du gazon à placer sur la colonne " + funcReturn.to_s)
      return tableau
    elsif (funcReturn=self.casePasACoteArbre) != 0
      # return "La case " + funcReturn.class.to_s + " est forcement du gazon"
      tableau.push(funcReturn, "La case " + funcReturn.class.to_s + " est forcement du gazon")
      return tableau
    elsif (funcReturn=self.uniquePossibiliteArbre) != 0
      # return "Il n'y a qu'une seule possibilité de placer une tente pour l'arbre " + funcReturn.class.to_s
      tableau.push(funcReturn, "Il n'y a qu'une seule possibilité de placer une tente pour l'arbre " + funcReturn.class.to_s)
      return tableau
    elsif (funcReturn=self.dispositionPossibleLigne) != 0
      # return "D'après les dispositions de la ligne, il n'y a qu'une seule possibilité pour la case " + funcReturn.class.to_s
      tableau.push(funcReturn, "D'après les dispositions de la ligne, il n'y a qu'une seule possibilité pour la case " + funcReturn.class.to_s)
      return tableau
    elsif (funcReturn=self.dispositionPossibleColonne) != 0
      # return "D'après les dispositions de la colonne, il n'y a qu'une seule possibilité pour la case " + funcReturn.class.to_s
      tableau.push(funcReturn, "D'après les dispositions de la colonne, il n'y a qu'une seule possibilité pour la case " + funcReturn.class.to_s)
      return tableau
    elsif (funcReturn=self.arbreAutourCasePossedeTente) != 0
      # return "La case " + funcReturn.class.to_s + " est forcement du gazon puisque tous les arbres autours ont leurs tentes"
      tableau.push(funcReturn, "La case " + funcReturn.class.to_s + " est forcement du gazon puisque tous les arbres autours ont leurs tentes")
      return tableau
    elsif (funcReturn=self.caseArbreAssocieTente) != 0
      # return "La case " + funcReturn.class.to_s + " n'a pas encore placé sa tente"
      tableau.push(funcReturn, "La case " + funcReturn.class.to_s + " n'a pas encore placé sa tente")
      return tableau
    else
      # return "Aucune aide disponible ..."
      tableau.push(nil, "Aucune aide disponible ...")
      return tableau
    end
     
  end
end