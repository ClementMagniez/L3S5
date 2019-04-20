#Affichage des règles du jeu
class HudRegle < Hud
	#Génère les règles
	# - traitements : array de méthodes (symboles) à exécuter au clic sur @btnRetour
	# - return une nouvelle instance de HudRegle
	def initialize(traitements)
		super(Gtk::Orientation::VERTICAL)

		lblRegle = CustomLabel.new("But du jeu : Dans un camping, seuls les arbres sont dessinés.\n"+
															 "Plantez les tentes, sachant que : \n"+
															 "\nRègle n°1 : \n"+
															 "\tPour être à l'ombre, chaque tente se plante à côté d'un arbre,\n"+
															 "\tmais pas en diagonale de cet arbre. \n"+
															 "\nRègle n°2 : \n"+
															 "\tDeux tentes ne peuvent être placées côte à côte, même en diagonale. \n"+
															 "\nRègle n°3 : \n"+
															 "\tSi un arbre accueille une tente, il est \"occupé\" et aucune \n"+
															 "\tnouvelle tente ne peut s'y installer. Cependant, une tente \n"+
															 "\tdéjà associée à un arbre peut en côtoyer un autre. \n"+
															 "\nRègle n°4 : \n"+
															 "\tLe nombre de places est limité : les chiffres en haut et à\n"+
															 "\tgauche indiquent le nombre de tentes dans chaque travée.", "lblRegles")
		initBoutonRetour(traitements)

		lblRegle.hexpand = true
		lblRegle.vexpand = true
		self.add(lblRegle)
			@btnRetour.halign = Gtk::Align::CENTER
			@btnRetour.valign = Gtk::Align::CENTER
		self.add(@btnRetour)
	end

	# @see Hud#initBoutonRetour
	# - listToDo : traitements à effectuer sur @@hudPrecedent au clic, peut être nil
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
