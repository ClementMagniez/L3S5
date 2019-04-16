class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(window,fenetrePrecedente, traitement=nil)
		super(window,fenetrePrecedente)
		varX, varY = 2, 2

		self.setTitre("Options")
		initBoutonRetour(traitement)
		initMenuResolution
		initBoutonSauvegarderResolution
		initBoutonRetour(traitement)

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(CustomLabel.new("Résolution (16:9) : "))
			hBox.add(@menuResolution)
		vBox.add(hBox)
		vBox.add(@btnSauvegardeResolution)
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
	# exécute traitement sur la fenêtre précédente
	def initBoutonRetour(traitement)
		super() do 
			@fenetre.changerWidget(self,@fenetrePrecedente)
			@fenetrePrecedente.send(traitement) if traitement!=nil
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

	# Crée un bouton enregistrant la résolution choisie dans un fichier ini 
	# et appliquant le changement à l'application active
	def initBoutonSauvegarderResolution
		@btnSauvegardeResolution=CustomButton.new("Appliquer")
		@btnSauvegardeResolution.signal_connect('clicked') do
			f=IniFile.load("../config/#{@@name}.ini", encoding: 'UTF-8')
			@@winX=@resolution.split('*')[0].to_i
			@@winY=@resolution.split('*')[1].to_i
			f['resolution']={'width' => @@winX,
											 'height'=> @@winY}
			f.write
			self.resizeWindow(@@winX,
												@@winY)
		end
	end
end
