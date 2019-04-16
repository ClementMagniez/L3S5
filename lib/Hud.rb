require 'gtk3'
require_relative 'Grille'
require_relative 'CustomLabel'
require_relative 'CustomButton'
require_relative 'CustomEventBox'

# Superclasse abstraite de tous les menus de l'application : enregistre le nom du joueur
# à la connexion, instancie les éléments communs aux menus et permet le passage
# de l'un à l'autre
class Hud < Gtk::Grid
	@@name=""
	@@initblock=false
	@@difficulte = nil
	@@mode = nil

	def initialize(window)
		super()

		@fenetre = window
		@fenetre.signal_connect('check-resize') do |window|
			if window.size[0]!=@@winX && window.size[1]!=@@winY
				# puts (window.size[0].to_s + "," + window.size[1].to_s)
				# self.remove(@fond) if @fond !=nil
				ajoutFondEcran
			end
		end
		# Hacky façon de n'exécuter initWindow qu'une fois
		@@initblock=@@initblock||self.initWindow
		setTitre("Des Tentes et des Arbres")

		initBoutonOptions
	end

protected

	# TODO factoriser les lancementX
	def lancementAccueil
		@fenetre.changerWidget(self,HudAccueil.new(@fenetre))
	end


	def lancementAventure(grille)
		@fenetre.changerWidget(self,HudAventure.new(@fenetre,grille))
	end

	def lancementTutoriel(grille)
		@fenetre.changerWidget(self,HudTutoriel.new(@fenetre,grille))
	end


	def lancementRapide(grille)
		@fenetre.changerWidget(self,HudRapide.new(@fenetre,grille))
	end


	def lancementExplo(grille)
		@fenetre.changerWidget(self,HudExploration.new(@fenetre,grille))
	end

	def lancementModeJeu
		@fenetre.changerWidget(self, HudModeDeJeu.new(@fenetre))
	end

	def lancementChoixDifficulte(mode)
		@@mode = mode
		@fenetre.changerWidget(self, HudChoixDifficulte.new(@fenetre,mode))
	end

	# Lance le menu de fin de jeu
	def lancementFinDeJeu(finTuto=false)
		@fenetre.changerWidget(self, HudFinDeJeu.new(@fenetre, self, finTuto))
	end

	def lancementInscription
		@fenetre.changerWidget(self, HudInscription.new(@fenetre))
	end

	def lancementHudRegle
		@fenetre.changerWidget(self, HudRegle.new(@fenetre))
	end

	def lancementHudPresentationTutoriel(grille)
		@fenetre.changerWidget(self, HudPresentationTutoriel.new(@fenetre,grille))

	end

	def lancementProfil
		@fenetre.changerWidget(self, HudProfil.new(@fenetre))
	end

	# TODO inverser style et size pour respecter CustomLabel
	# def creerBouton(label,couleur,style,size)
	# 	bouton = Gtk::Button.new
	# 	self.styleLabel(label,couleur,style,size,label.text)
	# 	bouton.add(label)
	# 	bouton.set_relief(Gtk::ReliefStyle::NONE)
	# 	return bouton
	# end

	def ajoutFondEcran
		fond = Gtk::Image.new( pixbuf: updateFondEcran(@@winX, @@winY))
		self.attach(fond,0,0,1,1)
		fond.set_visible(true)
	end

	# Initialise le bouton des options :
	# 	ajoute une variable d'instance @btnOptions
	# 	initialise sont comportement
	def initBoutonOptions
		@btnOptions = Gtk::Button.new
		@btnOptions.set_relief(Gtk::ReliefStyle::NONE)
		engrenage = Gtk::Image.new(:file => '../img/Engrenage.png')
		engrenage.pixbuf = engrenage.pixbuf.scale(@@winX/20,@@winX/20)	if engrenage.pixbuf != nil
		@btnOptions.set_image(engrenage)
		@btnOptions.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudOption.new(@fenetre,self))
		}
	end

	# Initialise le bouton pour profil (lance le menu profil) :
	# 	ajoute une variable d'instance @btnProfil
	# 	initialise sont comportement
	def initBoutonProfil
		@btnProfil = CustomButton.new("Profil")
		@btnProfil.signal_connect("clicked") do
			lancementProfil
		end
	end

	# Initialise le bouton pour quitter (ferme la fenetre) :
	# -	ajoute une variable d'instance @btnQuitter
	# -	initialise son comportement
	# - - par défaut, interrompt l'exécution ; peut accepter un block
	def initBoutonQuitter
		@btnQuitter = Gtk::Button.new
		@btnQuitter.set_relief(Gtk::ReliefStyle::NONE)
		quitter = Gtk::Image.new(:file => '../img/quitter.png')
		quitter.pixbuf = quitter.pixbuf.scale(@@winX/20,@@winX/20)	if quitter.pixbuf != nil
		@btnQuitter.set_image(quitter)
		@btnQuitter.signal_connect('clicked') {
			if block_given?
				yield
			else
				Gtk.main_quit
			end
		}
	end

	# Initialise le bouton de retour au menu pricipal (choix des modes de jeu ) :
	# 	ajoute une variable d'instance @btnRetour
	# 	initialise sont comportement
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour")
		@btnRetour.signal_connect("clicked") {
			if block_given?
				yield
			else
				self.lancementModeJeu
			end
		}
	end

	# TODO : vraiment utile ?
	def initWindow
		@@winX = @fenetre.size.fetch(0)
		@@winY = @fenetre.size.fetch(1)

		true
	end

	def resizeWindow(width, height)
		@fenetre.set_resizable(true)
		@fenetre.resize(width,height)
		@fenetre.set_resizable(false)
	end

	# Modifie le titre de la fenetre
	def setTitre(str)
		@fenetre.set_title(str)
	end

	def updateFondEcran(width, height)
			return GdkPixbuf::Pixbuf.new( :file => "../img/fond2.png",\
																		:width=>width,:height=>height)
	end
end
