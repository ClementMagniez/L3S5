# Classe Aide contenant toutes les méthodes permettant d'aider le joueur
require_relative 'AidesConstantes'
class Aide

  include AidesConstantes

 #####################################################################################################

  # initialise @grille avec la grille passé en argument
  # initialise aussi 4 nouveaux statut (Vide, Arbre, Tente, Gazon)
  def initialize(grille)
    @grille=grille
    @newStatutVide = StatutVide.new(:VIDE)
    @newStatutArbre = StatutArbre.new(:ARBRE)
    @newStatutTente = StatutVide.new(:TENTE)
    @newStatutGazon = StatutVide.new(:GAZON)
    @sansSucces = [nil, nil, nil, nil, false, nil]

  end

  # permet d'avoir la liste des 4 cases adjacentes à la case passé en argument (dessus, dessous, à gauche et à droite)
  def liste4Cases(cases)
    listeCases(cases, 4)
  end

  # permet d'avoir la liste des 8 cases autour de la case passé en argument
  def liste8Cases(cases)
    listeCases(cases, 8)
  end

  # métaméthode
  def listeCases(cases, nbCases)
    grille=@grille.grille
    listeCases = Array.new
    x = cases.x
    y = cases.y
    for i in (x-1)..(x+1)
      for j in (y-1)..(y+1)
        if nbCases == 4
          if ( (i == x && j != y) || (i != x && j == y) ) && i >= 0 && i <= grille.length-1 && j >= 0 && j <= grille.length-1
            listeCases.push(grille[i][j])
          end
        elsif nbCases == 8
          if !(i < 0 || i > grille.length-1 || j < 0 || j > grille.length-1) && (i != x || j != y)
            listeCases.push(grille[i][j])
          end
        end
      end
    end
    return listeCases
  end


  # renvoie le nombre d'erreur qu'il y a dans la grille (lorsque la case est VIDE, ce n'est pas une erreur)
  def nbCasesIncorrect
    casesIncorrect("Nombre")
  end

  # renvoie un tableau de cases contenant les erreurs qu'il y a dans la grille (lorsque la case est VIDE, ce n'est pas une erreur)
  def listeCasesIncorrect
    casesIncorrect("Liste")
  end

  # métaméthode
  def casesIncorrect(nombreOuListe)
    tabCasesErr = Array.new
    @grille.grille.each do | ligne |
      ligne.each do | cases |
        # rajoute la case si son état visible ne correspond pas à son état réel, la case ne doit pas être vide et ne doit pas être un arbre
        tabCasesErr.unshift(cases) if cases.statutVisible != cases.statut && cases.statutVisible != @newStatutVide && cases.statut != @newStatutArbre
      end
    end

    if(nombreOuListe == "Nombre")
      return [nil, "Il y a " + tabCasesErr.count.to_s + " erreur(s)", nil, nil, true, nil] if tabCasesErr.count != 0
    elsif nombreOuListe == "Liste"
      return [nil, "Les cases en surbrillance sont fausses", nil, nil, true, tabCasesErr] if !tabCasesErr.empty?
    end
    return @sansSucces
  end

  # renvoie la premiere case vide adjacente à une tente, il s'agit donc de gazon
  def impossibleTenteAdjacente
    grille=@grille.grille
    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        # Si la case est une caseVide
        if cases.statutVisible == @newStatutVide
          # On prend connaissance pour les 8 cases adjacentes
          self.liste8Cases(cases).each do |uneCase|
            return [cases, "Les tentes ne peuvent pas se toucher, donc la case en surbrillance est du gazon", nil, nil, true, nil] if uneCase.statutVisible == @newStatutTente
          end
        end # Fin if
      end
    end # Fin each
    return @sansSucces
  end

  # indique la ligne où il ne reste plus que des tentes à mettre
  def resteQueTentesLigne
    resteQueLigne(:TENTE)
  end

  # indique la ligne où il ne reste plus que du gazon à mettre
  def resteQueGazonLigne
    resteQueLigne(:GAZON)
  end

  # indique la colonne où il ne reste plus que des tentes à mettre
  def resteQueTentesColonne
    resteQueColonne(:TENTE)
  end

  # indique la colonne où il ne reste plus que du gazon à mettre
  def resteQueGazonColonne
    resteQueColonne(:GAZON)
  end

  # cf resteQue, col==false
  def resteQueLigne(gazonOuTente)
      resteQue(gazonOuTente, false)
  end

  # cf resteQue, col==true
  def resteQueColonne(gazonOuTente)
  resteQue(gazonOuTente, true)
  end

  # Metaméthode O(N²) : parcourt la grille en ligne ou en colonne selon col
  # et renvoie une valeur dépendant de gazonOuTente :
  # * TENTE - cf. resteQueTentesColonne et resteQueTentesLigne
  # * GAZON - cf. resteQueGazonColonne et resteQueGazonLigne
  def resteQue(gazonOuTente, col)
    grille=@grille.grille
    grille=grille.transpose if col

    grille.each_with_index do | ligne, i |
      nbCasesVide = 0
      nbCasesTente = 0
      ligne.each do | cases |
        nbCasesVide += 1 if cases.statutVisible == @newStatutVide
        nbCasesTente += 1 if cases.statutVisible == @newStatutTente
      end

      if col
        if gazonOuTente==:GAZON
          return [nil, "Il ne reste que du gazon à placer sur la colonne en surbrillance", true, i+1, true, nil] if nbCasesTente == @grille.tentesCol[i] && nbCasesVide != 0
        elsif gazonOuTente==:TENTE
          return [nil, "Il ne reste que des tentes à placer sur la colonne en surbrillance", true, i+1, true, nil] if nbCasesVide == @grille.tentesCol[i]-nbCasesTente && nbCasesVide != 0
        end
      else
        if gazonOuTente==:GAZON
          return [nil, "Il ne reste que du gazon à placer sur la ligne en surbrillance", false, i+1, true, nil] if nbCasesTente == @grille.tentesLigne[i] && nbCasesVide != 0
        elsif gazonOuTente==:TENTE
          return [nil, "Il ne reste que des tentes à placer sur la ligne en surbrillance", false, i+1, true, nil] if nbCasesVide == @grille.tentesLigne[i]-nbCasesTente && nbCasesVide != 0
        end
      end

    end # Fin each
    return @sansSucces
  end


  # renvoie la premiere case qui n'est pas a cote d'un arbre, il s'agit donc de gazon
  def casePasACoteArbre
    grille=@grille.grille

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        ok = true
        # Si la case est une caseVide
        if (cases.statutVisible == @newStatutVide)
          self.liste4Cases(cases).each do |uneCase|
            ok = false if uneCase.statut == @newStatutArbre
          end
          return [cases, "La case en surbrillance est forcement du gazon", nil, nil, true, nil] if ok
        end # Fin if
      end
    end # Fin each
    return @sansSucces
  end

  # renvoie la liste de cases vides adjacente à une tente, il s'agit donc de gazon
  def listeCasesGazon
    grille=@grille.grille

    listeCaseGazon = Array.new

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        ok = true
        # Si la case est une caseVide
        if cases.statutVisible == @newStatutVide
          self.liste4Cases(cases).each do |uneCase|
            ok = false if uneCase.statut == @newStatutArbre
          end
          listeCaseGazon.push(cases) if ok && !listeCaseGazon.include?(cases)
        end # Fin if
      end
    end # Fin each
    return listeCaseGazon
  end

  # renvoie la premiere case où il n'existe qu'une seule possibilité pour un arbre
  def uniquePossibiliteArbre
    grille=@grille.grille

    grille.each_with_index do | ligne, i |
      ligne.each_with_index do | cases, j |
        nbCasesVide = 0
        nbCasesTente = 0
        # Si la case est une caseArbre
        if (cases.statut == @newStatutArbre)
          # on regarde les 4 cases adjacentes,
          # et on incrémente nbCasesVide et nbCasesTente si ce sont respectivement des cases vides ou tentes
          self.liste4Cases(cases).each do |uneCase|
            nbCasesVide += 1 if uneCase.statutVisible == @newStatutVide
            nbCasesTente += 1 if uneCase.statutVisible == @newStatutTente
          end
          return [cases, "Il n'y a qu'une seule possibilité de placer une tente pour l'arbre en surbrillance", nil, nil, true, nil] if nbCasesVide == 1 && nbCasesTente == 0
        end
      end
    end
    return @sansSucces
  end

  # renvoie la premiere case où tous les arbres autour de la case possèdent leur tente, donc la case contient du gazon
  def arbreAutourCasePossedeTente
    arbreAssocieTente(:VIDE)

  end

  # renvoie la première caseArbre qui n'a pas placer sa tente et qui ne possède qu'une case seule caseVide à côté d'elle
  def caseArbreAssocieTente
    arbreAssocieTente(:ARBRE)
  end

  # Metaméthode O(??) :
  # renvoie une valeur dépendant de arbreOuVide :
  # * 'arbre' - cf. caseArbreAssocieTente
  # * 'vide' - cf. arbreAutourCasePossedeTente
  def arbreAssocieTente(arbreOuVide)

    grille=@grille.grille
    hashArbreTente = Hash.new

    # Tant que la taille de la table de hashage est différente du nombre de tentes de la grille, on boucle ...
    while hashArbreTente.size != @grille.tentesCol.sum
      # On parcourt toutes les cases de la grille
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |

          nbCasesTente = 0

          # Si la case est une caseArbre
          if cases.statut == @newStatutArbre
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_key?(cases)
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseTente et qu'elle ne soit pas déjà dans la table
              self.liste4Cases(cases).each do |uneCase|
                x = uneCase.x
                y = uneCase.y
                nbCasesTente += 1 if uneCase.statut == @newStatutTente && (! hashArbreTente.has_value?(uneCase))
                derniereCoordI = x if uneCase.statut == @newStatutTente && (! hashArbreTente.has_value?(uneCase)) && x != i
                derniereCoordJ = y if uneCase.statut == @newStatutTente && (! hashArbreTente.has_value?(uneCase)) && y != j
              end
              # On rajoute la caseArbre actuelle si seulement elle ne s'est associée qu'à une seule autre caseTente
              hashArbreTente[cases] = grille[derniereCoordI][derniereCoordJ] if nbCasesTente == 1
            end
          # Sinon si la case est une caseTente
          elsif cases.statut == @newStatutTente
            # On vérifie que la case ne soit pas déjà dans la table
            if ! hashArbreTente.has_value?(cases)
              derniereCoordI = i
              derniereCoordJ = j
              # On prend connaissance pour les 4 cases adjacentes s'il s'agit de caseArbre et qu'elle ne soit pas déjà dans la table
              self.liste4Cases(cases).each do |uneCase|
                x = uneCase.x
                y = uneCase.y
                nbCasesTente += 1 if uneCase.statut == @newStatutArbre && (! hashArbreTente.has_key?(uneCase))
                derniereCoordI = x if uneCase.statut == @newStatutArbre && (! hashArbreTente.has_key?(uneCase)) && x != i
                derniereCoordJ = y if uneCase.statut == @newStatutArbre && (! hashArbreTente.has_key?(uneCase)) && y != j
              end
              # On rajoute la caseTente actuelle si seulement elle ne s'est associée qu'à une seule autre caseArbre
              hashArbreTente[grille[derniereCoordI][derniereCoordJ]] = cases if nbCasesTente == 1
            end
          end
        end
      end
    end # Fin while

    if arbreOuVide == :ARBRE
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |
          # Si la case est une caseArbre et que sa tente associée est en caseVide
          if cases.statut == @newStatutArbre && hashArbreTente.fetch(cases).statutVisible == @newStatutVide
            isOk = 1
            pileCaseArbre = [cases]
            pileCaseArbreUnique = [cases]

            while !pileCaseArbre.empty?
              caseArbre = pileCaseArbre.pop
              x = caseArbre.x
              y = caseArbre.y
              nbCasesVide = 0

              # On prend connaissance pour les 4 cases adjacentes
              self.liste4Cases(cases).each do |uneCase|
                nbCasesVide += 1 if uneCase.statutVisible == @newStatutVide && uneCase != hashArbreTente.fetch(cases)
                if uneCase.statut == @newStatutTente && !pileCaseArbreUnique.include?(hashArbreTente.key(uneCase))
                  pileCaseArbre.push(hashArbreTente.key(uneCase))
                  pileCaseArbreUnique.push(hashArbreTente.key(uneCase))
                end
              end
              isOk = 0 if nbCasesVide != 0
            end
            return [cases, "L'arbre en surbrillance n'a pas encore placé sa tente", nil, nil, true, nil] if isOk == 1
          end
        end
      end # Fin each
    elsif arbreOuVide == :VIDE
      grille.each_with_index do | ligne, i |
        ligne.each_with_index do | cases, j |
          # Si la case est une caseVide
          if cases.statutVisible == @newStatutVide && cases.statut == @newStatutGazon
            isOk = 1
            pileCaseArbre = Array.new
            pileCaseArbreUnique = Array.new
            # On prend connaissance pour les 4 cases adjacentes
            self.liste4Cases(cases).each do |uneCase|
              pileCaseArbre.push(uneCase) if uneCase.statut == @newStatutArbre
              pileCaseArbreUnique.push(uneCase) if uneCase.statut == @newStatutArbre
            end

            while !pileCaseArbre.empty?
              caseArbre = pileCaseArbre.pop
              x = caseArbre.x
              y = caseArbre.y
              nbCasesVide = 0
              # On prend connaissance pour les 4 cases adjacentes
              self.liste4Cases(cases).each do |uneCase|
                nbCasesVide += 1 if uneCase.statutVisible == @newStatutVide && uneCase != cases
                # si uneCase == tente et que cette tente à un autre arbre a cote d'elle que celui de depart
                if uneCase.statut == @newStatutTente
                  self.liste4Cases(uneCase).each do |uneAutreCase|
                    if uneAutreCase.statut == @newStatutArbre && uneAutreCase != caseArbre && !pileCaseArbreUnique.include?(uneAutreCase)
                      pileCaseArbre.push(uneAutreCase)
                      pileCaseArbreUnique.push(uneAutreCase)
                    end
                  end
                end
              end
              isOk = 0 if nbCasesVide != 0
            end # Fin while
            return [cases, "La case en surbrillance est forcement du gazon puisque tous les arbres autours ont leurs tentes", nil, nil, true, nil] if isOk == 1
          end
        end
      end # Fin each
    end # FinElse
    return @sansSucces
  end


  # renvoie la premiere case où les dispositions possibles de la ligne obligeront la case à etre du gazon ou une tente
  def dispositionPossibleLigne
    dispositionPossible(false)
  end

  # renvoie la premiere case où les dispositions possibles de la colonne obligeront la case à etre du gazon ou une tente
  def dispositionPossibleColonne
    dispositionPossible(true)
  end

  # Metaméthode O(??) : parcourt la grille en ligne ou en colonne selon col
  def dispositionPossible(col)
    grille=@grille.grille
    grille=grille.transpose if col

    grille.each_with_index do | ligne, i |
      nbCasesTente = 0
      nbCaseVideSucc = 0
      nbTentePoss = 0
      listeCase = Array.new
      hashGroupeCase = Hash.new # => la table de hashage contient comme clé la première case vide et en valeur le nombre de case(s) vide(s) qui suive(nt) la première case (inclus)
      ligne.each_with_index do | cases, j |
        nbCasesTente += 1 if cases.statutVisible == @newStatutTente
        if cases.statutVisible == @newStatutVide
          listeCase.push(cases)
          nbCaseVideSucc += 1
          nbTentePoss += 1 if nbCaseVideSucc%2 != 0
        elsif cases.statutVisible != @newStatutVide
          for k in 1..nbCaseVideSucc
            hashGroupeCase[listeCase.shift] = nbCaseVideSucc
          end
          nbCaseVideSucc = 0
        end
      end # Fin each j
      if nbCaseVideSucc != 0
        for k in 1..nbCaseVideSucc
          hashGroupeCase[listeCase.shift] = nbCaseVideSucc
        end
      end

      # déclaration des 3 tableaux utiles
      tabCaseEnTente = Array.new
      tabCaseEnGazon1 = Array.new
      tabCaseEnGazon2 = Array.new

      nbImpair = 0
      # pour chaque groupe de case(s) vide(s)
      hashGroupeCase.each { |key, value|
        # correspond aux coordonnées de la case "clé"
        if col
          y = key.x
          x = key.y
        else
          x = key.x
          y = key.y
        end

        nbImpair = value if nbImpair == 0

        if value%2 != 0
          tabCaseEnTente.unshift(grille[x][y]) if nbImpair%2 != 0
          nbImpair -= 1
        elsif nbImpair%2 == 0
          nbImpair = 0
        end
        if value%2 != 0 && y+2 <= grille.length-1 && hashGroupeCase.has_key?(grille[x][y+2])
          if x+1 <= grille.length-1 && hashGroupeCase.fetch(grille[x][y+2])%2 != 0
            tabCaseEnGazon2.unshift(grille[x+1][y+1]) if grille[x+1][y+1].statutVisible == @newStatutVide
          end
          if x-1 >= 0 && hashGroupeCase.fetch(grille[x][y+2])%2 != 0
            tabCaseEnGazon2.unshift(grille[x-1][y+1]) if grille[x-1][y+1].statutVisible == @newStatutVide
          end
        end
        if value%2 == 0
          # on met dans la table les cases au dessus et en dessous dans la table des cases qui deviendront potentiellement du gazon
          if x+1 <= grille.length-1
            tabCaseEnGazon1.unshift(grille[x+1][y]) if grille[x+1][y].statutVisible == @newStatutVide
          end
          if x-1 >= 0
            tabCaseEnGazon1.unshift(grille[x-1][y]) if grille[x-1][y].statutVisible == @newStatutVide
          end
        end
      }#FinEach

      if col
        nombreTentes = @grille.tentesCol[i]
      else
        nombreTentes = @grille.tentesLigne[i]
      end

      if nbTentePoss == nombreTentes-nbCasesTente
        if ! tabCaseEnTente.empty?
          return [tabCaseEnTente.shift, "D'après les dispositions de la ligne en surbrillance, la case en surbrillance est une tente", false, i+1, true, nil]
        elsif ! tabCaseEnGazon1.empty?
          return [tabCaseEnGazon1.shift, "D'après les dispositions de la ligne en surbrillance, la case en surbrillance est du gazon", false, i+1, true, nil]
        end
      elsif nbTentePoss == nombreTentes-nbCasesTente+1
        if ! tabCaseEnGazon2.empty?
          return [tabCaseEnGazon2.shift, "D'après les dispositions de la ligne en surbrillance, la case en surbrillance est du gazon", false, i+1, true, nil]
        end
      end
    end # Fin each i
    return @sansSucces
  end

  # cette aide est la dernière aide du cycle des aides
  # intervient seulement si aucune aide précédente n'a eu de succès
  def aucuneAide
    return [nil, "Aucune aide disponible. Il faut jouer au hasard (demander à Jacoboni).", nil, nil, true, nil]

  end

  # permet de faire le cycle des aides (ne pas modifier l'ordre sous peine d'être maudit par l'auteur de ce document)
  def cycle(tutoOuRapide)
    # liste des aides (l'ordre est important, première -> ... -> dernière)
    listeDesAides = [:impossibleTenteAdjacente, :resteQueTentesLigne, :resteQueTentesColonne, :resteQueGazonLigne, :resteQueGazonColonne, :casePasACoteArbre, :uniquePossibiliteArbre, :dispositionPossibleLigne, :dispositionPossibleColonne, :caseArbreAssocieTente, :arbreAutourCasePossedeTente, :aucuneAide]

    # vérifie si erreur
    if tutoOuRapide == "tuto" && (foncReturn = self.listeCasesIncorrect).at(BOOL_SUCCES)
      return foncReturn
    elsif tutoOuRapide == "rapide" && (foncReturn = self.nbCasesIncorrect).at(BOOL_SUCCES)
      return foncReturn
    end

    # tant que la liste des aides n'est pas vide
    while !listeDesAides.empty?
      aide = listeDesAides.shift
      foncReturn = self.send(aide) # self.send(aide) => renvoie le retour de la fonction appelée
      if foncReturn.at(BOOL_SUCCES)
        return foncReturn
      end
    end
  end
end
