require_relative 'Hud'
require_relative '../misc/AidesConstantes'

# Classe abstraite permettant de créer un écran de jeu
class HudJeu < Hud
	include AidesConstantes
	# - grille : une Grille de jeu
	# - timer : entier décrivant le temps écoulé depuis le début de la partie
	attr_reader :grille, :timer
	# - tempsRestant : méthode assurant la compatibilité avec HudRapide, par défaut
	# équivalente à :timer
	alias :tempsRestant :timer 
	
	
	
	# Positionne les boutons de sauvegarde/réinitialisation/annulation/etc
	# - grille : une Grille de jeu
	# - timerStart : valeur initiale de @timer
	# - return une nouvelle instance de HudJeu
	def initialize(grille,timerStart=0)
		super(Gtk::Orientation::VERTICAL)
		self.setTitre("Partie #{@@joueur.mode.to_s.capitalize}")
		@aide = Aide.new(grille)
		# Le label d'aide est placé dans une Gtk::Grid afin de pouvoir y attacher une image de fond
		@gridJeu = Gtk::Grid.new
		@gridJeu.row_homogeneous = true
		@gridJeu.column_homogeneous = true

		@gridJeu.name="gridJeu"



		@grille = grille
		@lblScore = CustomLabel.new
		self.reloadScore
		# Un indices de ligne ou colonne est mis en valeur,
		# cet attribut référencie l'indice afin de ne plus mettre en valeur l'indice en question
		@indiceSurbri = nil
		@pause=false

		self.initTimer(timerStart)
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

		self.homogeneous=false

			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.add(@lblScore)
				@lblTimer.hexpand = true
				@lblTimer.halign = Gtk::Align::CENTER
			hBox.add(@lblTimer)
			hBox.add(@btnRegle)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::FILL
			hBox.valign = Gtk::Align::FILL
			hBox.vexpand = true
			hBox.add(@gridJeu)
				vBox2 = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				[@btnAide, @btnPause, @btnReset, @btnCancel,
				@btnRemplissage,@btnSauvegarde].each do |btn|
					btn.vexpand=true
					btn.valign=Gtk::Align::CENTER
					btn.hexpand=false
					btn.halign=Gtk::Align::CENTER
				end
				vBox2.add(@btnAide)
				vBox2.add(@btnPause)
				vBox2.add(@btnReset)
				vBox2.add(@btnCancel)
				vBox2.add(@btnRemplissage)
				vBox2.add(@btnSauvegarde)
					@btnRetour.vexpand = true
					@btnRetour.valign = Gtk::Align::END
					@btnRetour.hexpand=false
					@btnRetour.halign=Gtk::Align::CENTER

				vBox2.add(@btnRetour)
				vBox2.hexpand=true
				vBox2.name="boxUtil"
			hBox.add(vBox2)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.halign = Gtk::Align::CENTER
			hBox.valign = Gtk::Align::CENTER
			hBox.add(@lblAide)
		self.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.hexpand = true
			hBox.homogeneous = true
				@btnOptions.valign = Gtk::Align::END
				@btnOptions.halign = Gtk::Align::START
			hBox.add(@btnOptions)
		self.add(hBox)
	end

	# Retire la surbrillance d'un indice de tente/colonne
	# - return self
	def desurbrillanceIndice
		if @indiceSurbri != nil
			@indiceSurbri.name = "caseIndice"
			
			@indiceSurbri = nil
		end
		self
	end

	# @see Hud#initBoutonRetour
	# - return self
	def initBoutonRetour
		@btnRetour = CustomButton.new("Retour") {self.lancementModeJeu }
		self
	end

	# Retire la surbrillance des cases mises en évidence
	# - return self
	def desurbrillanceCase
		if @caseSurbrillanceList != nil
			while not @caseSurbrillanceList.empty?
				caseSubr = @caseSurbrillanceList.shift
				@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).name="cellJeu"
			end
		end
		self
	end

	# Crée le String indiquant le nombre de tentes dans une ligne/colonne
	# - i : indice de la ligne/colonne
	# - ligneOuColonne : symbole ∈ { :varTentesCol, :varTentesLigne } - accesseur
	# de la variable d'instance Grille#varTentesCol ou Grille#varTentesLigne selon
	# le symbole passé
	# - return le String créé
	def labelIndice(i,ligneOuColonne)
		return  @grille.send(ligneOuColonne)[i].to_s
	end


	# Réinitialise la grille et les affichages
	# - return self
	def reset
		@grille.each do |line|
			line.each do |cell|
				cell.reset
				@gridJeu.get_child_at(cell.y+1,cell.x+1).image=(scaleImage(cell.affichage))
			end
		end
		@grille.raz
		@grille.score.reset
		self.setTitre("Partie #{@@joueur.mode.to_s.capitalize}")
		self.reloadScore
		self.resetTimer
		@btnPause.text = @pause ? "Jouer" : "Pause"
		@lblAide.text=""
		desurbrillanceCase
		desurbrillanceIndice
		self
	end

	# Met à jour l'affichage du score avec une valeur modifiée
	# - return self
	def reloadScore
		@lblScore.set_text("Score : " + @grille.score.valeur.to_s)
		self
	end

