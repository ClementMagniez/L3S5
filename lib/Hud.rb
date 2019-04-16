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
	@@fenetre = nil
	@@hudPrecedent = nil

	def initialize
		super()
		@@fenetre.signal_connect('check-resize') do |window|
			if window.size[0]!=@@winX && window.size[1]!=@@winY
				@fond.destroy if @fond !=nil
				self.ajoutFondEcran
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
		@@fenetre.changerWidget(HudAccueil.new(@@fenetre))
	end


	def lancementAventure(grille)
		@@fenetre.changerWidget(HudAventure.new(grille))
	end

	def lancementTutoriel(grille)
		@@fenetre.changerWidget(HudTutoriel.new(grille))
	end


	def lancementRapide(grille)
		@@fenetre.changerWidget(HudRapide.new(grille))
	end


	def lancementExplo(grille)
		@@fenetre.changerWidget(HudExploration.new(grille))
	end

	def lancementModeJeu
		@@fenetre.changerWidget(HudModeDeJeu.new)
	end

	def lancementChoixDifficulte(mode)
		@@mode = mode
		@@fenetre.changerWidget(HudChoixDifficulte.new(mode))
	end

	# Lance le menu de fin de jeu
	def lancementFinDeJeu(fenetrePrecedente, finTuto=false)
		@@hudPrecedent = fenetrePrecedente
		@@fenetre.changerWidget(HudFinDeJeu.new(finTuto))
	end

	def lancementInscription
		@@fenetre.changerWidget(HudInscription.new)
	end

	def lancementHudRegle(fenetrePrecedente)
		@@hudPrecedent = fenetrePrecedente
		@@fenetre.changerWidget(HudRegle.new)
	end

	def lancementHudPresentationTutoriel(grille)
		@@fenetre.changerWidget(HudPresentationTutoriel.new(grille))
	end

	def lancementProfil
		@@fenetre.changerWidget(HudProfil.new)
	end

	def lancementHudPrecedent
		if @@hudPrecedent == nil
			puts "ATTENTION : tentative de retour à hud précédent hors @fenetrePrecedente = nil"
		else
			@@fenetre.changerWidget(@@hudPrecedent)
		end
	end

	# TODO inverser style et size pour respecter CustomLabel
	# def creerBouton(label,couleur,style,size)
	# 	bouton = Gtk::Button.new
	# 	self.styleLabel(label,couleur,style,size,label.text)
	# 	bouton.add(label)
	# 	bouton.set_relief(Gtk::ReliefStyle::NONE)
	# 	return bouton
	# end


	# Initialise le bouton des options :
	# 	ajoute une variable d'instance @btnOptions ;
	# 	initialise son comportement
	# - traitement : par défaut nil, symbole d'une méthode exécutée sur @fenetrePrecedente
	# ; permet par exemple de redimensionner un menu de jeu en le rechargeant
	def initBoutonOptions(traitement=nil)
		@btnOptions = Gtk::Button.new
		@btnOptions.set_relief(Gtk::ReliefStyle::NONE)
		engrenage = Gtk::Image.new(:file => '../img/Engrenage.png')
		engrenage.pixbuf = engrenage.pixbuf.scale(@@winX/20,@@winX/20)	if engrenage.pixbuf != nil
		@btnOptions.set_image(engrenage)
		@btnOptions.signal_connect("clicked") {
			@@hudPrecedent = self
			@@fenetre.changerWidget(HudOption.new)
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

	# Initialise le bouton des règles de jeu :
	# 	ajoute une variable d'instance @btnRegle
	# 	initialise sont comportement
	def initBoutonRegle
		@btnRegle = CustomButton.new("?", "pink")
		@btnRegle.signal_connect('clicked'){
			self.lancementHudRegle(self)
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
		@@winX = @@fenetre.size.fetch(0)
		@@winY = @@fenetre.size.fetch(1)

		true
	end

	def resizeWindow(width, height)
		@@fenetre.set_resizable(true)
		@@fenetre.resize(width,height)
		@@fenetre.set_resizable(false)
	end

	# Modifie le titre de la fenetre
	def setTitre(str)
		@@fenetre.set_title(str)
	end

	def ajoutFondEcran
		@fond = Gtk::Image.new( pixbuf: updateFondEcran(@@winX, @@winY))
		self.attach(@fond,0,0,1,1)
		@fond.set_visible(true)
	end
	def updateFondEcran(width, height)
			return GdkPixbuf::Pixbuf.new( :file => "../img/fond2.png",\
																		:width=>width,:height=>height)
	end
end
