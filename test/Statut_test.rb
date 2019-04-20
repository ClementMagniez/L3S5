require "test/unit"


Dir[File.join(__dir__, '../lib/grille', '*.rb')].each { |file|
	 require file if file.match('Statut')  }



class TestStatut < Test::Unit::TestCase

	def test_arbres

		statutArbre1=StatutArbre.new(:ARBREDECOCHE)
		statutArbre2=StatutArbre.new(:ARBRE)
		statutArbre3=StatutArbre.new(:ARBRE)
		statutTemoin=StatutVide.new(:GAZON)


		assert(!statutArbre2.isArbreCoche?, "Instanciation des arbres incorrecte")
		assert(statutArbre3==statutArbre2, "Equivalence entre deux arbres égaux échouée")
		assert(statutArbre2!=statutTemoin, "Deux types de statuts différents sont"+\
																			 " reconnus égaux")

		statutArbre1.cycle
		assert(statutArbre1.isArbreCoche?, "StatutArbre#Cycle échoue")
		assert(statutArbre1==statutArbre2, "Equivalence entre deux arbres dont un coché échouée")

		statutArbre1.cycle
		assert(!statutArbre1.isArbreCoche?, "StatutArbre#Cycle incohérent ;"+\
																				"cocher->décocher échoue")
	end

	def test_vide
		statutVide1=StatutVide.new(:VIDE)
		statutVide2=StatutVide.new(:VIDE)
		assert(statutVide1==statutVide2, "Equivalence entre deux vides échouée")
		statutVide1.cycle
		assert(statutVide1.isGazon?, "Echec du cycle vide->gazon"+statutVide1.to_s)

		statutVide1.cycle
		assert(statutVide1.isTente?, "Echec du cycle gazon->tente"+statutVide1.to_s)

		statutVide1.cycle
		assert(statutVide1.isVide?, "Echec du cycle tente->vide"+statutVide1.to_s)
	end



	def test_reset
		statArbre=StatutArbre.new(:ARBRECOCHE)
		statGazon=StatutVide.new(:GAZON)

		statArbre.reset
		assert(!statArbre.isArbreCoche?, "Reset dysfonctionnel pour StatutArbre")

		statGazon.reset
		assert(statGazon.isVide?, "Reset dysfonctionnel pour StatutVide")


	end
end
