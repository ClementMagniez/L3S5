require_relative 'Hud'
require_relative 'AidesConstantes'


# Classe abstraite permettant de créer un écran de jeu
class HudJeu < Hud
	include AidesConstantes
	attr_reader :grille, :timer

	# Positionne les boutons de sauvegarde/réinitialisation/annulation/etc
	# - window : la fenêtre principale de l'application
	# - grille : une Grille de jeu
	def initialize(window,grille)
		super(window)
		@aide = Aide.new(grille)
		# Le label d'aide est placé dans une Gtk::Grid afin de pouvoir y attacher une image de fond
		@gridLblAide = Gtk::Grid.new
		@gridJeu = Gtk::Grid.new
		@gridJeu.row_homogeneous = true
		@gridJeu.column_homogeneous = true
		@grille = grille
		# Un indices de ligne ou colonne est mis en valeur,
		# cet attribut référencie l'indice afin de ne plus mettre en valeur l'indice en question
		@lblIndiceSubr = nil
		@pause=false

		self.initTimer
		self.initBoutonRegle
		self.chargementGrille
		self.initBoutonAide
		self.initBoutonPause
		self.initBoutonReset
		self.initBoutonCancel
		self.initBoutonRemplissage
		self.initBoutonSauvegarde
		self.initBoutonRetour
		@btnRetour.text = "Abandonner"


		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				@lblTimer.hexpand = true
				@lblTimer.halign = Gtk::Align::CENTER
			hBox.add(@lblTimer)
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
			@gridLblAide.halign = Gtk::Align::CENTER
			@gridLblAide.attach(@lblAide, 0, 0, 1, 1)
				image = Gtk::Image.new( :file => "../img/gris.png")

				image.pixbuf = image.pixbuf.scale((@@winX/3),(@@winY/15))
			@gridLblAide.attach(image, 0, 0, 1, 1)
		vBox.add(@gridLblAide)
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


 def initBoutonRetour
	 @btnRetour = CustomButton.new("Retour")
 		@btnRetour.signal_connect("clicked") {self.lancementModeJeu }
 end

	# =======================
	# TODO
	# est-ce vraiment utile ???
	# @caseSurbrillanceList n'est utilisé nulle part ailleurs, je suppose donc que cette méthode ne sert à rien...
	# Ca a le mérite d'avoir une utilité en tuto
	# =======================

	def desurbrillanceCase
		if @caseSurbrillanceList != nil
			while not @caseSurbrillanceList.empty?
				caseSubr = @caseSurbrillanceList.shift
				@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).\
				replace(scaleImage(@grille[caseSubr.x][caseSubr.y].affichage))
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
				@gridJeu.get_child_at(cell.y+1,cell.x+1).replace(scaleImage(cell.affichage))
			end
		end
		@grille.raz
		self.resetTimer
		@btnPause.text = @pause ? "Jouer" : "Pause"
		@lblAide.text="" 
		desurbrillanceIndice
	end

protected


	# Calcule un coup possible selon l'état de la grille et affiche l'indice trouvé
	# dans @lblAide ; peut mettre en surbrillance (changement de couleur) une case ou un indice
	# - typeAide : par défaut "rapide", indique le mode de jeu 
	# (donc le degré de précision de l'aide) voulu
	# - return self

	def afficherAide(typeAide="rapide")
		# TODO afficher l'image de fond en la mettant dans une grid avec le label
