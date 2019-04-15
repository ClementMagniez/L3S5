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
		@gridJeu.row_homogeneous = true
		@gridJeu.column_homogeneous = true
		@grille = grille
		@tailleGrille = @grille.length
		@pause=false
		# @sizeGridJeu = 10
		# @varFinPlaceGrid = @sizeGridWin/4 + @sizeGridJeu
		# @varDebutPlaceGrid = @sizeGridWin/4

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
			gridLblAide = Gtk::Grid.new
			gridLblAide.halign = Gtk::Align::CENTER
			gridLblAide.attach(@lblAide, 0, 0, 1, 1)
				image = Gtk::Image.new( :file => "../img/gris.png")
				image.pixbuf = image.pixbuf.scale((@@winX/3),(@@winY/15))
			gridLblAide.attach(image, 0, 0, 1, 1)
		vBox.add(gridLblAide)
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


# Disposition alternative où lblAide est dans la même vbox que gridJeu
# et est donc strictement en dessous
# pour l'instant dysfonctionnel car les labels d'aide étendent trop la box
# TODO
#######################################################################
#		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
#			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
#				@lblTime.hexpand = true
#				@lblTime.halign = Gtk::Align::CENTER
#			hBox.add(@lblTime)
#			hBox.add(@btnRegle)
#		vBox.add(hBox)
#			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
#			hBox.halign = Gtk::Align::CENTER
#			hBox.valign = Gtk::Align::CENTER
#			hBox.vexpand = true
#				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
#				vBox2.valign = Gtk::Align::CENTER
#				vBox2.add(@gridJeu)
#					gridLblAide = Gtk::Grid.new
#					gridLblAide.halign = Gtk::Align::CENTER
#					gridLblAide.attach(@lblAide, 0, 0, 1, 1)
#						image = Gtk::Image.new( :file => "../img/gris.png")
#						image.pixbuf = image.pixbuf.scale((@@winX/3),(@@winY/15))
#					gridLblAide.attach(image, 0, 0, 1, 1)
#				vBox2.add(gridLblAide)
#			hBox.add(vBox2)
#				vBox3 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
#				vBox3.valign = Gtk::Align::CENTER
#				vBox3.add(@btnAide)
#				vBox3.add(@btnPause)
#				vBox3.add(@btnReset)
#				vBox3.add(@btnCancel)
#				vBox3.add(@btnRemplissage)
#				vBox3.add(@btnSauvegarde)
#			hBox.add(vBox3)
#######################################################################

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
				# @gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).image=\
				# 					scaleImage(@grille[caseSubr.x][caseSubr.y].affichage)
				@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).replace(scaleImage(@grille[caseSubr.x][caseSubr.y].affichage))
			end
		end
	end

	# Renvoie la taille préférentielle des nombres encadrant la grille
	def getIndiceSize
		return 'large' if @@winY>700
		return @grille.length < 9 ? "large" : (@grille.length < 12 ?  "medium" : "small")
		# return @grille.length>=12 || @@winY<700 ? "small" : "x-large"
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
				@gridJeu.get_child_at(cell.y+1,cell.x+1).replace(scaleImage(cell.affichage))
			end
		end
		@grille.raz
		self.resetTimer
		@btnPause.text = @pause ? "Jouer	" : "Pause"

	end

