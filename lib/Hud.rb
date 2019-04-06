require_relative 'Grille'
require 'gtk3'

# Superclasse abstraite de tous les menus de l'application : enregistre le nom du joueur
# à la connexion, instancie les éléments communs aux menus et permet le passage
# de l'un à l'autre
class Hud < Gtk::Grid
	# @fenetre
	# @btnOptions
	# @lblDescription

	# Nom du joueur connecté, nécessaire à tous les menus de l'application
	@@name=""


	def initialize(window)
		super()
		@fenetre = window
		@lblDescription = Gtk::Label.new
		@winX = @fenetre.size.fetch(0)
		@winY = @fenetre.size.fetch(1)


		#nombre de cellule horizontale et verticale de la fenetre
		@sizeGridWin = 20
		
		initBoutonOptions

		self.halign = Gtk::Align::CENTER
		self.valign = Gtk::Align::CENTER
	end

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
		@fenetre.changerWidget(self, HudChoixDifficulte.new(@fenetre,mode))
	end

	# Lance le menu de fin de jeu
	def lancementFinDeJeu
		score = 0
		if(grille != nil)
			score = 10
		end
		@fenetre.changerWidget(self, HudFinDeJeu.new(@fenetre, self))
	end

	def lancementInscription
		puts " Page d'inscription "
		@fenetre.changerWidget(self, HudInscription.new(@fenetre))
	end

	def lancementProfil
		@fenetre.changerWidget(self, HudProfil.new(@fenetre))
	end

	# Créé et initialise le bouton des options
	# Le bouton affiche le menu des options
	def initBoutonOptions
		@btnOptions = Gtk::Button.new
		@btnOptions.set_relief(Gtk::ReliefStyle::NONE)
		engrenage = Gtk::Image.new(:file => '../img/Engrenage.png')
		engrenage.pixbuf = engrenage.pixbuf.scale(@winX/20,@winX/20)	if engrenage.pixbuf != nil
		@btnOptions.set_image(engrenage)
		@btnOptions.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudOption.new(@fenetre,self))
		}
	end

	
	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new 
		styleBouton(@btnRetour,Gtk::Label.new("Retour"),"white","ultrabold","x-large")
		@btnRetour.signal_connect("clicked") { self.lancementModeJeu }
	end

	# Modifie la description : le texte en haut de la page
	def setDesc(str)
		@lblDescription.set_text(str)
	end


	# Modifie le titre de la fenetre
	def setTitre(str)
		@fenetre.set_title(str)
	end


	def ajoutFondEcran
		# puts ("Resolution : " + @winX.to_s + ";" + @winY.to_s)

		fond = Gtk::Image.new( :file => "../img/fond2.png")
		fond.pixbuf = fond.pixbuf.scale(@winX,@winY)	if fond.pixbuf != nil

		self.attach(fond,0,0,@sizeGridWin,@sizeGridWin)
	end

	def initBoutonQuitter
		@btnQuitter = Gtk::Button.new
		@btnQuitter.set_relief(Gtk::ReliefStyle::NONE)
		quitter = Gtk::Image.new(:file => '../img/quitter.png')
		quitter.pixbuf = quitter.pixbuf.scale(@winX/20,@winX/20)	if quitter.pixbuf != nil
		@btnQuitter.set_image(quitter)
		@btnQuitter.signal_connect('clicked') {	Gtk.main_quit }
	end

	def styleLabel(label,couleur,style,size,contenu)
		label.set_markup("<span foreground='"+ couleur + "' weight= '"+ style + "' size='"+ size + "' >"+contenu+"</span>")
	end


	def styleBouton(bouton,label,couleur,style,size)
		self.styleLabel(label,couleur,style,size,label.text)
		bouton.add(label)
		bouton.set_relief(Gtk::ReliefStyle::NONE)
	#	bouton.signal_connect('enter'){
		#	styleLabel(label,"black",style,size,label.text)
	#	}
	end

	
	def initBoutonProfil
		@btnProfil = Gtk::Button.new
		styleBouton(@btnProfil,Gtk::Label.new("Profil"),"white","ultrabold","x-large")
		@btnProfil.signal_connect("clicked") do
			lancementProfil
		end

	end


end
