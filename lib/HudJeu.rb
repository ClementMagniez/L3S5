require_relative 'Hud'

# Classe abstraite permettant de créer un écran de jeu
class HudJeu < Hud
	attr_reader :grille, :timer

	# Positionne les boutons de sauvegarde/réinitialisation/annulation/etc
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize(window,grille)
		super(window)
		@align = Gtk::Align.new(1)
		@aide = Aide.new(grille)

		@gridJeu = Gtk::Grid.new
		@gridJeu.set_halign(@align)
		@gridJeu.set_valign(@align)
		@grille = grille
		@tailleGrille = @grille.length

		@sizeGridJeu = 10
		@varFinPlaceGrid = @sizeGridWin/4 + @sizeGridJeu
		@varDebutPlaceGrid = @sizeGridWin/4

		initTimer
		initBoutonRegle
		chargementGrille
		initBoutonAide
		initBoutonPause
		initBoutonReset
		initBoutonCancel
		initBoutonRemplissage
		initBoutonSauvegarde
		initBoutonRetour


		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				@lblTime.hexpand = true
				@lblTime.halign = Gtk::Align::CENTER
			hBox.add(@lblTime)
			hBox.add(@btnRegle)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.valign = Gtk::Align::CENTER
			hBox.vexpand = true
			hBox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox2.valign = Gtk::Align::CENTER
				vBox2.add(@btnAide)
				vBox2.add(@btnPause)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
			hBox.add(vBox2)
		vBox.add(hBox)
		vBox.add(@lblAide)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.vexpand = true
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
				@btnRetour.valign = Gtk::Align::END
				@btnRetour.halign = Gtk::Align::END
			hBox.add(@btnRetour)
		vBox.add(hBox)

		self.attach(vBox, 0, 0, 1, 1)

		ajoutFondEcran
	end

	def desurbrillanceIndice
		if @lblIndiceSubr != nil
			@lblIndiceSubr.color = "white"
			@lblIndiceSubr = nil
		end
	end

	def desurbrillanceCase
		if @caseSurbrillanceList != nil
			while not @caseSurbrillanceList.empty? # TODO chercher autre chose
				caseSubr = @caseSurbrillanceList.shift
				@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).image=\
									scaleImage(@grille[caseSubr.x][caseSubr.y].affichage)
				# @gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).set_image(scaleImage(caseSubr.x,caseSubr.y))

			end
		end
	end

	# Renvoie la taille préférentielle des nombres encadrant la grille
	def getIndiceSize
		return @grille.length>12 && @@winY<700 ? "small" : "x-large"
	end

	# Crée et stylise le label indiquant le nombre de tentes dans une ligne/colonne
	# - i : indice de la ligne/colonne
	# - ligneOuColonne : symbole ∈ { :varTentesCol, :varTentesLigne } - accesseur
	# de la variable d'instance Grille#varTentesCol ou Grille#varTentesLigne selon
	# le symbole passé
	# - return le CustomLabel créé
	def labelIndice(i,ligneOuColonne)
		return CustomLabel.new(@grille.send(ligneOuColonne)[i].to_s,
													 "white",self.getIndiceSize,'ultrabold')
	end

	# Réinitialise la grille
	def reset
		@grille.grille.each do |line|
			line.each do |cell|
				cell.reset
				#puts (@gridJeu.get_child_at(j,i).class.to_s + i.to_s + j.to_s)
				@gridJeu.get_child_at(cell.y+1,cell.x+1).image=scaleImage(cell.affichage)
				# @gridJeu.get_child_at(j+1,i+1).set_image(scaleImage(i,j))
			end
		end
		@grille.raz
		if @t != nil
				@t.kill
				@stockHorloge =0
				@timer = Time.now
				@t = Thread.new{timer}
				if @pause
					@btnPause.text = "Pause"
				end
		end
	end

	def getTime
		if @horloge != nil
			return @horloge
		end
	end

protected

	# Calcule un coup possible selon l'état de la grille et affiche l'indice trouvé
	# dans @lblAide ; peut mettre en surbrillance (changement de couleur) une case ou un indice
	# - return self
	def afficherAide

		# TODO afficher l'image de fond en la mettant dans une grid avec le label
