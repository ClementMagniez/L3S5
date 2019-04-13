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

		self.attach(Gtk::Label.new("Compte"), 4, 0, 2, 1)
		self.attach(@lblDescription, 4, 1, 2, 1)
		self.attach(Gtk::Label.new("Nouveau nom"), 4, 2, 1, 1)
		self.attach(@entNom, 5, 2, 1, 1)
		self.attach(Gtk::Label.new("Nouveau mot de passe"), 4, 3, 1, 1)
		self.attach(@entMdp, 5, 3, 1, 1)
		self.attach(@btnSauvegardeLogin, 4, 4, 2, 1)

#		self.attach(@champScores, 0, 4, 2, 4)

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

	
	
end
