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
			@gridJeu.set_column_homogeneous(true)
			@gridJeu.set_row_homogeneous(true)
		@grille = grille
		@tailleGrille = @grille.length


		initBoutonReset
		initBoutonRetour


		self.attach(@gridJeu,1,1,@tailleGrille+1, @tailleGrille+1)

		self.attach(@btnReset,@tailleGrille+1,0,1,1)

		self.attach(@btnRetour,@tailleGrille+1,@tailleGrille+3,1,1)
		self.attach(@btnOptions, 1, @tailleGrille+3, 1, 1)
		# self.attach(@lblAide, 1, @tailleGrille+1, @tailleGrille-1, 1)

		chargementGrille
	end



	def chargementGrille
		# taille = @grille.length
		# positionne les indices autour de la table @gridJeu


		# TODO - Ruby-fier ce loop

		0.upto(@tailleGrille-1) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			btnIndiceCol = Gtk::Button.new(:label=>@grille.tentesCol.fetch(i).to_s)
			btnIndiceCol.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceCol,i+1,0,1,1)
			btnIndiceCol.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[k][i].statutVisible.isVide?
						@grille[k][i].cycle(@grille)
						@gridJeu.get_child_at(i+1,k+1).image=scaleImage(@grille[k][i].affichage)
					end
				}
				# puts "Clique sur le bouton de la colonne " + i.to_s
			}
			# ici les indices des lignes (nb tentes sur chaque ligne)
			btnIndicesLig = Gtk::Button.new(:label=> @grille.tentesLigne.fetch(i).to_s)
			btnIndicesLig.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndicesLig,0,i+1,1,1)
			btnIndicesLig.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[i][k].statutVisible.isVide?
						@grille[i][k].cycle(@grille)
						@gridJeu.get_child_at(k+1,i+1).image=scaleImage(@grille[i][k].affichage)
						# @gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(i,k))
					end
				}
			}
		}
		
		# positionne les cases de la grille
		@grille.grille.each do |line|
			line.each do |cell|
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
				# button.set_image(scaleImage(i,j))
				button.signal_connect("clicked") {
					@grille[i][j].cycle(i,j, @grille)
					button.set_image(scaleImage(Gtk::Image.new(:file => @grille[i][j].affichage)))
					# button.set_image(i,j)
					if @caseSurbrillanceList != nil
						while not @caseSurbrillanceList.empty?
								caseSubr = @caseSurbrillanceList.shift
								@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).set_image(scaleImage(Gtk::Image.new :file => @grille[caseSubr.x][caseSubr.y].affichage))
								# @gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).set_image(scaleImage(caseSubr.x,caseSubr.y))
						end
					end

					self.jeuTermine		if @grille.estValide
				}
				@gridJeu.attach(button,j+1,i+1,1,1)
			}
		}
		return self
	end

	# A partir du fichier en path _string_, crée une image et la redimensionne
	# pour s'adapter à la taille de la fenêtre 
	# Return cette image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)
		winX = @fenetre.size.fetch(0)
		winY = @fenetre.size.fetch(1)
		# @tailleGrille = @grille.length
		imgSize = winY / (@tailleGrille*2)

		# image = Gtk::Image.new :file => @grille[x][y].affichage
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end


	# Créé un attribut @btnReset qui est le bouton de remise à zéro
	# initialise le bouton
	def initBoutonReset
		# @tailleGrille = @grille.length
		@btnReset = Gtk::Button.new :label => "Reset"
		@btnReset.signal_connect("clicked") {
			reset
		}
	end

	# Réinitialise la grille
	def reset
		@grille.grille.each do |line|
			line.each do |cell|
				cell.reset
				#puts (@gridJeu.get_child_at(j,i).class.to_s + i.to_s + j.to_s)
				@gridJeu.get_child_at(cell.y+1,cell.x+1).image=(scaleImage(cell.affichage))
				# @gridJeu.get_child_at(j+1,i+1).set_image(scaleImage(i,j))
			end
		end
	end

	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") { self.lancementModeJeu }
	end

	# Comportement a la fin du jeu
	def jeuTermine
		self.lancementFinDeJeu
	end
end
