class HudOption < Hud
	# @btnPlEcran
	# @btnRetour
	# @fenetrePrecedente
	# @fullscreen

	def initialize(window,fenetrePrecedente)
		super(window)
		varX, varY = 2, 2
		@fenetrePrecedente = fenetrePrecedente
		self.setTitre("Options")
		initBoutonRetour
		initMenuResolution
		initBoutonSauvegarderResolution
		self.attach(Gtk::Label.new("Résolution (16:9)"), 4, 5, 3, 3)
		self.attach(@menuResolution, 4, 8, 3, 3)
		self.attach(@btnSauvegardeeResolution, 4, 11, 3, 3)


#		self.attach(Gtk::Label.new("Mode : "),varX, varY, 1, 1)
#		self.attach(@btnFenetre,varX+1, varY, 1, 1)
		self.attach(@btnRetour,@sizeGridWin-3,@sizeGridWin-3,3,2)
		ajoutFondEcran
		
	end

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

	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") {
				@fenetre.changerWidget(self,@fenetrePrecedente)
		}
	end
	
	
	def initMenuResolution

		@menuResolution = Gtk::ComboBoxText	.new
		@menuResolution.append_text("1920*1080")
		@menuResolution.append_text("1600*900")
		@menuResolution.append_text("1280*720")
		@menuResolution.append_text("896*504")
		@menuResolution.active=0;
		@menuResolution.set_visible(true)
		@resolution=@menuResolution.active_text

		@menuResolution.signal_connect('changed') do
				@resolution=@menuResolution.active_text			
		end
	end
	
	def initBoutonSauvegarderResolution
		@btnSauvegardeeResolution=Gtk::Button.new(label: "Appliquer")
		@btnSauvegardeeResolution.signal_connect('clicked') do
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
