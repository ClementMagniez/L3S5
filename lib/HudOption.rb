class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(traitement=nil)
		super()

		self.setTitre("Options")
		configFile=IniFile.load("../config/#{@@name}.ini", encoding: 'UTF-8')


		initBoutonRetour(traitement)
		initChoixScore
		initBoutonSauvegarderChoixScore(configFile)
		initMenuResolution
		initBoutonSauvegarderResolution(configFile)

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(CustomLabel.new("Résolution (16:9) : "))
			hBox.add(@menuResolution)
		vBox.add(hBox)
		vBox.add(@btnSauvegardeResolution)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(CustomLabel.new("Enregistrer les scores : "))
			@group.each { |btn| hBox.add(btn) }
		vBox.add(hBox)
		vBox.add(@btnChoixScore)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran

	end

private

#	def initBoutonFenetre
#		if @fenetre.isFullscreen?
#			@btnFenetre = Gtk::Button.new :label =>"Fenêtré"
#		else
#			@btnFenetre = Gtk::Button.new :label =>"Plein écran"
#		end
#		@btnFenetre.signal_connect('clicked') {
#			if @fenetre.isFullscreen?
#				@fenetre.unfullscreen
#				@btnFenetre.set_label("Plein écran")
#			else
#				@fenetre.fullscreen
#				@btnFenetre.set_label("Fenêtré")
#			end
#		}
#	end

	# Surcharge le bouton retour pour renvoyer à la fenêtre précédente ;
	# exécute les traitements sur la fenêtre précédente
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
	# Crée un dropdown menu proposant quelques résolutions 16:9 possibles
	def initMenuResolution

		@menuResolution = Gtk::ComboBoxText	.new
		@menuResolution.append_text("1920*1080")
		@menuResolution.append_text("1600*900")
		@menuResolution.append_text("1280*720")
		@menuResolution.append_text("896*504")
		@menuResolution.active=0;
		# @menuResolution.set_visible(true)
		@resolution=@menuResolution.active_text

		@menuResolution.signal_connect('changed') do
				@resolution=@menuResolution.active_text
		end
	end

	# Crée un bouton enregistrant laésolution choisie dans un fichier ini
	# et appliquant le changement à l'application active
	def initBoutonSauvegarderResolution(configFile)
		@btnSauvegardeResolution=CustomButton.new("Appliquer") do
			configFile=IniFile.load("../config/#{@@name}.ini", encoding: 'UTF-8')
			@@winX=@resolution.split('*')[0].to_i
			@@winY=@resolution.split('*')[1].to_i
			configFile['resolution']={'width' => @@winX,
											 'height'=> @@winY}
			configFile.write
			self.resizeWindow(@@winX,
												@@winY)
		end
	end

	# Génère les deux radiobuttons "oui"/"non" permettant de choisir si on
	# enregistre les scores
	# - return self
	def initChoixScore
		rYesButton=Gtk::RadioButton.new(label: "Oui")
		@group=rYesButton.group
		rNoButton=Gtk::RadioButton.new(group: @group, label: "Non")
		@group << rNoButton # bizarrement nécessaire car @group, contrairement
												# à ce qu'affirme la doc, ne se met pas à jour
		@group.each do |btn|
			btn.signal_connect('clicked') { @bChoixScore=btn.label }
		end
		self
	end

	# Génère le bouton récupérant le choix de initChoixScore et l'écrivant dans
	# le .ini
	# - return self
	def initBoutonSauvegarderChoixScore(configFile)
		@btnChoixScore=CustomButton.new("Appliquer") do
			configFile['misc']={'score'=>@bChoixScore}
			configFile.write
		end
		self
	end

end