#		image = Gtk::Image.new( :file => "../img/gris.png")
#		image.pixbuf = image.pixbuf.scale((@@winX/2.5),(@@winY/@sizeGridWin)*2)
		# self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)
		@caseSurbrillanceList = Array.new
		#Met une case en surbrillance
		tableau=@aide.cycle(typeAide)
		caseAide = tableau.at(CASE)

		if caseAide != nil
			@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).\
			replace(scaleImage(caseAide.affichageSubr))
			@caseSurbrillanceList.push(caseAide)
		end
		#Affiche le message d'aide
		 @lblAide.set_text(tableau.at(MESSAGE))

	 	 if @@winY<1100
		 	 @lblAide.set_size('xx-large')  
	 	 elsif @@winY<800
		 	 @lblAide.set_size('large')  
	 	 elsif @@winY<600
		 	 @lblAide.set_size('small')  
		end

		#Met un indice de colonne ou ligne en surbrillance
		indice = tableau.at(INDICE_LIG_COL)
		if tableau.at(BOOL_LIG_COL) != nil
			if tableau.at(BOOL_LIG_COL) == false
				lblIndice = @gridJeu.get_child_at(0,indice).child
			else
				lblIndice = @gridJeu.get_child_at(indice,0).child
			end
			# Un indice des lignes ou colonnes est mis en valeur : en rouge
			lblIndice.color = "red"
			# On garde une référence sur le label de la ligne ou colonne mise en évidence
			@lblIndiceSubr = lblIndice
		end

		yield(tableau) if block_given?
	end

	# @see initIndices : initialise le nombre de tentes sur chaque colonne
	# - return self
	def initIndicesColonnes
		self.initIndices(false)
	end
	
	# @see initIndices : initialise le nombre de tentes sur chaque ligne
	# - return self
	def initIndicesLignes
		self.initIndices(true)
	end
	
	# @see initIndice : initialise le nombre de tentes sur l'ensemble des lignes
	# ou colonnes selon isRow
	# - isRow : true => initialise les lignes, false => initialise les colonnes
	# - return self
	def initIndices(isRow)
		(@grille.length).times do |i|
			self.initIndice(i,isRow)
		end
		self
	end
	
	# Remplit programmatiquement une cellule vide de gazon et met à jour l'affichage ;
	# utilisé par le signal handler de HudJeu#initIndice
	# - i,k : position de la cellule
	# - return self 
	def fillCellGrid(i,k)
		if @grille[i][k].statutVisible.isVide?
			@grille[i][k].cycle(@grille)
			# @gridJeu.get_child_at(i+1,k+1).image=scaleImage(@grille[k][i].affichage)
			@gridJeu.get_child_at(k+1,i+1).replace(scaleImage(@grille[i][k].affichage))
		end
		self
	end

	# Crée un bouton indiquant le nombre de tentes sur la ligne/colonne _i_, 
	# l'attache à la grille de jeu et permet de remplir toute la ligne/colonne
	# de gazon en cliquant dessus
	# 
	# Peut accepter un block, exécuté dans le signal handler du bouton
	# - i : indice du bouton sur la tente/colonne, tel que i<@ŋrille.length
	# - isRow : true => initialise les lignes, false => initialise les colonnes
	# return self
	def initIndice(i,isRow)
		btnIndice = CustomButton.new
		btnIndice.label = labelIndice(i, isRow ? :varTentesLigne : :varTentesCol)
		btnIndice.set_relief(Gtk::ReliefStyle::NONE)
		
		posX=(isRow ? 0 : i+1)
		posY=i+1-posX

		@gridJeu.attach(btnIndice,posX,posY,1,1)
		#Quand on clique dessus, met toutes les cases vides à gazon
		btnIndice.signal_connect("clicked") do
			(@grille.length).times do |k|
				isRow ?  self.fillCellGrid(i,k) : self.fillCellGrid(k,i) 
			end
			self.desurbrillanceIndice
			yield	if block_given?
		end
		self
	end

	# Initialise la grille de jeu :
	# 	ajoute une variable d'instance @gridJeu : la grille de jeu avec laquelle le joueur interagira
	#
 	# Peut accepter un block, exécuté dans le signal handler de la case
	def chargementGrille
		self.initIndicesColonnes
		self.initIndicesLignes

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
					
					# Note : important de ne yield qu'après les appels à desurbrillanceFoo
					# sans quoi le tutoriel voit ses indices effacés instantanément
					yield if block_given?
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
		@btnRegle.signal_connect('clicked'){
			lancementHudRegle
		}
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

	# Initialise le timer ; ajoute une variable d'instance @lblTimer, le label associé au timer.
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def initTimer(start=0)
		@timer = start
		@lblTimer = CustomLabel.new(self.parseTimer, "white")
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
	# Incrémente le timer et met @lblTimer à jour
	# - modeCalcul : symbole { :+, +- } déterminant si le timer est croissant
	# ou décroissant - par défaut croissant
	# - return !@pause
	def increaseTimer(modeCalcul = :'+' )
		return false if @pause # interrompt le décompte en cas de pause


		@timer=@timer.send(modeCalcul, 1)
		@lblTimer.text=self.parseTimer
		return true
	end

	# Rend lisible le temps écoulé @timer et renvoie le String calculé
	# - return un String contenant un temps mm:ss
	def parseTimer
		[@timer/60, @timer%60].map { |t| t.to_i.to_s.rjust(2,'0') }.join(':')
	end

	# Réinitialise le timer à 0
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def resetTimer(start=0)
		@timer=start
		@lblTimer.text=self.parseTimer
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
		tailleGrille = @grille.length
		imgSize = @@winY / (tailleGrille*1.4)
		imgSize*=0.75
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil
		return image

	end


end
