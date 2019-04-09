# Cette classe fait a peut pres les memes choses que HudInscription
require 'inifile'

class HudProfil < Hud
	def initialize(window)
		super(window)
		self.setTitre("Profil")
		@entNom = Gtk::Entry.new
		@entMdp = Gtk::Entry.new

		initChampScore
		initBoutonSauvegarderLogin
		initBoutonRetourMenu
		initMenuResolution
		initBoutonSauvegarderResolution

		self.attach(Gtk::Label.new("Compte"), 4, 0, 2, 1)
		self.attach(@lblDescription, 4, 1, 2, 1)
		self.attach(Gtk::Label.new("Nouveau nom"), 4, 2, 1, 1)
		self.attach(@entNom, 5, 2, 1, 1)
		self.attach(Gtk::Label.new("Nouveau mot de passe"), 4, 3, 1, 1)
		self.attach(@entMdp, 5, 3, 1, 1)
		self.attach(@btnSauvegardeLogin, 4, 4, 2, 1)

#		self.attach(@champScores, 0, 4, 2, 4)
		self.attach(Gtk::Label.new("Résolution"), 4, 5, 2, 1)
		self.attach(@menuResolution, 4, 6, 2, 1)
		self.attach(@btnSauvegardeResolution, 4, 7, 2, 1)

		self.attach(@btnRetour, 1, 11, 1, 1)
		
		ajoutFondEcran
	end

	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		@champScores.set_min_content_height(100)
			boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				0.upto(10) do |i|
					boxChamp.add(Gtk::Label.new("choix " + i.to_s))
				end
			@champScores.add(boxChamp)
		@champScores.set_visible(true)
	end

	def initBoutonSauvegarderLogin
		@btnSauvegardeLogin = Gtk::Button.new(label: "Sauvegarder les modifications")
		@btnSauvegardeLogin.signal_connect("clicked") {
			strNom = @entNom.text
			strMdp = @entMdp.text
			if(strNom.empty?)
				puts "Le nom ne peut etre vide !"
				self.setDesc("Le nom ne peut etre vide !")
			elsif(strMdp.empty?)
				puts "Le mot de passe ne peut etre vide !"
				self.setDesc("Le mot de passe ne peut etre vide !")
			else
				puts "Sauvegarde dans la base !"
				self.setDesc("Sauvegarde dans la base !")
			end
		}
	end

	def initBoutonRetourMenu
		@btnRetour = Gtk::Button.new label: "Retour"
		@btnRetour.signal_connect("clicked") {
			lancementModeJeu
		}
	end
	
	#				width=@menuResolution.split(*)[0].to_i
	#			height=@menuResolution.split(*)[1].to_i

	
	def initMenuResolution

		@menuResolution = Gtk::ComboBoxText	.new
		@menuResolution.append_text("1920*1080")
		@menuResolution.append_text("1600*900")
		@menuResolution.append_text("1080*720")
		@menuResolution.append_text("800*480")
		@menuResolution.append_text("640*360")
		@menuResolution.active=0;
		@menuResolution.set_visible(true)
		@resolution=@menuResolution.active_text

		@menuResolution.signal_connect('changed') do
				@resolution=@menuResolution.active_text			
		end
	end
	
	def initBoutonSauvegarderResolution
		@btnSauvegardeResolution=Gtk::Button.new(label: "Appliquer")
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
