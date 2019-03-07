require_relative 'Grille'

class Hud < Gtk::Grid
	def initialize(window)
		super()
		@fenetre = window
	end

	def initBoutonOptions
		@btnOption.signal_connect("clicked") {
				@fenetre.changerWidget(self,HudOption.new(@fenetre))
		}
	end

	def initBoutonReset(taille,grille,listButton)
		@btnReset.signal_connect("clicked") {
			compteur = 0
			0.upto(taille-1) { |i|
				0.upto(taille-1){ |j|
					grille[i][j].reset
					listButton.at(compteur).set_image(Gtk::Image.new :file => grille[i][j].affichage)
					compteur = compteur +1
				}
			}

		}
	end

	def initBoutonAide(aide)
		@btnAide.signal_connect("clicked") {
			@lblAide.set_label(aide.cycle)
		}

	end

	def lancementAventure(taille)
		grille = Grille.new((taille-6)*100 + Random.rand((taille-5)*100 - (taille-6)*100),"grilles.txt");
		aide = Aide.new(grille)
		@fenetre.changerWidget(self,HudAventure.new(@fenetre,grille,taille,aide))
	end

	def chargementGrille(grille,taille)
		#liste de boutons
		listButton = Array.new()

		1.upto(taille) { |i|
			colonne = Gtk::Label.new(grille.tentesCol.fetch(i-1).to_s)
			#colonne.set_foreground("#4e4e9a9a0606")
			
			@gridJeu.attach(colonne,i,i+1,0,1)
			@gridJeu.attach(Gtk::Label.new(grille.tentesLigne.fetch(i-1).to_s),0,1,i,i+1)
		}

		# Changement des boutons quand on clique dessus
		0.upto(taille-1) { |i|
			0.upto(taille-1){ |j|
				
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				
				listButton.push(button)
			
				button.set_image(Gtk::Image.new :file => grille[i][j].affichage)
				button.signal_connect("clicked") {
					grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)
					button.set_image(Gtk::Image.new :file => grille[i][j].affichage)
				}
			
				@gridJeu.attach(button,j+1,j+2,i+1,i+2)
			}
		}
		return listButton
	end
end