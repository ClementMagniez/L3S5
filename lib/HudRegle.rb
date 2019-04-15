<<<<<<< HEAD
class HudRegle < Hud
	def initialize (window,fenetrePrecedente)
		super(window,fenetrePrecedente)

		lblRegle = styleLabel(Gtk::Label.new,"white","ultrabold","x-large"," But du jeu : Dans un camping, seuls les arbres sont dessinés.\n Plantez les tentes, sachant que : \n
			Règle n°1 : \n
			Pour être à l'ombre, chaque tente se plante à côté d'un arbre,\n mais pas en diagonale de cet arbre. \n
			Règle n°2 : \n
			Deux tentes ne peuvent être placées côte à côte, même en \ndiagonale. \n
			Règle n°3 : \n
			Si un arbre accueille une tente, il est \"occupé\" et aucune \nnouvelle tente ne peut s'y installer. Cependant, une tente \ndéjà associée à un arbre peut en côtoyer un autre. \n
			Règle n°4 : \n
			Le nombre de places est limité : les chiffres en haut et à\n gauche indiquent le nombre de tentes dans chaque travée.");

		image = Gtk::Image.new( :file => "../img/gris.png")
		image.pixbuf = image.pixbuf.scale(@winX/2,(@winY/4)*3)

		initBoutonRetour

		self.attach(lblRegle,1,1,@sizeGridWin-1,@sizeGridWin-1)
		self.attach(@btnRetour,@sizeGridWin-2,@sizeGridWin-2,1,1)
		self.attach(image,1,1,@sizeGridWin-1,@sizeGridWin-1)

		ajoutFondEcran
	end
end
=======
class HudRegle < Hud
	def initialize (window)
		super(window)

		self.attach(Gtk::Label.new("Regles à definir"),0,0,1,1)
	end
end
>>>>>>> origin/Restructuration
