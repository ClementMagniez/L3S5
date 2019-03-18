require "test/unit"


Dir[File.join(__dir__, './lib', '*.rb')].each { |file|
	 require file if (!file.match('main*') && (!file.match('HUD*')))  }



class TestCase < Test::Unit::TestCase

	def test_casesArbre	
		cell=CaseArbre.new
		assert(cell.estValide?, "CaseArbre#estValide? échoue")
	
	end
	
	def test_reset
		cell=CaseTente.new
		assert(cell.statut.isTente?, "isTente ou construction erronée")
		assert(cell.statutVisible.isVide?, "isVide? ou construction erronée")
	
		cell.cycle(0,0,Grille.new(40, "./grilles.txt"))
		assert(cell.statutVisible.isGazon?, "CaseVide#cycle erroné (mauvais cycle)")
		assert(cell.statut.isTente?, "CaseVide#cycle erroné (change statut réel)")
	
		cell.reset # à changer un jour ou l'autre
		assert(cell.statutVisible.isVide?, "CaseVide#reset erroné")
		assert(cell.statut.isTente?, "CaseVide#reset erroné (change statut réel)")
	
	end	
	
	def test_casesVides
		cellg=CaseGazon.new
		
		cellg.cycle(0,0,Grille.new(40, "./grilles.txt"))
		assert(cellg.estValide?, "CaseVide#estValide? ne reconnaît pas pour CaseGazon")
	end

end
