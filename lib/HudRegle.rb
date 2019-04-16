#Affichage des règles du jeu
class HudRegle < Hud
	#Génère les règles
	# - window : la fenêtre principale de l'application
	# - fenetrePrecedente : la fenêtre précédente pour pouvoir y retourner
	def initialize
		super()

		lblRegle = CustomLabel.new(" But du jeu : Dans un camping, seuls les arbres sont dessinés.\n Plantez les tentes, sachant que : \n
			Règle n°1 : \n
			Pour être à l'ombre, chaque tente se plante à côté d'un arbre,\n mais pas en diagonale de cet arbre. \n
			Règle n°2 : \n
			Deux tentes ne peuvent être placées côte à côte, même en \ndiagonale. \n
			Règle n°3 : \n
			Si un arbre accueille une tente, il est \"occupé\" et aucune \nnouvelle tente ne peut s'y installer. Cependant, une tente \ndéjà associée à un arbre peut en côtoyer un autre. \n
			Règle n°4 : \n
			Le nombre de places est limité : les chiffres en haut et à\n gauche indiquent le nombre de tentes dans chaque travée.","white")

		lblRegle.set_size('xx-large')  if @@winY<1100
		lblRegle.set_size('large')  if @@winY<800
		lblRegle.set_size('small')  if @@winY<600


		image = Gtk::Image.new( :file => "../img/gris.png")
		 #Scale de l'image
		image.pixbuf = image.pixbuf.scale(@@winX,(@@winY*0.8)	)  if @@winY>600
		image.pixbuf = image.pixbuf.scale(@@winX,(@@winY*0.8)	) if @@winY<600

		initBoutonRetour



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			grid = Gtk::Grid.new
				lblRegle.hexpand = true
			grid.attach(lblRegle,0,0,1,1)
				image.hexpand = true
				image.vexpand = true
			grid.attach(image,0,0,1,1)
		vBox.add(grid)
			@btnRetour.vexpand = true
			@btnRetour.halign = Gtk::Align::CENTER
			@btnRetour.valign = Gtk::Align::CENTER
		vBox.add(@btnRetour)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

	def initBoutonRetour
		super { self.lancementHudPrecedent }
	end
end
