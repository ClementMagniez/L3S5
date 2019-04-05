require "test/unit"


Dir[File.join(__dir__, '../lib', '*.rb')].each { |file|
	 require_relative file if (!file.match('main*') && (!file.match('Hud*')))  }



class TestCase < Test::Unit::TestCase

	def test_casesArbre	
		cell=CaseArbre.new(1,1)
		assert(cell.estValide?, "CaseArbre#estValide? échoue")
	
	end
	
	def test_reset
		cell=CaseTente.new(1,1)
		assert(cell.statut.isTente?, "isTente ou construction erronée")
		assert(cell.statutVisible.isVide?, "isVide? ou construction erronée")
	
		cell.cycle(Grille.new(6, true, 40))
		assert(cell.statutVisible.isGazon?, "CaseVide#cycle erroné (mauvais cycle)")
		assert(cell.statut.isTente?, "CaseVide#cycle erroné (change statut réel)")
	
		cell.reset
		assert(cell.statutVisible.isVide?, "CaseVide#reset erroné")
		assert(cell.statut.isTente?, "CaseVide#reset erroné (change statut réel)")
	
	end	
	
	def test_casesVides
		cellg=CaseGazon.new(1,1)
		
		cellg.cycle(Grille.new(6, true, 40))
		assert(cellg.estValide?, "CaseVide#estValide? ne reconnaît pas pour CaseGazon")
	end

end