#		image = Gtk::Image.new( :file => "../img/gris.png")
#		image.pixbuf = image.pixbuf.scale((@@winX/2.5),(@@winY/@sizeGridWin)*2)
		# self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		taille = @grille.length

		tableau = @aide.cycle("rapide")
		caseAide = tableau.at(0)
		if caseAide != nil
			@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1)\
			.set_image(scaleImage(caseAide.affichageSubr))
		end
		 @lblAide.set_text(tableau.at(1))

		indice = tableau.at(3)

		if tableau.at(2) != nil
			if tableau.at(2) == false
				lblIndice = @gridJeu.get_child_at(0,indice).child
			else
				lblIndice = @gridJeu.get_child_at(indice,0).child
			end

			lblIndice.color = "red"
			# On garde une référence sur le label de la ligne ou colonne mise en évidence
			@lblIndiceSubr = lblIndice
		end

	end

	# Initialise la grille de jeu :
	# 	ajoute une variable d'instance @gridJeu : la grille de jeu avec laquelle le joueur interagira
	def chargementGrille
		# TODO - Ruby-fier ce loop
		0.upto(@tailleGrille-1) { |i|
			# ici les indices des colonnes (nb tentes sur chaque colonne)
			btnIndiceCol = CustomButton.new
			btnIndiceCol.label = labelIndice(i,:varTentesCol)
			btnIndiceCol.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceCol,i+1,0,1,1)
			#Quand on clique dessus, met toutes les cases vides à gazon
			btnIndiceCol.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[k][i].statutVisible.isVide?
						@grille[k][i].cycle(@grille)
						@gridJeu.get_child_at(i+1,k+1).image=scaleImage(@grille[k][i].affichage)
					end
				}
				desurbrillanceIndice
			}
#			 ici les indices des lignes (nb tentes sur chaque ligne)
			btnIndiceLig = CustomButton.new
			btnIndiceLig.label = labelIndice(i,:varTentesLigne)
			btnIndiceLig.set_relief(Gtk::ReliefStyle::NONE)
			@gridJeu.attach(btnIndiceLig,0,i+1,1,1)
#			Quand on clique dessus, met toutes les cases vides à gazon
			btnIndiceLig.signal_connect("clicked") {
				0.upto(@tailleGrille-1) { |k|
					if @grille[i][k].statutVisible.isVide?
						@grille[i][k].cycle(@grille)

						@gridJeu.get_child_at(k+1,i+1).image=scaleImage(@grille[i][k].affichage)
		#				 @gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(i,k))

					end
				}
				desurbrillanceIndice
			}
		}

		# positionne les cases de la grille
		@grille.grille.each do |line|
			line.each do |cell|
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)

				button.set_image(scaleImage(cell.affichage))
				# button.add(scaleImage(cell.affichage))
				# button.set_image(scaleImage(i,j))
				button.signal_connect("clicked") do
					cell.cycle(@grille)
					button.set_image(scaleImage(cell.affichage))
					# button.remove_child
					# button.add(scaleImage(cell.affichage))
					# button.set_image(i,j)
					desurbrillanceCase
					desurbrillanceIndice
					self.jeuTermine		if @grille.estValide
				end
				@gridJeu.attach(button,cell.y+1,cell.x+1,1,1)
			end
		end
		return self
	end

	# Initialise le bouton d'aide :
	# 	ajoute une variable d'instance @lblAide
	# 	ajoute une variable d'instance @btnAide
	def initBoutonAide
<<<<<<< HEAD
		@lblAide = CustomLabel.new
		@btnAide = CustomButton.new("Aide")
=======
		@lblAide = CustomLabel.new('','white','x-large','ultrabold')
		@btnAide = Gtk::Button.new(label: "Aide")
>>>>>>> 10d230026b89c0e368f6dda9778e4e9d9dcebd37
		@btnAide.signal_connect("clicked") {
			self.afficherAide
		}
	end

	# Initialise le bouton d'annulation :
	# 	ajoute une variable d'instance @btnCancel
	# 	initialise sont comportement
	def initBoutonCancel
<<<<<<< HEAD
		@btnCancel = CustomButton.new("Annuler")
=======
		@btnCancel = creerBouton(Gtk::Label.new("Annuler"),"white","ultrabold","x-large")
