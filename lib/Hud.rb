require_relative 'Grille'
require 'gtk3'
class Hud < Gtk::Grid
	# @fenetre
	# @btnOptions
	# @lblDescription

	def initialize(window)
		super()
		@fenetre = window
		@lblDescription = Gtk::Label.new
		@winX = @fenetre.size.fetch(0)
		@winY = @fenetre.size.fetch(1)
		@varPlaceGrid = 6


		initBoutonOptions


		self.halign = Gtk::Align::CENTER
		self.valign = Gtk::Align::CENTER
	end



	def lancementAventure(taille)
		# taille %= 16
		# # grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"../grilles.txt");
		# grille = Grille.new(Random.rand(Range.new((taille-6)*100+1,(taille-5)*100)),"../grilles.txt")
		# # aide = Aide.new(grille)
		# @fenetre.changerWidget(self,HudAventure.new(@fenetre,grille))
		@fenetre.changerWidget(self,HudAventure.new(@fenetre,Grille.new(taille)))
	end

	def lancementAccueil
		puts "Retour à l'accueil"
		@fenetre.changerWidget(self,HudAccueil.new(@fenetre))
	end


	def lancementTutoriel(taille)
		# grille = Grille.new(Random.rand(Range.new((taille-6)*100+1,(taille-5)*100)),"../grilles.txt")
		# puts "Retour à l'accueil"
		# @fenetre.changerWidget(self,HudTutoriel.new(@fenetre,grille))
		puts "Retour à l'accueil"
		@fenetre.changerWidget(self,HudTutoriel.new(@fenetre,Grille.new(taille)))
	end


	def lancementModeJeu
		puts "Retour au menu"
		@fenetre.changerWidget(self, HudModeDeJeu.new(@fenetre))
	end

	def lancementFinDeJeu
		puts "Fin de jeu"
		@fenetre.changerWidget(self, HudFinDeJeu.new(@fenetre, self))
	end

	def lancementInscription
		puts " Page d'inscription "
		@fenetre.changerWidget(self, HudInscription.new(@fenetre))
	end

	def lancementProfil
		@fenetre.changerWidget(self, HudProfil.new(@fenetre))
	end

	def lancementRapide(taille)
		# grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"../grilles.txt");
		# # aide = Aide.new(grille)
		# @fenetre.changerWidget(self,HudRapide.new(@fenetre,grille))
		@fenetre.changerWidget(self,HudRapide.new(@fenetre,Grille.new(taille)))
	end

	def lancementExplo(taille)
		@fenetre.changerWidget(self,HudExploration.new(@fenetre,Grille.new(taille)))
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

		return fond
	end

	def initBoutonQuitter
		@btnQuitter = Gtk::Button.new 
		@btnQuitter.set_relief(Gtk::ReliefStyle::NONE)
		quitter = Gtk::Image.new(:file => '../img/quitter.png')
		quitter.pixbuf = quitter.pixbuf.scale(@winX/20,@winX/20)	if quitter.pixbuf != nil
		@btnQuitter.set_image(quitter)
		@btnQuitter.signal_connect('clicked') {	Gtk.main_quit }
	end


end
