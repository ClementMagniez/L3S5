
# class abstraite permettant de créer un ecran de jeu
class HudJeu < Hud
	# @btnReset
	# @btnAide
	# @btnRetour
	# @lblAide
	# @gridJeu
	# @aide
	# @grille

	def initialize(window,grille,aide)
		super(window)
		@grille = grille
		@aide = aide
		@gridJeu = Gtk::Grid.new#(@grille.length+1,@grille.length+1,true)

		initBoutonAide
		initBoutonReset
		initBoutonRetour

		self.attach(@gridJeu,2,4,1,1)
		self.attach(@btnReset,5,2,1,1)
		self.attach(@btnAide,5,2,1,1)
		self.attach(@btnRetour,16,25,2,2)

		chargementGrille
	end



	def chargementGrille
		taille = @grille.length

		# positionne les indices autour de la table @gridJeu
		1.upto(taille) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			@gridJeu.attach(Gtk::Label.new(@grille.tentesCol.fetch(i-1).to_s),i,0,1,1)
			# ici les indices des lignes (nb tentes sur chaque ligne)
			@gridJeu.attach(Gtk::Label.new(@grille.tentesLigne.fetch(i-1).to_s),0,i,1,1)
		}

		# positionne les boutons qui servent de case sur la grid
		0.upto(taille-1) { |i|
			0.upto(taille-1){ |j|
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				button.set_image(Gtk::Image.new(:file => @grille[i][j].affichage))
				button.signal_connect("clicked") {
					@grille[i][j].cycle(i,j, @grille.tentesLigne, @grille.tentesCol)
					button.set_image(Gtk::Image.new(:file => @grille[i][j].affichage))
				}
				@gridJeu.attach(button,j+1,i+1,1,1)
			}
		}
		return self
	end

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		taille = @grille.length
		@btnAide = Gtk::Button.new :label => " Aide "
		@btnAide.signal_connect("clicked") {
			@lblAide.set_label(@aide.cycle)
		}
	end

	# Créé un attribut @btnReset qui est le bouton de remise à zéro
	# initialise le bouton
	def initBoutonReset
		taille = @grille.length
		@btnReset = Gtk::Button.new :label => "Reset"
		@btnReset.signal_connect("clicked") {
			1.upto(taille) { |i|
				1.upto(taille){ |j|
					@grille[i-1][j-1].reset
					@gridJeu.get_child_at(j,i).set_image(Gtk::Image.new(:file=>@grille[i-1][j-1].affichage))
				}
			}
		}
	end

	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") {
			self.lancementModeJeu
		}
	end
end
