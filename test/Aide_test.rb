require "test/unit"
require_relative '../lib/Grille'
require_relative '../lib/Aide'


# Classe TestAide qui teste toutes les aides du fichier Aide.rb
class TestAide < Test::Unit::TestCase


	@@sansSucces = [nil, nil, nil, nil, false, nil]
	

	# test de nbCasesIncorrect
	def test_nbCasesIncorrect
    grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		
		# On met la case en gazon alors qu'il s'agit d'une tente (1 erreur)
		grille[15][15].cycle(grille)
    assert(aide.nbCasesIncorrect != @@sansSucces, "Il n'y a pas d'erreur")
        
 		# On met la case en tente cette fois ci (0 erreur)
		grille[15][15].cycle(grille)
		assert(aide.nbCasesIncorrect == @@sansSucces, "Il y a au moins 1 erreur")
	end

  # test de listeCasesIncorrect
	def test_listeCasesIncorrect
		grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		
		# On met les cases en gazon alors qu'il s'agit de tentes (3 erreurs)
		grille[15][15].cycle(grille)
		grille[15][12].cycle(grille)
		grille[13][14].cycle(grille)
    assert(aide.listeCasesIncorrect != @@sansSucces, "Il n'y a pas d'erreur")
        
 		# On met les cases en tentes cette fois ci (0 erreur)
		grille[15][15].cycle(grille)
		grille[15][12].cycle(grille)
		grille[13][14].cycle(grille)
		assert(aide.listeCasesIncorrect == @@sansSucces, "Il y a au moins 1 erreur")
	end

  # test de impossibleTenteAdjacente
	def test_impossibleTenteAdjacente
		grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		
		# On met les cases en tentes, en laissant autour les cases vides
		grille[15][15].cycle(grille)
		grille[15][12].cycle(grille)
		grille[13][14].cycle(grille)
		grille[15][15].cycle(grille)
		grille[15][12].cycle(grille)
		grille[13][14].cycle(grille)
    assert(aide.impossibleTenteAdjacente != @@sansSucces, "Il y a du gazon tout autour des tentes déjà placées")
        
 		# On met du gazon autour des cases tentes
		grille[12][13].cycle(grille)
		grille[12][14].cycle(grille)
		grille[12][15].cycle(grille)
		grille[13][13].cycle(grille)
		grille[13][15].cycle(grille)
		grille[14][13].cycle(grille)
		grille[14][15].cycle(grille)
		grille[15][11].cycle(grille)
		assert(aide.impossibleTenteAdjacente == @@sansSucces, "Les tentes ne peuvent pas se toucher, donc la case en surbrillance est du gazon")
	end

	# test de resteQueTentesLigne
	def test_resteQueTentesLigne
		grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)

		# Il reste des cases gazons sur la ligne 16
		assert(aide.resteQueTentesLigne == @@sansSucces, "Il y a une/plusieurs ligne(s) ou il reste que des tentes a placer")

		# On ne laisse que les cases tentes disponible sur la ligne 16
		grille[15][7].cycle(grille)
		grille[15][10].cycle(grille)
		grille[15][11].cycle(grille)
		assert(aide.resteQueTentesLigne != @@sansSucces, "Il n'y a plus de ligne ou il ne reste que des tentes a placer")
	end

	# test de resteQueTentesColonne
	def test_resteQueTentesColonne
		grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)

		# Il reste des cases gazons sur la colonne 13
		assert(aide.resteQueTentesColonne == @@sansSucces, "Il y a une/plusieurs colonne(s) ou il reste que des tentes a placer")

		# On ne laisse que les cases tentes disponible sur la colonne 13
		grille[1][12].cycle(grille)
		grille[8][12].cycle(grille)
		grille[10][12].cycle(grille)
		grille[11][12].cycle(grille)
		grille[12][12].cycle(grille)
	  assert(aide.resteQueTentesColonne != @@sansSucces, "Il n'y a plus de colonne ou il ne reste que des tentes a placer")
	end

	# test de resteQueGazonLigne
	def test_resteQueGazonLigne
		# Dans cette grille, il n'y a qu'une seule ligne qui est à 0 tente
		grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)

	    assert(aide.resteQueGazonLigne != @@sansSucces, "Il n'y a plus de ligne ou il ne reste que du gazon a placer")
	    
	    # On met toutes les cases vides en gazon sur la ligne avec 0 tente
		for i in 0..15
			grille[12][i].cycle(grille) if grille[12][i].statutVisible == newStatutVide
		end

		assert(aide.resteQueGazonLigne == @@sansSucces, "Il y a une/plusieurs ligne(s) ou il reste que du gazon a placer")
	end

  # test de resteQueGazonColonne
	def test_resteQueGazonColonne
    # Dans cette grille, il n'y a qu'une seule colonne qui est à 0 tente
    grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
	
    assert(aide.resteQueGazonColonne != @@sansSucces, "Il n'y a plus de colonne ou il ne reste que du gazon a placer")
        
    # On met toutes les cases vides en gazon sur la colonne avec 0 tente
 		for i in 0..15
			grille[i][13].cycle(grille) if grille[i][13].statutVisible == newStatutVide
		end

		assert(aide.resteQueGazonColonne == @@sansSucces, "Il y a une/plusieurs colonne(s) ou il reste que du gazon a placer")
	end

  # test de casePasACoteArbre
	def test_casePasACoteArbre
  	grille=Grille.new(6, true, 1097)
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
	
		assert(aide.casePasACoteArbre != @@sansSucces, "Il n'y a plus de cases ou il reste du gazon a placer sans qu'il ne touche d'arbre")
		
		# On met toutes les cases vides en gazon
		liste = aide.listeCasesGazon
		while not liste.empty?
			caseRemp = liste.pop
			if caseRemp.statutVisible.isVide?
				caseRemp.cycle(grille)
			end
		end

		assert(aide.casePasACoteArbre == @@sansSucces, "Il y a une/plusieurs case(s) ou il reste du gazon a placer sans qu'il ne touche d'arbre")
	end

  # test de uniquePossibiliteArbre
	def test_uniquePossibiliteArbre
    # Dans la grille, il y a au début de la partie une seule case arbre qui ne contient qu'une seule possibilité de placer une tente

  	grille=Grille.new(6, true, 1097)

		aide = Aide.new(grille)
	
		assert(aide.uniquePossibiliteArbre != @@sansSucces, "Il n'y a plus aucune case arbre qui contient qu'une seule possibilité de placer une tente")
		
		# On met la seule case où il existe une unique possibilité de placer une tente en tente
		grille[15][15].cycle(grille)
		grille[15][15].cycle(grille)

		assert(aide.uniquePossibiliteArbre == @@sansSucces, "Il y a une/plusieurs case(s) arbre(s) qui contient une seule possibilité de placer une tente")
	end

  # test de dispositionPossibleLigne
	def test_dispositionPossibleLigne
  	grille=Grille.new(6, true, 1097)

		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
		
		assert(aide.dispositionPossibleLigne != @@sansSucces, "Il n'y a aucune disposition favorable afin de modifier une case")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(grille) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.dispositionPossibleLigne == @@sansSucces, "Il y a une/plusieurs disposition(s) favorable afin de modifier une case")
	end

  # test de dispositionPossibleColonne
	def test_dispositionPossibleColonne
    # Dans la grille, il y a au début de la partie plusieurs disposition favorable

  	grille=Grille.new(6, true, 1097)

		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
		
		assert(aide.dispositionPossibleColonne != @@sansSucces, "Il n'y a aucune disposition favorable afin de modifier une case")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(grille) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.dispositionPossibleColonne == @@sansSucces, "Il y a une/plusieurs disposition(s) favorable afin de modifier une case")
	end

  # test de arbreAutourCasePossedeTente
	def test_arbreAutourCasePossedeTente

  	grille=Grille.new(6, true, 1097)

		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
		
		assert(aide.arbreAutourCasePossedeTente != @@sansSucces, "Il n'y a aucune cases vides ou d'arbres autour qui possèdent leurs tentes")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(grille) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.arbreAutourCasePossedeTente == @@sansSucces, "Il y a une/plusieurs case(s) vide(s) qui n'ont aucune cases tentes à coté associé à un arbre")
	end

  # test de caseArbreAssocieTente
	def test_caseArbreAssocieTente

  	grille=Grille.new(6, true, 1097)

		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(:VIDE)
		
		assert(aide.caseArbreAssocieTente != @@sansSucces, "Il n'y a aucune cases arbres à laquelle on peut associer sa tente")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(grille) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.caseArbreAssocieTente == @@sansSucces, "Il y a une/plusieurs case(s) arbre(s) à laquelle on peut associer sa tente")
	end
    
    
end

