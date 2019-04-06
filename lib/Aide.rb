# Classe Aide contenant toutes les méthodes permettant d'aider le joueur
class Aide

  include StatutConstantes
 #####################################################################################################

  # initialise @grille avec la grille passé en argument
  def initialize(grille)
    @grille=grille
    @foncReturn = [0, 0]
  end

  # renvoie le nombre d'erreur qu'il y a dans la grille (lorsque la case est VIDE, ce n'est pas une erreur)
  def nbCasesIncorrect
    casesIncorrect("Nombre")
  end

  # renvoie un tableau de cases contenant les erreurs qu'il y a dans la grille (lorsque la case est VIDE, ce n'est pas une erreur)
  def listeCasesIncorrect
    casesIncorrect("Liste")
  end

  def casesIncorrect(nombreOuListe)
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    tabCasesErr = Array.new
    @grille.grille.each do | ligne |
      ligne.each do | cases |

        # rajoute la case si son état visible ne correspond pas à son état réel, la case ne doit pas être vide et ne doit pas être un arbre
        tabCasesErr.unshift(cases) if (cases.statutVisible != cases.statut && cases.statutVisible != newStatutVide && cases.statut != newStatutArbre)

      end
    end

    if(nombreOuListe == "Nombre")
      @foncReturn.unshift(tabCasesErr.count).delete_at(1)
      return @foncReturn
    elsif nombreOuListe == "Liste"
      if !tabCasesErr.empty?
        @foncReturn.unshift(tabCasesErr).delete_at(1)
      end
    end

    return @foncReturn
  end

  # renvoie la premiere case vide adjacente à une tente, il s'agit donc de gazon
  def impossibleTenteAdjacente
    newStatutVide = StatutVide.new(VIDE)
    newStatutTente = StatutVide.new(TENTE)
    grille=@grille.grille

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        # Si la case est une caseVide
        if cases.statutVisible == newStatutVide
          # On prend connaissance pour les 8 cases adjacentes
          for k in (i-1)..(i+1)
            for l in (j-1)..(j+1)
              if !(k < 0 || k > grille.length-1 || l < 0 || l > grille.length-1)
                @foncReturn.unshift(cases).delete_at(1) if grille[k][l].statutVisible == newStatutTente
                return @foncReturn if grille[k][l].statutVisible == newStatutTente
              end
            end
          end
        end # Fin if
      end
    end # Fin each

    return @foncReturn
  end

  # indique la ligne où il ne reste plus que des tentes à mettre, sinon renvoie 0
  def resteQueTentesLigne
    resteQueLigne(TENTE)
  end

  # indique la ligne où il ne reste plus que du gazon à mettre, sinon renvoie 0
  def resteQueGazonLigne

    resteQueLigne(GAZON)
  end

  # indique la colonne où il ne reste plus que des tentes à mettre, sinon renvoie 0
  def resteQueTentesColonne
    resteQueColonne(TENTE)
  end

  # indique la colonne où il ne reste plus que du gazon à mettre, sinon renvoie 0
  def resteQueGazonColonne
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

  # Metaméthode O(N²) : parcourt la grille en ligne ou en colonne selon col
  # et renvoie une valeur dépendant de gazonOuTente :
  # * TENTE - cf. resteQueTentesColonne et resteQueTentesLigne
  # * GAZON - cf. resteQueGazonColonne et resteQueGazonLigne
  # * autres - 0
  def resteQue(gazonOuTente, col)
    num = 0

    newStatutVide = StatutVide.new(VIDE)
    newStatutTente = StatutVide.new(TENTE)

    grille=@grille.grille
    grille=grille.transpose if col

    grille.each_with_index do | ligne, i |
      nbCasesVide = 0
      nbCasesTente = 0
      ligne.each do | cases |

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
    @foncReturn.unshift(num).delete_at(1)
    return @foncReturn
  end


  # renvoie la premiere case qui n'est pas a cote d'un arbre, il s'agit donc de gazon
  def casePasACoteArbre
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    grille=@grille.grille

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        ok = true
        if (cases.statutVisible == newStatutVide)

          if (i-1 >= 0 && grille[i-1][j].statut == newStatutArbre) || (j-1 >= 0 && grille[i][j-1].statut == newStatutArbre) || (i+1 <= grille.length-1 && grille[i+1][j].statut == newStatutArbre) || (j+1 <= grille.length-1 && grille[i][j+1].statut == newStatutArbre)
            ok = false
          end
          @foncReturn.unshift(cases).delete_at(1) if ok
          return @foncReturn if ok
        end
      end
    end
    return @foncReturn
  end

  # renvoie la liste de cases vides adjacente à une tente, il s'agit donc de gazon
  def listeCasesGazon
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    grille=@grille.grille

    listeCaseGazon = Array.new

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        # Si la case est une caseVide
        ok = true
        if cases.statutVisible == newStatutVide

          for k in (i-1)..(i+1)
            for l in (j-1)..(j+1)
              if (i-1 >= 0 && grille[i-1][j].statut == newStatutArbre) || (j-1 >= 0 && grille[i][j-1].statut == newStatutArbre) || (i+1 <= grille.length-1 && grille[i+1][j].statut == newStatutArbre) || (j+1 <= grille.length-1 && grille[i][j+1].statut == newStatutArbre)
                ok = false
              end
              listeCaseGazon.push(cases) if ok && !listeCaseGazon.include?(cases)
              
            end
          end
        end # Fin if
      end
    end # Fin each

    return listeCaseGazon
  end

  # renvoie la premiere case où il n'existe qu'une seule possibilité pour un arbre
  def uniquePossibiliteArbre
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    newStatutTente = StatutVide.new(TENTE)

    grille=@grille.grille

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        nbCasesVide = 0
        nbCasesTente = 0
        if (cases.statut == newStatutArbre)

          # on regarde les 4 cases adjacentes, en vérifiant que l'on soit dans la grille
          # puis on incrémente nbCasesVide et nbCasesTente si ce sont respectivement des cases vides ou tentes
          for k in (i-1)..(i+1)
            for l in (j-1)..(j+1)
              if ( (k == i && l != j) || (k != i && l == j) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1
                nbCasesVide += 1 if (grille[k][l].statutVisible == newStatutVide)
                nbCasesTente += 1 if (grille[k][l].statutVisible == newStatutTente)
              end
            end
          end
          @foncReturn.unshift(cases).delete_at(1) if (nbCasesVide == 1 && nbCasesTente == 0)
          return @foncReturn if (nbCasesVide == 1 && nbCasesTente == 0)

        end
      end
    end
    return @foncReturn
  end

  # renvoie la premiere case où tous les arbres autour de la case possèdent leur tente, donc la case contient du gazon
  def arbreAutourCasePossedeTente
    arbreAssocieTente(VIDE)

  end

  # renvoie la première caseArbre qui n'a pas placer sa tente et qui ne possède qu'une case seule caseVide à côté d'elle
  def caseArbreAssocieTente
    arbreAssocieTente(ARBRE)
  end

  # Metaméthode O(??) :
  # renvoie une valeur dépendant de arbreOuVide :
  # * 'arbre' - cf. caseArbreAssocieTente
  # * 'vide' - cf. arbreAutourCasePossedeTente
  # * autres - 0
  def arbreAssocieTente(arbreOuVide)
    newStatutVide = StatutVide.new(VIDE)
    newStatutArbre = StatutArbre.new(ARBRE)
    newStatutTente = StatutVide.new(TENTE)
    newStatutGazon = StatutVide.new(GAZON)

    grille=@grille.grille
    hashArbreTente = Hash.new

    # Tant que la taille de la table de hashage est différente du nombre de tentes de la grille, on boucle ...
    while hashArbreTente.size != @grille.tentesCol.sum
      # On parcourt toutes les cases de la grille
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |

          nbCasesTente = 0

          # Si la case est une caseArbre
          if cases.statut == newStatutArbre
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_key?(cases)
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseTente et qu'elle ne soit pas déjà dans la table
              for k in (i-1)..(i+1)
                for l in (j-1)..(j+1)
                  if ( (k == i && l != j) || (k != i && l == j) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1
                    nbCasesTente += 1 if grille[k][l].statut == newStatutTente && (! hashArbreTente.has_value?(grille[k][l]))
                    derniereCoordI = k if grille[k][l].statut == newStatutTente && (! hashArbreTente.has_value?(grille[k][l])) && k != i
                    derniereCoordJ = l if grille[k][l].statut == newStatutTente && (! hashArbreTente.has_value?(grille[k][l])) && l != j

                  end
                end
              end
              # On rajoute la caseArbre actuelle si seulement elle ne s'est associée qu'à une seule autre caseTente
              hashArbreTente[cases] = grille[derniereCoordI][derniereCoordJ] if nbCasesTente == 1
            end
          # Sinon si la case est une caseTente
          elsif cases.statut == newStatutTente
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_value?(cases)
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseArbre et qu'elle ne soit pas déjà dans la table
              for k in (i-1)..(i+1)
                for l in (j-1)..(j+1)
                  if ( (k == i && l != j) || (k != i && l == j) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1
                    nbCasesTente += 1 if grille[k][l].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[k][l]))
                    derniereCoordI = k if grille[k][l].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[k][l])) && k != i
                    derniereCoordJ = l if grille[k][l].statut == newStatutArbre && (! hashArbreTente.has_key?(grille[k][l])) && l != j

                  end
                end
              end
              # On rajoute la caseTente actuelle si seulement elle ne s'est associée qu'à une seule autre caseArbre
              hashArbreTente[grille[derniereCoordI][derniereCoordJ]] = cases if nbCasesTente == 1
            end
          end
        end
      end
    end # Fin while

    if arbreOuVide == ARBRE
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |

          # Si la case est une caseArbre et que sa tente associée est en caseVide
          if cases.statut == newStatutArbre && hashArbreTente.fetch(cases).statutVisible == newStatutVide
            isOk = 1
            pileCaseArbre = [cases]
            pileCaseArbreUnique = [cases]
            
            while !pileCaseArbre.empty?
              caseArbre = pileCaseArbre.pop
              x = caseArbre.x
              y = caseArbre.y
              nbCasesVide = 0

              # On prend connaissance pour les 4 cases adjacentes
              for k in (x-1)..(x+1)
                for l in (y-1)..(y+1)
                  if ( (k == x && l != y) || (k != x && l == y) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1
                    nbCasesVide += 1 if grille[k][l].statutVisible == newStatutVide && grille[k][l] != hashArbreTente.fetch(cases)
                    if grille[k][l].statut == newStatutTente && !pileCaseArbreUnique.include?(hashArbreTente.key(grille[k][l]))
                      pileCaseArbre.push(hashArbreTente.key(grille[k][l]))
                      pileCaseArbreUnique.push(hashArbreTente.key(grille[k][l]))
                    end
                  end
                end
              end
              isOk = 0 if nbCasesVide != 0
            end
            @foncReturn.unshift(cases).delete_at(1) if isOk == 1
            return @foncReturn if isOk == 1
          end
        end
      end

    elsif arbreOuVide == VIDE
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |

          # Si la case est une caseVide
          if cases.statutVisible == newStatutVide && cases.statut == newStatutGazon
            isOk = 1
            pileCaseArbre = Array.new
            pileCaseArbreUnique = Array.new
            for k in (i-1)..(i+1)
              for l in (j-1)..(j+1)
                if ( (k == i && l != j) || (k != i && l == j) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1 && grille[k][l].statut == newStatutArbre
                  pileCaseArbre.push(grille[k][l])
                  pileCaseArbreUnique.push(grille[k][l])
                end
              end
            end

            while !pileCaseArbre.empty?
              caseArbre = pileCaseArbre.pop
              x = caseArbre.x
              y = caseArbre.y
              nbCasesVide = 0

              # On prend connaissance pour les 4 cases adjacentes
              for k in (x-1)..(x+1)
                for l in (y-1)..(y+1)
                  if ( (k == x && l != y) || (k != x && l == y) ) && k >= 0 && k <= grille.length-1 && l >= 0 && l <= grille.length-1
                    nbCasesVide += 1 if grille[k][l].statutVisible == newStatutVide && grille[k][l] != cases
                    # si case k/l == tente et que cette tente à un autre arbre a cote d'elle que celui de depart
                    if grille[k][l].statut == newStatutTente
                      for m in (k-1)..(k+1)
                        for n in (l-1)..(l+1)
                          if ( (m == k && n != l) || (m != k && n == l) ) && m >= 0 && m <= grille.length-1 && n >= 0 && n <= grille.length-1 && grille[m][n].statut == newStatutArbre && grille[m][n] != caseArbre && !pileCaseArbreUnique.include?(grille[m][n])
                            pileCaseArbre.push(grille[m][n])
                            pileCaseArbreUnique.push(grille[m][n])
                          end
                        end
                      end
                    end
                  end
                end
              end
              isOk = 0 if nbCasesVide != 0
            end
            @foncReturn.unshift(cases).delete_at(1) if isOk == 1
            return @foncReturn if isOk == 1
          end
        end
      end # FinForI

    end # FinElse
    return @foncReturn
  end


  # renvoie la premiere case où les dispositions possibles de la ligne obligeront la case à etre du gazon
  def dispositionPossibleLigne
    dispositionPossible(false)
  end

  # renvoie la premiere case où les dispositions possibles de la colonne obligeront la case à etre du gazon
  def dispositionPossibleColonne
    dispositionPossible(true)
  end

  # Metaméthode O(??) : parcourt la grille en ligne ou en colonne selon col
  def dispositionPossible(col)
    newStatutVide = StatutVide.new(VIDE)
    newStatutTente = StatutVide.new(TENTE)
    grille=@grille.grille
    grille=grille.transpose if col

    for i in 0..grille.length-1
      nbCasesTente = 0
      nbCaseVideSucc = 0
      nbTentePoss = 0
      listeCase = Array.new
      hashGroupeCase = Hash.new # => la table de hashage contient comme clé la première case vide et en valeur le nombre de case(s) vide(s) qui suive(nt) la première case (inclus)
      for j in 0..grille.length-1
          nbCasesTente += 1 if grille[i][j].statutVisible == newStatutTente
          if grille[i][j].statutVisible == newStatutVide
            listeCase.push(grille[i][j])
            nbCaseVideSucc += 1
            nbTentePoss += 1 if nbCaseVideSucc%2 != 0
          elsif grille[i][j].statutVisible != newStatutVide
            for k in 1..nbCaseVideSucc
              hashGroupeCase[listeCase.shift] = nbCaseVideSucc
            end
            nbCaseVideSucc = 0
          end
      end
      if nbCaseVideSucc != 0
        for k in 1..nbCaseVideSucc
          hashGroupeCase[listeCase.shift] = nbCaseVideSucc
        end
      end

      tabCaseEnTente = Array.new
      tabCaseEnGazon1 = Array.new
      tabCaseEnGazon2 = Array.new

      nbImpair = 0
      # pour chaque groupe de case(s) vide(s)
      hashGroupeCase.each {|key, value|
        # correspond aux coordonnées de la case "clé"
        x = key.x
        y = key.y

        nbImpair = value if nbImpair == 0

        if value%2 != 0
          if col
            tabCaseEnTente.unshift(grille[y][x]) if nbImpair%2 != 0
          else
            tabCaseEnTente.unshift(grille[x][y]) if nbImpair%2 != 0
          end
          nbImpair -= 1
        elsif nbImpair%2 == 0
          nbImpair = 0
        end
        if col
          if value%2 != 0 && x+2 <= grille.length-1 && hashGroupeCase.has_key?(grille[y][x+2])
            if y+1 <= grille.length-1 && hashGroupeCase.fetch(grille[y][x+2])%2 != 0
              tabCaseEnGazon2.unshift(grille[y+1][x+1]) if grille[y+1][x+1].statutVisible == newStatutVide
            end
            if y-1 >= 0 && hashGroupeCase.fetch(grille[y][x+2])%2 != 0
              tabCaseEnGazon2.unshift(grille[y-1][x+1]) if grille[y-1][x+1].statutVisible == newStatutVide
            end
          end
        else
          if value%2 != 0 && y+2 <= grille.length-1 && hashGroupeCase.has_key?(grille[x][y+2])
            if x+1 <= grille.length-1 && hashGroupeCase.fetch(grille[x][y+2])%2 != 0
              tabCaseEnGazon2.unshift(grille[x+1][y+1]) if grille[x+1][y+1].statutVisible == newStatutVide
            end
            if x-1 >= 0 && hashGroupeCase.fetch(grille[x][y+2])%2 != 0
              tabCaseEnGazon2.unshift(grille[x-1][y+1]) if grille[x-1][y+1].statutVisible == newStatutVide
            end
          end
        end
        if value%2 == 0
          # on met dans la table les cases au dessus et en dessous dans la table des cases qui deviendront potentiellement du gazon
          if col
            if y+1 <= grille.length-1
              tabCaseEnGazon1.unshift(grille[y+1][x]) if grille[y+1][x].statutVisible == newStatutVide
            end
            if y-1 >= 0
              tabCaseEnGazon1.unshift(grille[y-1][x]) if grille[y-1][x].statutVisible == newStatutVide
            end
          else
            if x+1 <= grille.length-1
              tabCaseEnGazon1.unshift(grille[x+1][y]) if grille[x+1][y].statutVisible == newStatutVide
            end
            if x-1 >= 0
              tabCaseEnGazon1.unshift(grille[x-1][y]) if grille[x-1][y].statutVisible == newStatutVide
            end
          end
        end
      }#FinEach

      if col
        if nbTentePoss == @grille.tentesCol[i]-nbCasesTente
          if ! tabCaseEnTente.empty?
            @foncReturn.replace([tabCaseEnTente.shift, i])
          elsif ! tabCaseEnGazon1.empty?
            @foncReturn.replace([tabCaseEnGazon1.shift, i])
          end
        elsif nbTentePoss == @grille.tentesCol[i]-nbCasesTente+1
          if ! tabCaseEnGazon2.empty?
            @foncReturn.replace([tabCaseEnGazon2.shift, i])
          end
        end
      else
        if nbTentePoss == @grille.tentesLigne[i]-nbCasesTente
          if ! tabCaseEnTente.empty?
            @foncReturn.replace([tabCaseEnTente.shift, i])
          elsif ! tabCaseEnGazon1.empty?
            @foncReturn.replace([tabCaseEnGazon1.shift, i])
          end
        elsif nbTentePoss == @grille.tentesLigne[i]-nbCasesTente+1
          if ! tabCaseEnGazon2.empty?
            @foncReturn.replace([tabCaseEnGazon2.shift, i])
          end
        end
      end
    end # FinForI

    return @foncReturn
  end

  def aucuneAide
    return @foncReturn.replace([1, 0])
  end

  # permet de faire le cycle des aides (ne pas modifier l'ordre sous peine d'être maudit par l'auteur de ce document)
  def cycle(tutoOuRapide)

    # :nomMethode => [Case, "Message adapté", boolean (Ligne == false / Colonne == true), indice ligne/colonne]
    listeDesAides = { :nbCasesIncorrect => [nil, "Il y a " + self.nbCasesIncorrect.at(0).to_s + " erreur(s)", nil, nil], 
        :listeCasesIncorrect => [self.listeCasesIncorrect.at(0), "Les cases en surbrillance sont fausses", nil, nil], 
         :impossibleTenteAdjacente => [self.impossibleTenteAdjacente.at(0), "Les tentes ne peuvent pas se toucher,\n donc la case en surbrillance est du gazon", nil, nil], 
        :resteQueTentesLigne => [nil, "Il ne reste que des tentes à placer sur la ligne en surbrillance", false, self.resteQueTentesLigne.at(0)], 
        :resteQueTentesColonne => [nil, "Il ne reste que des tentes à placer sur la colonne en surbrillance", true, self.resteQueTentesColonne.at(0)], 
        :resteQueGazonLigne => [nil, "Il ne reste que du gazon à placer sur la ligne en surbrillance", false, self.resteQueGazonLigne.at(0)], 
        :resteQueGazonColonne => [nil, "Il ne reste que du gazon à placer sur la colonne en surbrillance", true, self.resteQueGazonColonne.at(0)], 
        :casePasACoteArbre => [self.casePasACoteArbre.at(0), "La case en surbrillance est forcement du gazon", nil, nil], 
        :uniquePossibiliteArbre => [self.uniquePossibiliteArbre.at(0), "Il n'y a qu'une seule possibilité de placer une tente\n pour l'arbre en surbrillance", nil, nil], 
        :dispositionPossibleLigne => [self.dispositionPossibleLigne.at(0), "D'après les dispositions de la ligne en surbrillance,\n il n'y a qu'une seule possibilité pour la case en surbrillance", false, self.dispositionPossibleLigne.at(1)+1], 
        :dispositionPossibleColonne => [self.dispositionPossibleColonne.at(0), "D'après les dispositions de la colonne en surbrillance,\n il n'y a qu'une seule possibilité pour la case en surbrillance", true, self.dispositionPossibleColonne.at(1)+1], 
        :caseArbreAssocieTente => [self.caseArbreAssocieTente.at(0), "L'arbre en surbrillance n'a pas encore placé sa tente", nil, nil], 
        :arbreAutourCasePossedeTente => [self.arbreAutourCasePossedeTente.at(0), "La case en surbrillance est forcement du gazon\n puisque tous les arbres autours ont leurs tentes", nil, nil], 
        :aucuneAide => [nil, "Aucune aide disponible.\n Il faut jouer au hasard (demander à Jacoboni).", nil, nil] }

    listeDesAides.each { | key, value |
    
      if (self.send(key).at(0)) != 0
        if key.to_s == "nbCasesIncorrect" && tutoOuRapide == "rapide"
          return value
        elsif key.to_s == "listeCasesIncorrect" && tutoOuRapide == "tuto"
          return value
        elsif key.to_s != "nbCasesIncorrect" && key.to_s != "listeCasesIncorrect"
          return value
        end
      end
    }
  end
end
