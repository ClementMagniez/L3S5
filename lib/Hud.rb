require 'gtk3'
require_relative 'Grille'
require_relative "Connexion.rb"
require_relative 'CustomLabel'
require_relative 'CustomButton'
require_relative 'CustomEventBox'

# Superclasse abstraite de tous les menus de l'application : enregistre le nom du joueur
# à la connexion, instancie les éléments communs aux menus et permet le passage
# de l'un à l'autre
class Hud < Gtk::Box
	@@joueur = Connexion.new
	@@fenetre = nil
	@@config=nil
	@@hudPrecedent = nil

	def initialize(orientation)
		super(orientation)

		@@fenetre.signal_connect('destroy') { @@fenetre.exit(@@config) }

		# Hacky façon de n'exécuter initWindow qu'une fois

		setTitre("Des Tentes et des Arbres")
		initBoutonOptions
	end

protected

	# TODO factoriser les lancementX
	def lancementAccueil
		@@fenetre.changerWidget(HudAccueil.new(@@fenetre))
	end


	def lancementAventure(grille,timer=0)
		@@fenetre.changerWidget(HudAventure.new(grille,timer))
	end

	def lancementTutoriel(grille,timer=0)
		@@fenetre.changerWidget(HudTutoriel.new(grille,timer))
	end


	def lancementRapide(grille,timer=-1)
		@@fenetre.changerWidget(HudRapide.new(grille,timer))
	end


	def lancementExploration(grille,timer=0)
		@@fenetre.changerWidget(HudExploration.new(grille,timer))
	end

	def lancementModeJeu
		@@fenetre.changerWidget(HudModeDeJeu.new)
	end

	def lancementChoixDifficulte(mode)
		@@joueur.mode = mode
		@@fenetre.changerWidget(HudChoixDifficulte.new(mode))
	end

	# Lance le menu de fin de jeu
	def lancementFinDeJeu
		@@hudPrecedent = self
		@@fenetre.changerWidget(HudFinDeJeu.new)
	end

	def lancementInscription
		@@fenetre.changerWidget(HudInscription.new)
	end

	def lancementHudPresentationTutoriel(grille)
		@@fenetre.changerWidget(HudPresentationTutoriel.new(grille))
	end

	def lancementProfil
		@@fenetre.changerWidget(HudProfil.new)
	end

	def lancementHudPrecedent
		if @@hudPrecedent == nil
			puts "ATTENTION : tentative de retour à hud précédent hors @@hudPrecedent = nil"
		else
			@@fenetre.changerWidget(@@hudPrecedent)
		end
	end

	# Initialise le bouton des options :
	# 	ajoute une variable d'instance @btnOptions ;
	# 	initialise son comportement
	# - traitement : par défaut nil, symbole d'une méthode exécutée sur @hudPrecedent lors du clique sur le bouton retoure du hud
	# ; permet par exemple de redimensionner un menu de jeu en le rechargeant
	def initBoutonOptions(traitements=nil)
		@btnOptions = Gtk::Button.new
		@btnOptions.set_relief(Gtk::ReliefStyle::NONE)
		engrenage = Gtk::Image.new(:file => '../img/options.png')
		engrenage.pixbuf = engrenage.pixbuf.scale(36,36)	if engrenage.pixbuf != nil
		@btnOptions.set_image(engrenage)
		@btnOptions.signal_connect("clicked") {
			@@hudPrecedent = self
			@@fenetre.changerWidget(HudOption.new(traitements))
		}
	end

	# Initialise le bouton pour profil (lance le menu profil) :
	# 	ajoute une variable d'instance @btnProfil
	# 	initialise sont comportement
	def initBoutonProfil
		@btnProfil = CustomButton.new("Profil") do
			lancementProfil
		end
	end

	# Initialise le bouton pour quitter (ferme la fenetre) :
	# -	ajoute une variable d'instance @btnQuitter
	# -	initialise son comportement
	# - - par défaut, interrompt l'exécution ; peut accepter un block
	def initBoutonQuitter
		@btnQuitter = CustomButton.new("", "btnQuit") {
			if block_given?
				yield
			else
				@@fenetre.exit(@@config)
			end
		}
		quitter = Gtk::Image.new(:file => '../img/quitter.png')
		quitter.pixbuf = quitter.pixbuf.scale(36,36)	if quitter.pixbuf != nil
		@btnQuitter.set_image(quitter)
	end

	# Initialise le bouton des règles de jeu :
	# 	ajoute une variable d'instance @btnRegle
	# 	initialise sont comportement
	# - traitement : par défaut nil, symbole d'une méthode exécutée sur @hudPrecedent lors du clique sur le bouton retoure du hud
	def initBoutonRegle(traitements=nil)
		@btnRegle = CustomButton.new("Règles") {
			@@hudPrecedent = self
			@@fenetre.changerWidget(HudRegle.new(traitements))
		}
	end

	# Initialise le bouton de retour au menu pricipal (choix des modes de jeu ) :
	# 	ajoute une variable d'instance @btnRetour
	# 	initialise son comportement
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour") {
			if block_given?
				yield
			else
				self.lancementModeJeu
			end
		}
	end

	# Modifie le titre de la fenetre
	def setTitre(str)
		@@fenetre.set_title(str)
	end

end