#	protected
		attr_writer :timer

	# Calcule un coup possible selon l'état de la grille et affiche l'indice trouvé
	# dans @lblAide ; peut mettre en surbrillance (changement de couleur) une case ou un indice
	# - typeAide : par défaut "rapide", indique le mode de jeu
	# (donc le degré de précision de l'aide) voulu
	# - return self
	def afficherAide(typeAide="rapide")

		@caseSurbrillanceList = Array.new
		#Met une case en surbrillance
		tableau=@aide.cycle(typeAide)
		caseAide = tableau.at(CASE)

		if caseAide != nil
			@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).name="cellJeuSurbri"
			@caseSurbrillanceList.push(caseAide)
		end
		#Affiche le message d'aide
		 @lblAide.set_text(tableau.at(MESSAGE))

		#Met un indice de colonne ou ligne en surbrillance
		indice = tableau.at(INDICE_LIG_COL)
		if tableau.at(BOOL_LIG_COL) != nil
			if tableau.at(BOOL_LIG_COL)
				@indiceSurbri = @gridJeu.get_child_at(indice,0)
			else
				@indiceSurbri = @gridJeu.get_child_at(0,indice)
			end
			# Un indice des lignes ou colonnes est mis en valeur : en rouge
			@indiceSurbri.name = "cellJeuSurbri"
			# On garde une référence sur le label de la ligne ou colonne mise en évidence
		end

		yield(tableau) if block_given?
		self
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
			@gridJeu.get_child_at(k+1,i+1).image=(scaleImage(@grille[i][k].affichage))
		end
		self
	end

	# Crée un bouton indiquant le nombre de tentes sur la ligne/colonne _i_,
	# l'attache à la grille de jeu et permet de remplir toute la ligne/colonne
	# de gazon en cliquant dessus
	#
	# Peut accepter un bloc sans paramètre, exécuté dans le signal handler du bouton
	# - i : indice du bouton sur la tente/colonne, tel que i<@ŋrille.length
	# - isRow : true => initialise les lignes, false => initialise les colonnes
	# return self
	def initIndice(i,isRow)
		btnIndice = CustomButton.new("","caseIndice", "lblIndice") do
			(@grille.length).times do |k|
				isRow ?	self.fillCellGrid(i,k) : self.fillCellGrid(k,i)
			end
			self.desurbrillanceIndice
			self.desurbrillanceCase
			self.reloadScore
			yield	if block_given?
		end
		btnIndice.text = labelIndice(i, isRow ? :varTentesLigne : :varTentesCol)

		posX=(isRow ? 0 : i+1)
		posY=i+1-posX

		@gridJeu.attach(btnIndice,posX,posY,1,1)

		self
	end


	# Initialise @gridJeu : la grille de jeu avec laquelle le joueur interagira
	#
 	# Peut accepter un block, exécuté dans le signal handler de la case
 	# - return self
	def chargementGrille
		self.initIndicesColonnes
		self.initIndicesLignes

		# positionne les cases de la grille
		@grille.each do |line|
			line.each do |cell|
				button = CustomButton.new("", "cellJeu", "lblIndice") do
					unless @pause
						cell.cycle(@grille)
						self.reloadScore
						button.image=(scaleImage(cell.affichage))
						desurbrillanceCase
						desurbrillanceIndice
						self.jeuTermine		if @grille.estValide
					end

					# Note : important de ne yield qu'après les appels à desurbrillanceFoo
					# sans quoi le tutoriel voit ses indices effacés instantanément
					yield if block_given?
				end
				button.set_image(scaleImage(cell.affichage))

				button.hexpand=true
				button.vexpand=true
				@gridJeu.attach(button,cell.y+1,cell.x+1,1,1)
			end
		end
		return self
	end

	# Initialise @lblAide et @btnAide, bouton rechargeant le score et appelant
	# HudJeu#afficherAide au clic
	# - return self
	def initBoutonAide
		@lblAide = CustomLabel.new
		@lblAide.name="lblAide"
		@lblAide.wrap=true
		@btnAide = CustomButton.new("Aide") {
			@grille.score.appelerAssistant
			self.afficherAide
			yield if block_given?
		}
		self
	end

	# @see Hud#initBoutonOptions : met le jeu à pause quand le bouton est cliqué
	# - return self
	def initBoutonOptions
		super([:pause])
		@btnOptions.signal_connect("clicked") {
			self.pause
			self.setTitre("Partie #{@@joueur.mode.to_s.capitalize} - Options")
			self.setTitre("#{@@joueur.mode.to_s.capitalize} - Options")		if @@joueur.mode == :tutoriel
		}
		self
	end

	# Initialise le bouton d'annulation @btnCancel, qui reload le dernier score, annule
	# la dernière case cochée et retire les surbrillances
	# - return self
	def initBoutonCancel
		@btnCancel = CustomButton.new("Annuler") {
			cell = @grille.cancel
			if cell != nil
				@gridJeu.get_child_at(cell.y+1,cell.x+1).image=(scaleImage(cell.affichage))
			end
			desurbrillanceCase
			desurbrillanceIndice
			self.reloadScore
			yield if block_given?
		}
		self
	end

	# Initialise @btnPause, bouton appelant HudJeu#pause au clic
	# - return self
	def initBoutonPause
		@btnPause = CustomButton.new("Pause") {
			self.pause
		}
		self
	end

	# @see Hud#initBoutonRegle ; met le jeu à pause tant que le joueur est sur ce  menu
	# - return self
	def initBoutonRegle
		super([:pause])
		@btnRegle.signal_connect("clicked") {
			self.pause
			self.setTitre("Partie #{@@joueur.mode.to_s.capitalize} - Règles")
			self.setTitre("#{@@joueur.mode.to_s.capitalize} - Règles")		if @@joueur.mode == :tutoriel
		}
		self
	end

	# Initialise @btnRemplissage, remplissant les cases non adjascentes à un arbre
	# au clic
	# - return self
	def initBoutonRemplissage
		@btnRemplissage = CustomButton.new("Remplir") {
			liste = @aide.listeCasesGazon
			while not liste.empty?
				caseRemp = liste.pop
				if caseRemp.statutVisible.isVide?
					desurbrillanceCase
					desurbrillanceIndice

					caseRemp.cycle(@grille)
					self.reloadScore
					@gridJeu.get_child_at(caseRemp.y+1,caseRemp.x+1).image=(scaleImage(caseRemp.affichage))
				end
			end
		}
	end

	# Initialise @btnReset, appelant HudJeu#reset au clic
	# - return self
	def initBoutonReset
		@btnReset = CustomButton.new("Reset") {
			self.reset
		}
	end

	# Initialise @btnSauvegarde : au clic, sérialise les données de jeu (grille, mode, 
	# difficulté, timer) dans un fichier au nom du joueur
	# - return self 
	def initBoutonSauvegarde
		@btnSauvegarde = CustomButton.new("Sauvegarder") do
			File.open("../saves/"+@@joueur.login+".txt", "w+", 0644) do |f|
				f.write(Marshal.dump([@grille,@@joueur.mode,@@joueur.difficulte,self.timer]))
			end
		end
	end

	# Calcule le score final de la partia via le timer et l'enregistre dans
	# @@joueur.score
	# Lance le menu de fin de jeu (@see Hud#lancementFinDeJeu)
	# - return self
	def jeuTermine
		@grille.score.recupererTemps(self.timer)
		scoreFinal = @grille.score.calculerScoreFinal
		@@joueur.score = scoreFinal > 0 ? scoreFinal : 0
		self.lancementFinDeJeu
		self
	end

	# A partir du fichier en path _string_, crée une Gtk::Image 28*28
	# - string : path d'un fichier image à charger
	# - return cette Gtk::Image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)		
		image.pixbuf = image.pixbuf.scale(28,28) if image.pixbuf!=nil
		return image
	end

	# # # # # # # # # # #
	#
	# 		TIMER
	#
	# # # # # # # # # # #


