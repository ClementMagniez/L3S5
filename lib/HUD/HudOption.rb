# TODO virer le menu résolution, ou voir ce qu'on peut en faire

class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(traitement=nil)
		super(Gtk::Orientation::VERTICAL)
		self.setTitre("#{@@joueur.login} - Options")
		
		initBoutonRetour(traitement)

		menu=Gtk::MenuBar.new
										 .append(initMenuResolution)
										 .append(initChoixScore)
										 .append(initChoixFullScreen)
		
		menu.pack_direction=Gtk::PackDirection::TTB
		self.add(menu)
			menu.valign = Gtk::Align::FILL
		menu.halign = Gtk::Align::FILL
			hbox=Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hbox.hexpand=true
			hbox.vexpand=true
			hbox.add(@btnRetour)
			hbox.halign=Gtk::Align::END
		self.add(hbox)
		self.hexpand = true
		self.vexpand = true
		self.valign = Gtk::Align::CENTER
		self.halign = Gtk::Align::CENTER
	end

private

	# Surcharge le bouton retour pour renvoyer à la fenêtre précédente ;
	# exécute les traitements sur la fenêtre précédente
	# - return self
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
	
	# Initialise @resolution à la taille actuelle 
	# et crée un dropdown menu proposant quelques résolutions 16:9 possibles
	# - return un MenuItem proposant ces résolutions 
	def initMenuResolution
		initMenuChoix("Résolution (16:9)",
									["1920*1080", "1600*900", "1280*720", "896*504"]) do |item|
			writeResolution(item.label)
		end
	end

	def initChoixScore	
		initMenuChoix("Enregistrer les scores ?", ["Oui", "Non"]) do |item|
			writeChoixScore(item.label=="Oui")
		end
	end


	def initChoixFullScreen
		initMenuChoix("Mode ", ["Plein écran", "Fenêtré"]) do |item|
			writeChoixFS(item.label=="Plein écran")
		end
	end
	
	def initMenuChoix(label, valeurs)
		menu=Gtk::Menu.new
		menu.name="dropdown"
		valeurs.each do |choix|
			item=Gtk::MenuItem.new(label: choix)
			item.signal_connect('activate') { yield(item) }
			menu.add(item)
		end
		mainMenu=Gtk::MenuItem.new(label: label)
		mainMenu.name="lblWhite"
		mainMenu.submenu=menu
		mainMenu	
	end
	

	def writeChoixFS(choix) 
		@@fenetre.send(choix ? :fullscreen : :unfullscreen)
		@@config.writeFullScreen(choix)
	end
	
	
	def writeChoixScore(choix)
			@@config.writeEnregistrementScore(choix)
	end

	def writeResolution(reso)
			winX, winY=reso.split('*')
			@@config.writeResolution(winX	,winY)
			@@fenetre.resize(winX.to_i,winY.to_i)
		self
	end
	
	
end