protected

	# Calcule un coup possible selon l'état de la grille et affiche l'indice trouvé
	# dans @lblAide ; peut mettre en surbrillance (changement de couleur) une case ou un indice
	# - return self
	def afficherAide
		taille = @grille.length

		tableau = @aide.cycle("rapide")
		caseAide = tableau.at(0)
		if caseAide != nil
			# @gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(scaleImage(caseAide.affichageSubr))
			@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).replace(scaleImage(caseAide.affichageSubr))
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
						# @gridJeu.get_child_at(i+1,k+1).image=scaleImage(@grille[k][i].affichage)
						@gridJeu.get_child_at(i+1,k+1).replace(scaleImage(@grille[k][i].affichage))
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

		#				 @gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(i,k))
						@gridJeu.get_child_at(k+1,i+1).replace(scaleImage(@grille[i][k].affichage))
					end
				}
				desurbrillanceIndice
			}
		}

		# positionne les cases de la grille
		@grille.grille.each do |line|
			line.each do |cell|
				button = CustomEventBox.new
				button.set_border_width(1)
				button.add(scaleImage(cell.affichage))
				button.signal_connect("button-release-event") do
					unless @pause
						cell.cycle(@grille)
						button.replace(scaleImage(cell.affichage))
						desurbrillanceCase
						desurbrillanceIndice
						self.jeuTermine		if @grille.estValide
					end
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
		@lblAide = CustomLabel.new
		@lblAide.color = "white"
		@btnAide = CustomButton.new("Aide")
		@btnAide.signal_connect("clicked") {
			self.afficherAide
		}
	end

	# Initialise le bouton d'annulation :
	# 	ajoute une variable d'instance @btnCancel
	# 	initialise sont comportement
	def initBoutonCancel
		@btnCancel = CustomButton.new("Annuler")
		@btnCancel.signal_connect('clicked'){
			cell = @grille.cancel
			if cell != nil
				# @gridJeu.get_child_at(cell.y+1,cell.x+1)\
				# .set_image(scaleImage(cell.affichage))
				@gridJeu.get_child_at(cell.y+1,cell.x+1).replace(scaleImage(cell.affichage))
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
				self.startTimer
				@btnPause.set_text("Pause")
			else
				@btnPause.set_text("Jouer")
			end
			@pause = !@pause
			@gridJeu.sensitive = !@pause
			@btnAide.sensitive = !@pause
			@btnReset.sensitive = !@pause
			@btnCancel.sensitive = !@pause
			@btnRemplissage.sensitive = !@pause
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
					# @gridJeu.get_child_at(caseRemp.y+1,caseRemp.x+1).set_image(scaleImage(caseRemp.affichage))
					@gridJeu.get_child_at(caseRemp.y+1,caseRemp.x+1).replace(scaleImage(caseRemp.affichage))
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
			@lblAide.set_text("") # TODO
			end
			if @t != nil
				self.resetTimer
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

			File.open("../saves/"+@@name+".txt", "w+", 0644) do |f|
				f.write( Marshal.dump([@grille,@@mode,@@difficulte]))
			end
		end

	end

	# Initialise le timer ; ajoute une variable d'instance @lblTime, le label associé au timer.
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def initTimer(start=0)

		@timer = start
		@lblTime = CustomLabel.new(self.parseTimer, "white")
		self.startTimer
		self
	end

	# Lance le décompte du temps
	# - return self
	def startTimer
		GLib::Timeout.add(1000) do
			self.increaseTimer
		end
		self
	end
	# Incrémente le timer et met @lblTime à jour
	# - modeCalcul : symbole { :+, +- } déterminant si le timer est croissant
	# ou décroissant - par défaut croissant
	# - return !@pause
	def increaseTimer(modeCalcul = :'+' )
		return false if @pause # interrompt le décompte en cas de pause


		@timer=@timer.send(modeCalcul, 1)
		@lblTime.text=self.parseTimer
		return true
	end

	# Rend lisible le temps écoulé @timer et renvoie le String calculé
	# - return un String contenant un temps mm:ss
	def parseTimer
		[@timer/60, @timer%60].map { |t| t.to_s.rjust(2,'0') }.join(':')
	end

	# Réinitialise le timer à 0
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def resetTimer(start=0)
		@timer=start
		@lblTime.text=self.parseTimer
		self
	end

	# Méthode invoquée a la fin du jeu
	def jeuTermine
		self.lancementFinDeJeu
	end

	# A partir du fichier en path _string_, crée une Gtk::Image
	# et la redimensionne pour pouvoir l'intégrer à la grille de jeu sans forcer
	# la redimension de la fenêtre
	# - string : path d'un fichier image à charger
	# - return cette Gtk::Image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)

		imgSize = @@winY / (@tailleGrille*1.4)
		imgSize*=0.75
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end

end