>>>>>>> 10d230026b89c0e368f6dda9778e4e9d9dcebd37
		@btnCancel.signal_connect('clicked'){
			cell = @grille.cancel
			if cell != nil
				@gridJeu.get_child_at(cell.y+1,cell.x+1)\
				.set_image(scaleImage(cell.affichage))
			end
		}
	end

	# Initialise le bouton pause :
	# 	ajoute une variable d'instance @btnPause
	# 	initialise sont comportement
	def initBoutonPause
		@btnPause = CustomButton.new("Pause")
		@btnPause.signal_connect('clicked'){
			if @pause
				@timer = Time.now
				@t = Thread.new{timer}
				@btnPause.text = "Pause"
				@pause = false
			else
				@stockHorloge = @stockHorloge + (Time.now - @timer)
				@t.kill
				@btnPause.text = "Play"
				@pause = true
			end
		}
	end

	# Initialise le bouton des règles de jeu :
	# 	ajoute une variable d'instance @btnRegle
	# 	initialise sont comportement
	def initBoutonRegle
		@btnRegle = CustomButton.new("?", "pink")
		# self.attach(@btnRegle,@sizeGridWin-2,3,1,1)
	end

	# Initialise le bouton de remplisssage des cases triviales, les cases non adjascentes à un arbre :
	# 	ajoute une variable d'instance @btnRemplissage
	# 	initialise sont comportement
	def initBoutonRemplissage
		@btnRemplissage = CustomButton.new("Remplir")
		@btnRemplissage.signal_connect('clicked') {
			liste = @aide.listeCasesGazon
			while not liste.empty?
				caseRemp = liste.pop
				if caseRemp.statutVisible.isVide?
					caseRemp.cycle(@grille)
					@gridJeu.get_child_at(caseRemp.y+1,caseRemp.x+1).set_image(scaleImage(caseRemp.affichage))

				end
			end
		}
	end

	# Initialise le bouton reset (qui fait recommencer la grille) :
	# 	ajoute une variable d'instance @btnReset
	# 	initialise sont comportement
	def initBoutonReset
		@btnReset = CustomButton.new("Reset")
		@btnReset.signal_connect("clicked") {
			reset
			if @lblAide != nil
			# self.styleLabel(@lblAide,"white","normal","x-large","Alors comme ça, on recommence? :O !")
			@lblAide.set_text("") # TODO
			#@lblAide.set_markup ("<span foreground='white' > Alors comme ça, on recommence? :O !</span>")
			end
			if @t != nil
				@t.kill
				@stockHorloge =0
				@timer = Time.now
				@t = Thread.new{timer}
				if @pause
					@btnPause.set_label("Pause")
				end
			end
			desurbrillanceIndice
		}
	end

	# Initialise le bouton de sauvegarde :
	# 	ajoute une variable d'instance @btnSauvegarde
	# 	initialise sont comportement
	def initBoutonSauvegarde
		@btnSauvegarde = CustomButton.new("Sauvegarder")
		@btnSauvegarde.signal_connect('clicked') do
			Dir.mkdir("saves")	unless Dir.exist?("saves")
			File.open("saves/"+@@name+".txt", "w+", 0644) do |f|
				f.write( Marshal.dump([@grille,@@mode,@@difficulte]))
			end
		end

	end

	# Initialise le timer :
	# 	ajoute une variable d'instance @lblTime, le label associé au timer.
	def initTimer
		@lblTime = CustomLabel.new("00:00", "white")
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		@t=Thread.new{timer}
	end

	# Méthode invoquée a la fin du jeu
	def jeuTermine
		self.lancementFinDeJeu
	end

	# A partir du fichier en path _string_, crée une Gtk::Image
	# et la redimensionne pour s'adapter à la taille de la fenêtre
	# Return cette Gtk::Image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)

		imgSize = @@winY / (@tailleGrille*2)
		imgSize*=0.85
		# image = Gtk::Image.new :file => @grille[x][y].affichage
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end

	# Implémentation du timer,
	# boucle infinie qui modifie @lblTime à chaque seconde qui passe
	def timer
		while true do
			@horloge = (Time.now - @timer) + @stockHorloge
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			# styleLabel(@lblTime,"white","ultrabold","xx-large",strMinutes + ":" + strSecondes)
			@lblTime.set_text(strMinutes + ":" + strSecondes)
			sleep 1
		end
	end
end
