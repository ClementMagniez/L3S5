#Affichage des règles du jeu
class HudRegle < Hud
	#Génère les règles
	# - window : la fenêtre principale de l'application
	# - fenetrePrecedente : la fenêtre précédente pour pouvoir y retourner
	def initialize(traitements)
		super(Gtk::Orientation::VERTICAL)

		lblRegle = CustomLabel.new("But du jeu : Dans un camping, seuls les arbres sont dessinés.\n"\
															+"Plantez les tentes, sachant que : \n"\
															+"\nRègle n°1 : \n"\
															+"\tPour être à l'ombre, chaque tente se plante à côté d'un arbre,\n"\
															+"\tmais pas en diagonale de cet arbre. \n"\
															+"\nRègle n°2 : \n"\
															+"\tDeux tentes ne peuvent être placées côte à côte, même en diagonale. \n"\
															+"\nRègle n°3 : \n"\
															+"\tSi un arbre accueille une tente, il est \"occupé\" et aucune \n"\
															+"nouvelle tente ne peut s'y installer. Cependant, une tente \n"\
															+"déjà associée à un arbre peut en côtoyer un autre. \n"\
															+"\nRègle n°4 : \n"\
															+"\tLe nombre de places est limité : les chiffres en haut et à\n"\
															+" gauche indiquent le nombre de tentes dans chaque travée.", "lblRegles")


		initBoutonRetour(traitements)



				lblRegle.hexpand = true
				lblRegle.vexpand = true
		self.add(lblRegle)
			@btnRetour.halign = Gtk::Align::CENTER
			@btnRetour.valign = Gtk::Align::CENTER
		self.add(@btnRetour)
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
