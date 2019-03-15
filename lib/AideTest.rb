require "test/unit"
require_relative 'Grille'
require_relative 'Aide'
include StatutConstantes

# Classe TestAide qui teste toutes les aides du fichier Aide.rb
class TestAide < Test::Unit::TestCase

	# test de nbCasesIncorrect
	def test_nbCasesIncorrect
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		
		# On met la case en gazon alors qu'il s'agit d'une tente (1 erreur)
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)
        assert(aide.nbCasesIncorrect != 0, "Il n'y a pas d'erreur")
        
 		# On met la case en tente cette fois ci (0 erreur)
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)
		assert(aide.nbCasesIncorrect == 0, "Il y a au moins 1 erreur")
    end

    # test de casesIncorrect
	def test_casesIncorrect
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		
		# On met la case en gazon alors qu'il s'agit d'une tente (1 erreur)
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)
        assert(aide.casesIncorrect != 0, "Il n'y a pas d'erreur")
        
 		# On met la case en tente cette fois ci (0 erreur)
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)
		assert(aide.casesIncorrect == 0, "Il y a au moins 1 erreur")
    end

    # test de resteQueTentesLigne
    def test_resteQueTentesLigne
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)

		# Il reste des cases gazons sur la ligne 16
		assert(aide.resteQueTentesLigne == 0, "Il y a une/plusieurs ligne(s) ou il reste que des tentes a placer")

		# On ne laisse que les cases tentes disponible sur la ligne 16
		grille[15][7].cycle(15,7, grille.tentesLigne, grille.tentesCol)
		grille[15][10].cycle(15,10, grille.tentesLigne, grille.tentesCol)
		grille[15][11].cycle(15,11, grille.tentesLigne, grille.tentesCol)
        assert(aide.resteQueTentesLigne != 0, "Il n'y a plus de ligne ou il ne reste que des tentes a placer")
    end

    # test de resteQueTentesColonne
    def test_resteQueTentesColonne
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)

		# Il reste des cases gazons sur la colonne 13
		assert(aide.resteQueTentesColonne == 0, "Il y a une/plusieurs colonne(s) ou il reste que des tentes a placer")

		# On ne laisse que les cases tentes disponible sur la colonne 13
		grille[1][12].cycle(1,12, grille.tentesLigne, grille.tentesCol)
		grille[8][12].cycle(8,12, grille.tentesLigne, grille.tentesCol)
		grille[10][12].cycle(10,12, grille.tentesLigne, grille.tentesCol)
		grille[11][12].cycle(11,12, grille.tentesLigne, grille.tentesCol)
		grille[12][12].cycle(12,12, grille.tentesLigne, grille.tentesCol)
        assert(aide.resteQueTentesColonne != 0, "Il n'y a plus de colonne ou il ne reste que des tentes a placer")
    end

    # test de resteQueGazonLigne
    def test_resteQueGazonLigne
    	# Dans cette grille, il n'y a qu'une seule ligne qui est à 0 tente
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)

        assert(aide.resteQueGazonLigne != 0, "Il n'y a plus de ligne ou il ne reste que du gazon a placer")
        
        # On met toutes les cases vides en gazon sur la ligne avec 0 tente
 		for i in 0..15
			grille[12][i].cycle(12,i, grille.tentesLigne, grille.tentesCol) if grille[12][i].statutVisible == newStatutVide
		end

		assert(aide.resteQueGazonLigne == 0, "Il y a une/plusieurs ligne(s) ou il reste que du gazon a placer")
    end

    # test de resteQueGazonColonne
    def test_resteQueGazonColonne
    	# Dans cette grille, il n'y a qu'une seule colonne qui est à 0 tente
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
	
        assert(aide.resteQueGazonColonne != 0, "Il n'y a plus de colonne ou il ne reste que du gazon a placer")
        
        # On met toutes les cases vides en gazon sur la colonne avec 0 tente
 		for i in 0..15
			grille[i][13].cycle(i,13, grille.tentesLigne, grille.tentesCol) if grille[i][13].statutVisible == newStatutVide
		end

		assert(aide.resteQueGazonColonne == 0, "Il y a une/plusieurs colonne(s) ou il reste que du gazon a placer")
    end

    # test de casePasACoteArbre
    def test_casePasACoteArbre
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
	
		assert(aide.casePasACoteArbre != 0, "Il n'y a plus de cases ou il reste du gazon a placer sans qu'il ne touche d'arbre")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.casePasACoteArbre == 0, "Il y a une/plusieurs case(s) ou il reste du gazon a placer sans qu'il ne touche d'arbre")
    end

    # test de uniquePossibiliteArbre
    def test_uniquePossibiliteArbre
    	# Dans la grille, il y a au début de la partie une seule case arbre qui ne contient qu'une seule possibilité de placer une tente
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
	
		assert(aide.uniquePossibiliteArbre != 0, "Il n'y a plus aucune case arbre qui contient qu'une seule possibilité de placer une tente")
		
		# On met la seule case où il existe une unique possibilité de placer une tente en tente
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)
		grille[15][15].cycle(15,15, grille.tentesLigne, grille.tentesCol)

		assert(aide.uniquePossibiliteArbre == 0, "Il y a une/plusieurs case(s) arbre(s) qui contient une seule possibilité de placer une tente")
    end

    # test de dispositionPossibleLigne
    def test_dispositionPossibleLigne
    	# Dans la grille, il y a au début de la partie plusieurs disposition favorable
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
		
		assert(aide.dispositionPossibleLigne != 0, "Il n'y a aucune disposition favorable afin de modifier une case")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.dispositionPossibleLigne == 0, "Il y a une/plusieurs disposition(s) favorable afin de modifier une case")
    end

    # test de dispositionPossibleColonne
    def test_dispositionPossibleColonne
    	# Dans la grille, il y a au début de la partie plusieurs disposition favorable
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
		
		assert(aide.dispositionPossibleColonne != 0, "Il n'y a aucune disposition favorable afin de modifier une case")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.dispositionPossibleColonne == 0, "Il y a une/plusieurs disposition(s) favorable afin de modifier une case")
    end

    # test de arbreAutourCasePossedeTente
    def test_arbreAutourCasePossedeTente
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
		
		assert(aide.arbreAutourCasePossedeTente != 0, "Il n'y a aucune cases vides ou d'arbres autour qui possèdent leurs tentes")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.arbreAutourCasePossedeTente == 0, "Il y a une/plusieurs case(s) vide(s) qui n'ont aucune cases tentes à coté associé à un arbre")
    end

    # test de caseArbreAssocieTente
    def test_caseArbreAssocieTente
    	grille=Grille.new(1097,"grilles.txt");
		aide = Aide.new(grille)
		newStatutVide = StatutVide.new(VIDE)
		
		assert(aide.caseArbreAssocieTente != 0, "Il n'y a aucune cases arbres à laquelle on peut associer sa tente")
		
		# On met toutes les cases vides en gazon
 		for i in 0..15
 			for j in 0..15
				grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol) if grille[i][j].statutVisible == newStatutVide
			end
		end

		assert(aide.caseArbreAssocieTente == 0, "Il y a une/plusieurs case(s) arbre(s) à laquelle on peut associer sa tente")
    end
    
    
end

