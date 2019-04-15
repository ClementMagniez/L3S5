
class HudRegle < Hud
	def initialize (window,fenetrePrecedente)
		super(window,fenetrePrecedente)


		lblRegle = CustomLabel.new(" But du jeu : Dans un camping, seuls les arbres sont dessinés.\n Plantez les tentes, sachant que : \n
			Règle n°1 : \n
			Pour être à l'ombre, chaque tente se plante à côté d'un arbre,\n mais pas en diagonale de cet arbre. \n
			Règle n°2 : \n
			Deux tentes ne peuvent être placées côte à côte, même en \ndiagonale. \n
			Règle n°3 : \n
			Si un arbre accueille une tente, il est \"occupé\" et aucune \nnouvelle tente ne peut s'y installer. Cependant, une tente \ndéjà associée à un arbre peut en côtoyer un autre. \n
			Règle n°4 : \n
			Le nombre de places est limité : les chiffres en haut et à\n gauche indiquent le nombre de tentes dans chaque travée.")

		 image = Gtk::Image.new( :file => "../img/gris.png")
		image.pixbuf = image.pixbuf.scale(@@winX,(@@winY/@sizeGridWin)*19	)

		initBoutonRetour

	 lblRegle.hexpand = true

			grid = Gtk::Grid.new

			grid.attach(lblRegle,0,0,1,1)
			grid.attach(image,0,0,1,1)
		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(grid)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.valign = Gtk::Align::CENTER
			hBox.halign = Gtk::Align::CENTER
			hBox.homogeneous = true
			hBox.add(@btnRetour)
		vBox.add(hBox)

	self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end
end
