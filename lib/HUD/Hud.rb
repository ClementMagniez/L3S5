require 'gtk3'
require_relative '../grille/Grille'
require_relative "../DB/Connexion.rb"
require_relative '../util/CustomLabel'
require_relative '../util/CustomButton'

# Superclasse abstraite de tous les menus de l'application : instancie les éléments 
# communs aux menus et permet le passage de l'un à l'autre
class Hud < Gtk::Box
	@@joueur = Connexion.new
	@@fenetre = nil
	@@config=nil
	@@hudPrecedent = nil

	# - orientation : Gtk::Orientation::VERTICAL / HORIZONTAL, cf doc sur Gtk::Box
	# - return une nouvelle instance de Hud
	def initialize(orientation)
		super(orientation)

		@@fenetre.signal_connect('destroy') { @@fenetre.exit(@@config) }

		# Hacky façon de n'exécuter initWindow qu'une fois

		setTitre("Des Tentes et des Arbres")
		initBoutonOptions
	end

protected

	# Affiche une instance de HudAccueil
	# - return self
	def lancementAccueil
		@@fenetre.changerWidget(HudAccueil.new(@@fenetre))
		self
	end

	# Affiche une instance de HudAventure
	# - grille : une Grille de jeu
	# - timer : par défaut 0, temps de départ de la partie
	# - return self
	def lancementAventure(grille,timer=0)
		@@fenetre.changerWidget(HudAventure.new(grille,timer))
		self
	end

	# Affiche une instance de HudTutoriel
	# - grille : une Grille de jeu
	# - timer : par défaut 0, temps de départ de la partie
	# - return self
	def lancementTutoriel(grille,timer=0)
		@@fenetre.changerWidget(HudTutoriel.new(grille,timer))
		self
	end


	# Affiche une instance de HudRapide
	# - grille : une Grille de jeu
	# - timer : par défaut -1, temps de départ de la partie ; si <0, la partie
	# n'est pas comptabilisée dans les scores finaux
	# - return self
	def lancementRapide(grille,timer=-1)
		@@fenetre.changerWidget(HudRapide.new(grille,timer))
		self
	end


	# Affiche une instance de HudExploration
	# - grille : une Grille de jeu
	# - timer : par défaut 0, temps de départ de la partie
	# - return self
	def lancementExploration(grille,timer=0)
		@@fenetre.changerWidget(HudExploration.new(grille,timer))
		self
	end

	# Affiche une instance de HudModeDeJeu
	# - return self
	def lancementModeJeu
		@@fenetre.changerWidget(HudModeDeJeu.new)
		self
	end

	# Affiche une instance de HudChoixDifficulte
	# - mode : mode de jeu choisi (aventure, exploration ou chrono)
	# - return self
	def lancementChoixDifficulte(mode)
		@@joueur.mode = mode
		@@fenetre.changerWidget(HudChoixDifficulte.new(mode))
		self
	end

	# Affiche une instance de HudFinDeJeu
	# - mode : mode de jeu choisi (aventure, exploration ou chrono)
	# - return self
	def lancementFinDeJeu
		@@hudPrecedent = self
		@@fenetre.changerWidget(HudFinDeJeu.new)
		self
	end

	# Affiche une instance de HudInscription
	# - mode : mode de jeu choisi (aventure, exploration ou chrono)
	# - return self
	def lancementInscription
		@@fenetre.changerWidget(HudInscription.new)
		self
	end

	# Affiche une instance de HudPresentationTutoriel
	# - grille : une Grille de jeu
	# - return self
	def lancementHudPresentationTutoriel(grille)
		@@fenetre.changerWidget(HudPresentationTutoriel.new(grille))
		self
	end

	# Affiche une instance de HudProfil
	# - return self
	def lancementProfil
		@@fenetre.changerWidget(HudProfil.new)
		self
	end

	# Affiche le menu précédent l'actuel, s'il existe, tel qu'enregistré dans @@hudPrecedent
	# - return self
	def lancementHudPrecedent
		unless @@hudPrecedent==nil
			@@joueur.score = 0
			@@fenetre.changerWidget(@@hudPrecedent)
		end
		self
	end

	# Initialise @btnOption, affichant une instance de HudOption au clic
	# - traitement : par défaut nil, symbole d'une méthode exécutée sur @hudPrecedent lors du clique sur le bouton retoure du hud
	# ; permet par exemple de redimensionner un menu de jeu en le rechargeant
	# - return self
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
		self
	end

	# Initialise @btnProfil, affichant une instance de HudProfil au clic
	# - return self
	def initBoutonProfil
		@btnProfil = CustomButton.new("Profil") do
			lancementProfil
		end
		self
	end

	# Initialise @btnQuitter, bouton fermant l'application par défaut 
	# - par défaut, interrompt l'exécution ; peut accepter un block
	# - return self
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
		self
	end

	# Initialise @btnRegle, affichant une instance de HudRegle au clic
	# - traitement : par défaut nil, symbole d'une méthode exécutée sur @hudPrecedent lors du clique sur le bouton retoure du hud
	# - return self
	def initBoutonRegle(traitements=nil)
		@btnRegle = CustomButton.new("Règles") {
			@@hudPrecedent = self
			@@fenetre.changerWidget(HudRegle.new(traitements))
		}
		self
	end

	# Initialise @btnRetour, affichant par défaut une instance de HudModeDeJeu
	# - peut accepter un bloc sans paramètre, remplaçant le comportement par défaut 
	# - return self
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour") {
			if block_given?
				yield
			else
				self.lancementModeJeu
			end
		}
		self
	end

	# Modifie le titre de la fenetre
	# - return self
	def setTitre(str)
		@@fenetre.set_title(str)
		self
	end

end