public

	# Rend lisible le temps écoulé self.timer et renvoie le String calculé
	# - time : symbole { :timer, :tempsRestant }, indique s'il faut afficher 
	# le temps tel que décrit par HudJeu#timer ou par HudJeu#tempsRestant ; 
	# par défaut :timer, n'a de raison de changer que pour HudRapide
	# - return un String contenant un temps mm:ss
	def parseTimer(time = :timer)
		[self.send(time)/60, self.send(time)%60].map { |t| t.to_i.to_s.rjust(2,'0') }.join(':')
	end

	
protected
	# Initialise le timer ; ajoute une variable d'instance @lblTimer, le label associé au timer.
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def initTimer(start=0)
		@timer = start
		@lblTimer = CustomLabel.new(self.parseTimer, "lblTimer")
		self.startTimer
		self
	end

	def pause
		if @pause
			self.startTimer
			@btnPause.set_text("Pause")
			self.setTitre("Partie #{@@joueur.mode.to_s.capitalize}")
		else
			@btnPause.set_text("Jouer")
			self.setTitre("Partie #{@@joueur.mode.to_s.capitalize} - Pause")
		end
		@pause = !@pause
		@gridJeu.sensitive = !@pause
		@btnAide.sensitive = !@pause
		@btnReset.sensitive = !@pause
		@btnCancel.sensitive = !@pause
		@btnRemplissage.sensitive = !@pause
	end

	# Lance le décompte du temps, incrémenté chaque seconde
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
		true
	end

	# Réinitialise le timer à 0
	# - start : par défaut 0, le temps de départ du timer
	# - return self
	def resetTimer(start=0)
		@timer=start
		@lblTimer.text=self.parseTimer
		self
	end
end
