require_relative 'Hud'

# class abstraite permettant de créer un ecran de jeu
class HudJeu < Hud
	# @btnReset
	# @btnAide
	# @btnRetour
	# @lblAide
	# @aide
	# @grille

	def initialize(window,grille,aide)
		super(window)
		@grille = grille
		@aide = aide
		initBoutonAide
		initBoutonReset
		initBoutonRetour
	end

	def chargementGrille
		taille = @grille.length
		#liste de boutons
		#listButton = Array.new()

		# positionne les indices autour de la grid
		1.upto(taille) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			self.attach(Gtk::Label.new(@grille.tentesCol.fetch(i-1).to_s),i,0,1,1)
			# ici les indices des lignes (nb tentes sur chaque ligne)
			self.attach(Gtk::Label.new(@grille.tentesLigne.fetch(i-1).to_s),0,i,1,1)
		}

		# positionne les boutons qui servent de case sur la grid
		0.upto(taille-1) { |i|
			0.upto(taille-1){ |j|

				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)

				#listButton.push(button)

				button.set_image(Gtk::Image.new :file => @grille[i][j].affichage)
				button.signal_connect("clicked") {
					@grille[i][j].cycle(i,j, @grille)
					button.set_image(Gtk::Image.new :file => @grille[i][j].affichage)
				}

				self.attach(button,j+1,i+1,1,1)
			}
		}
		return self
	end

	# initialise le bouton de remise à zéro de la grille
	#
	def initBoutonReset
		taille = @grille.length
		@btnReset = Gtk::Button.new :label => " Reset "
		self.attach(@btnReset,taille+4,taille+1,1,1)
		@btnReset.signal_connect("clicked") {
			# compteur = 0
			1.upto(taille) { |i|
				1.upto(taille){ |j|
					puts "I=" + i.to_s + " j=" + j.to_s
					@grille[i-1][j-1].reset
					self.get_child_at(j,i).set_image(Gtk::Image.new(:file=>@grille[i-1][j-1].affichage))
					# listButton.at(compteur).set_image(Gtk::Image.new :file => grille[i][j].affichage)
					# compteur = compteur +1
				}
			}
			@grille.score.reset()
		}
	end

	def initBoutonAide
		taille = @grille.length
		@btnAide = Gtk::Button.new :label => " Aide "
		self.attach(@btnAide,taille+4,taille,1,1)
		@btnAide.signal_connect("clicked") {
			@grille.score.appelerAssistant()
			@lblAide.set_label(@aide.cycle)
		}
	end

	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		self.attach(@btnRetour,16,25,2,2)
		@btnRetour.signal_connect("clicked") {
			self.lancementModeJeu
		}
	end
end
