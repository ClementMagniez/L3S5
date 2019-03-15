
# class abstraite permettant de créer un ecran de jeu
class HudJeu < Hud
	# @btnReset
	# @btnAide
	# @btnRetour
	# @lblAide
	# @gridJeu
	# @aide
	# @grille

	def initialize(window,grille)
		super(window)
		@aide = Aide.new(grille)
		@gridJeu = Gtk::Grid.new
		@grille = grille
		@lblAide = Gtk::Label.new("Bienvenue sur notre super jeu !")

		initBoutonAide
		initBoutonReset
		initBoutonRetour

			tailleGrille = @grille.length+1
		self.attach(@gridJeu,1,1,tailleGrille, tailleGrille)		# attache la grille de jeu dans la grid du HUD
		self.attach(@btnAide,tailleGrille-1,0,1,1)					# bouton aide au dessus à droite de la grille de jeu
		self.attach(@btnReset,tailleGrille,0,1,1)					# Bouton reset e droite du bouton aide en haut de la grille de jeu
		self.attach(@btnRetour,tailleGrille,tailleGrille+1,1,1)		# bouton retour en dessous à droite de la grille de jeu
		self.attach(@lblAide, 1, tailleGrille+1, tailleGrille-1, 1)	# Texte de l'aide en dessous de la grille de jeu

		chargementGrille
	end



	def chargementGrille
		taille = @grille.length
		# positionne les indices autour de la table @gridJeu
		0.upto(taille-1) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			btnIndiceCol = Gtk::Button.new(:label=>@grille.tentesCol.fetch(i).to_s)
			btnIndiceCol.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceCol,i+1,0,1,1)
			btnIndiceCol.signal_connect("clicked") {
				0.upto(taille-1) { |k|
					# puts (@grille[k][i].statutVisible.isVide?)
					# puts ("i :"+i.to_s+"j:"+k.to_s)
					if @grille[k][i].statutVisible.isVide?
						# puts ("t nul")
						@grille[k][i].cycle(k,i, @grille.tentesLigne, @grille.tentesCol)
						@gridJeu.get_child_at(i+1,k+1).set_image(scaleImage(Gtk::Image.new(:file => @grille[k][i].affichage)))
					end
				}
				# puts "Clique sur le bouton de la colonne " + i.to_s
			}
			# ici les indices des lignes (nb tentes sur chaque ligne)
			btnIndicesLig = Gtk::Button.new(:label=> @grille.tentesLigne.fetch(i).to_s)
			btnIndicesLig.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndicesLig,0,i+1,1,1)
			btnIndicesLig.signal_connect("clicked") {

				0.upto(taille-1) { |k|

					if @grille[i][k].statutVisible.isVide?
						# puts ("t nul")
						@grille[i][k].cycle(i,k, @grille.tentesLigne, @grille.tentesCol)
						@gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(Gtk::Image.new(:file => @grille[i][k].affichage)))
					end
				}

			}
		}

		# positionne les boutons qui servent de case sur la grid
		0.upto(taille-1) { |i|
			0.upto(taille-1){ |j|
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
				button.signal_connect("clicked") {
					@grille[i][j].cycle(i,j, @grille.tentesLigne, @grille.tentesCol)
					button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
					if @caseSurbrillance != nil
						@gridJeu.get_child_at(@caseSurbrillance.getJ+1,@caseSurbrillance.getI+1).set_image(Gtk::Image.new :file => @grille[@caseSurbrillance.getI][@caseSurbrillance.getJ].affichage)
						@caseSurbrillance = nil
					end

					self.jeuTermine		if @grille.estComplete?
				}
				@gridJeu.attach(button,j+1,i+1,1,1)
			}
		}
		return self
	end

	# Redimensionne l'image donnée aux dimmensions de la fenetre
	# Retourne l'image redimensionnée
	def scaleImage(image)
		winX = @fenetre.size.fetch(0)
		winY = @fenetre.size.fetch(1)
		taille = @grille.length
		imgSize = winY / (taille+4)
		# puts "taille image = " + imgSize.to_s

		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end

	# Créé et initialise le bouton d'aide
	def initBoutonAide
		taille = @grille.length
		@btnAide = Gtk::Button.new :label => " Aide "
		@btnAide.signal_connect("clicked") {
			tableau = @aide.cycle
			caseAide = tableau.at(0)
			if caseAide != nil then
				# puts ("pouetpouetpouet")
				if caseAide.class == CaseCoordonnees

					@gridJeu.get_child_at(caseAide.getJ+1,caseAide.getI+1).set_image(Gtk::Image.new :file => caseAide.getCase.affichageSubr)
					# puts(" X :" + caseAide.getI.to_s + " Y :" +caseAide.getJ.to_s )

					@caseSurbrillance =caseAide
				end

			end

			@lblAide.set_label(tableau.at(1))

		}
	end

	# Créé un attribut @btnReset qui est le bouton de remise à zéro
	# initialise le bouton
	def initBoutonReset
		taille = @grille.length
		@btnReset = Gtk::Button.new :label => "Reset"
		@btnReset.signal_connect("clicked") {
			0.upto(taille-1) { |i|
				0.upto(taille-1){ |j|
					@grille[i][j].reset
					#puts (@gridJeu.get_child_at(j,i).class.to_s + i.to_s + j.to_s)
					@gridJeu.get_child_at(j+1,i+1).set_image(scaleImage(Gtk::Image.new(:file=>@grille[i][j].affichage)))
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

	# Comportement a la fin du jeu
	def jeuTermine
		self.lancementModeJeu
	end
end
