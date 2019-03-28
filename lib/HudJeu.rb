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
		@align = Gtk::Align.new(1)
		@aide = Aide.new(grille)
		@gridJeu = Gtk::Grid.new
			@gridJeu.set_column_homogeneous(true)
			@gridJeu.set_row_homogeneous(true)
			@gridJeu.set_halign(@align)
			@gridJeu.set_valign(@align)
		@grille = grille
		@tailleGrille = @grille.length

		@fondGrille = Gtk::Image.new(:file => '../img/gris.png')
		if @tailleGrille < 9
			@fondGrille.pixbuf = @fondGrille.pixbuf.scale(@winX-(@winX/@tailleGrille)*3,@winY-(@winY/@tailleGrille)*1.5)
		elsif @tailleGrille < 12
			@fondGrille.pixbuf = @fondGrille.pixbuf.scale(@winX-(@winX/@tailleGrille)*4,@winY-(@winY/@tailleGrille)*2)
		else
			@fondGrille.pixbuf = @fondGrille.pixbuf.scale(@winX-(@winX/@tailleGrille)*5.5,@winY-(@winY/@tailleGrille)*2.75)
		end



		initBoutonReset
		initBoutonRetour
		initBoutonCancel
		chargementGrille



		self.attach(@gridJeu,2, 1, @varPlaceGrid,1)
		self.attach(@btnReset,@varPlaceGrid,0,1,1)
		self.attach(@btnCancel,@varPlaceGrid-1,0,1,1)
		self.attach(@btnRetour,@varPlaceGrid,3,1,1)
		self.attach(@btnOptions, 1, 3, 1, 1)
		self.attach(@fondGrille,1,1, @varPlaceGrid, 1)
	end





	def chargementGrille
		# taille = @grille.length
		# positionne les indices autour de la table @gridJeu
		0.upto(@tailleGrille-1) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			lblIndiceCol = labelIndice(i,"colonne")
			btnIndiceCol = Gtk::Button.new
			btnIndiceCol.add(lblIndiceCol)
			btnIndiceCol.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceCol,i+1,0,1,1)
			#Quand on clique dessus, met toutes les cases vides à gazon
			btnIndiceCol.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[k][i].statutVisible.isVide?
						@grille[k][i].cycle(@grille)
						@gridJeu.get_child_at(i+1,k+1).set_image(scaleImage(Gtk::Image.new(:file => @grille[k][i].affichage)))
					end
				}
			}
			# ici les indices des lignes (nb tentes sur chaque ligne)
			lblIndiceLig = labelIndice(i,"ligne")
			btnIndiceLig = Gtk::Button.new
			btnIndiceLig.add(lblIndiceLig)
			btnIndiceLig.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceLig,0,i+1,1,1)
			#Quand on clique dessus, met toutes les cases vides à gazon
			btnIndiceLig.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[i][k].statutVisible.isVide?
						@grille[i][k].cycle(@grille)
						@gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(Gtk::Image.new(:file => @grille[i][k].affichage)))
					end
				}
			}
		}

		# positionne les boutons qui servent de case sur la grid
		0.upto(@tailleGrille-1) { |i|
			0.upto(@tailleGrille-1){ |j|
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
				if not @grille[i][j].statutVisible.isVide?
					button.set_valign(@align)
					button.set_halign(@align)
				end
				button.signal_connect("clicked") {
					@grille[i][j].cycle(@grille)
					button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
					if @caseSurbrillanceList != nil
						while not @caseSurbrillanceList.empty?
								caseSubr = @caseSurbrillanceList.shift
								@gridJeu.get_child_at(caseSubr.getJ+1,caseSubr.getI+1).set_image(scaleImage(Gtk::Image.new :file => @grille[caseSubr.getI][caseSubr.getJ].affichage))
						end
					end

					self.jeuTermine		if @grille.estValide
				}
				@gridJeu.attach(button,j+1,i+1,1,1)
			}
		}
		return self
	end

	def labelIndice(i,ligneOuColonne)
		lblIndice = Gtk::Label.new
		lblIndice.use_markup = true
		if ligneOuColonne == "ligne"
			lblIndice.set_markup ("<span foreground='white' weight='ultrabold' size='x-large'> "+@grille.tentesLigne.fetch(i).to_s+"</span>")
		else
			lblIndice.set_markup ("<span foreground='white' weight='ultrabold' size='x-large'> "+@grille.tentesCol.fetch(i).to_s+"</span>")
		end

		return lblIndice
	end

	# Retourne l'image à poser sur la position x, y de la grille de jeu
	# Retourne l'image redimensionnée
	def scaleImage(image)
		winX = @fenetre.size.fetch(0)
		winY = @fenetre.size.fetch(1)
		imgSize = winY / (@tailleGrille*2)

		# image = Gtk::Image.new :file => @grille[x][y].affichage
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end


	# Créé un attribut @btnReset qui est le bouton de remise à zéro
	# initialise le bouton
	def initBoutonReset
		@btnReset = Gtk::Button.new :label => "Reset"
		@btnReset.signal_connect("clicked") {
			reset
			if @lblAide != nil
			@lblAide.set_markup ("<span foreground='white' > Alors comme ça, on recommence? :O !</span>")
			end
		}
	end

	def initBoutonCancel
		@btnCancel = Gtk::Button.new :label => "Cancel"
		@btnCancel.signal_connect('clicked'){
			cell = @grille.cancel
			if cell != nil
				@gridJeu.get_child_at(cell.y+1,cell.x+1).set_image(scaleImage(Gtk::Image.new(:file=>@grille[cell.x][cell.y].affichage)))
			end
		}

	end

	# Réinitialise la grille
	def reset
		0.upto(@tailleGrille-1) { |i|
			0.upto(@tailleGrille-1){ |j|
				@grille[i][j].reset
				@gridJeu.get_child_at(j+1,i+1).set_image(scaleImage(Gtk::Image.new(:file=>@grille[i][j].affichage)))
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
		self.lancementFinDeJeu
	end
end
