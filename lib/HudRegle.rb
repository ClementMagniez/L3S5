#Affichage des règles du jeu
class HudRegle < Hud
	#Génère les règles
	# - window : la fenêtre principale de l'application
	# - fenetrePrecedente : la fenêtre précédente pour pouvoir y retourner
	def initialize(traitements)
		super()

		lblRegle = CustomLabel.new(" But du jeu : Dans un camping, seuls les arbres sont dessinés.\n Plantez les tentes, sachant que : \n
			Règle n°1 : \n
			Pour être à l'ombre, chaque tente se plante à côté d'un arbre,\n mais pas en diagonale de cet arbre. \n
			Règle n°2 : \n
			Deux tentes ne peuvent être placées côte à côte, même en \ndiagonale. \n
			Règle n°3 : \n
			Si un arbre accueille une tente, il est \"occupé\" et aucune \nnouvelle tente ne peut s'y installer. Cependant, une tente \ndéjà associée à un arbre peut en côtoyer un autre. \n
			Règle n°4 : \n
			Le nombre de places est limité : les chiffres en haut et à\n gauche indiquent le nombre de tentes dans chaque travée.", "lblRegles")


		initBoutonRetour(traitements)



		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				lblRegle.hexpand = true
				lblRegle.vexpand = true

		vBox.add(lblRegle)
			@btnRetour.halign = Gtk::Align::CENTER
			@btnRetour.valign = Gtk::Align::CENTER
		vBox.add(@btnRetour)

		self.attach(vBox, 0, 0, 1, 1)
	end

	def initBoutonRetour(listToDo)
		super() do
			self.lancementHudPrecedent
			if listToDo != nil
				listToDo.each do |traitement|
					@@hudPrecedent.send(traitement)
				end
			end
		end
	end
end
