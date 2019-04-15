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

		initBoutonReset
		initBoutonRetour
		initBoutonCancel
		chargementGrille
		initBoutonSauvegarde
		initBoutonRemplissage
		initBoutonProfil
		@varFinPlaceGrid = @sizeGridWin/4 + @sizeGridJeu
		@varDebutPlaceGrid = @sizeGridWin/4


		self.attach(@btnReset,@varFinPlaceGrid-1,@varDebutPlaceGrid+1,4,2)
		self.attach(@btnCancel,@varFinPlaceGrid-1,@varDebutPlaceGrid+3,4,2)
		self.attach(@btnRemplissage,@varFinPlaceGrid-1,@varDebutPlaceGrid+5,4,2)
		self.attach(@btnSauvegarde,@varFinPlaceGrid-1,@varDebutPlaceGrid+7,4,2)
		self.attach(@btnProfil, @sizeGridWin -3 , 0, 3, 2)

		self.attach(@btnRetour,@sizeGridWin-3,@sizeGridWin-3,3,2)
		self.attach(@btnOptions, 1, @sizeGridWin-3, 4,3)

#
	end



	def chargementGrille
		# taille = @grille.length
		# positionne les indices autour de la table @gridJeu


		# TODO - Ruby-fier ce loop

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
						@gridJeu.get_child_at(i+1,k+1).image=scaleImage(@grille[k][i].affichage)
					end
				}
				desurbrillanceIndice
			}
#			 ici les indices des lignes (nb tentes sur chaque ligne)
			lblIndiceLig = labelIndice(i,"ligne")
			btnIndiceLig = Gtk::Button.new
			btnIndiceLig.add(lblIndiceLig)
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
				# button.set_image(scaleImage(i,j))
				button.signal_connect("clicked") do
					cell.cycle(@grille)
					button.set_image(scaleImage(cell.affichage))
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

	def desurbrillanceIndice
		if @lblIndiceSubr != nil
			self.styleLabel(@lblIndiceSubr,"white","ultrabold","x-large",@lblIndiceSubr.text)
			#@lblIndiceSubr.set_markup ("<span foreground='white' weight='ultrabold' size='x-large'> "+@lblIndiceSubr.text+"</span>")
			@lblIndiceSubr = nil
		end
	end

	def desurbrillanceCase
		if @caseSurbrillanceList != nil
			while not @caseSurbrillanceList.empty? # TODO chercher autre chose
				caseSubr = @caseSurbrillanceList.shift
				@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).image=\
									scaleImage(@grille[caseSubr.x][caseSubr.y].affichage)

			end
		end
	end


	def labelIndice(i,ligneOuColonne)
		lblIndice = Gtk::Label.new
		lblIndice.use_markup = true
		size=@grille.length>12 ? "small" : "x-large"
		if ligneOuColonne == "ligne"
			self.styleLabel(lblIndice,"white","ultrabold",size,
											@grille.tentesLigne.fetch(i).to_s)
		else
			self.styleLabel(lblIndice,"white","ultrabold",	size,
											@grille.tentesCol.fetch(i).to_s)
		end

		return lblIndice
	end


	# A partir du fichier en path _string_, crée une Gtk::Image
	# et la redimensionne pour s'adapter à la taille de la fenêtre
	# Return cette Gtk::Image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)

		minSize=(@@winX > @@winY ? @@winY : @@winX) / @grille.length
		minSize*=0.4
		imgSize =  minSize#@@winX / (@tailleGrille*5) # TODO tester

		# image = Gtk::Image.new :file => @grille[x][y].affichage
		image.pixbuf = image.pixbuf.scale(imgSize,imgSize)	if image.pixbuf != nil

		return image
	end


	# Créé un attribut @btnReset qui est le bouton de remise à zéro
	# initialise le bouton
	def initBoutonReset
		@btnReset = Gtk::Button.new
		styleBouton(@btnReset,Gtk::Label.new("Reset"),"white","ultrabold","x-large")
		@btnReset.signal_connect("clicked") {
			reset
			if @lblAide != nil
			self.styleLabel(@lblAide,"white","normal","x-large","Alors comme ça, on recommence? :O !")
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

	def getTime
		if @horloge != nil
			return @horloge
		end
	end

	def initBoutonTimer
		@btnPause = Gtk::Button.new
		styleBouton(@btnPause,Gtk::Label.new("Pause"),"white","ultrabold","x-large")
		@lblTime = Gtk::Label.new(" 00:00 ")
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		@t=Thread.new{timer}


	end

	def initBoutonPause
		@btnPause.signal_connect('clicked'){
			if @pause
				@timer = Time.now
				@t = Thread.new{timer}
				@btnPause.set_label("Pause")
				@pause = false
			else
				@stockHorloge = @stockHorloge + (Time.now - @timer)
				@t.kill
				@btnPause.set_label("Play")
				@pause = true
			end
		}

	end


	def initBoutonCancel

		@btnCancel = Gtk::Button.new
		styleBouton(@btnCancel,Gtk::Label.new("Cancel"),"white","ultrabold","x-large")
		@btnCancel.signal_connect('clicked'){

			cell = @grille.cancel
			if cell != nil
				@gridJeu.get_child_at(cell.y+1,cell.x+1)\
				.set_image(scaleImage(cell.affichage))
			end
		}
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
					@btnPause.set_label("Pause")
				end
		end
	end


	# Méthode invoquée a la fin du jeu

	def jeuTermine
		self.lancementFinDeJeu
	end

	def initBoutonSauvegarde
		puts "test"
		@btnSauvegarde = Gtk::Button.new :label => "Sauvegarder"
		@btnSauvegarde.signal_connect('clicked') do
			Dir.mkdir("saves")	unless Dir.exist?("saves")
			File.open("saves/"+@@name+".txt", "w+", 0644) do |f|
				f.write( Marshal.dump([@grille,@@mode,@@difficulte]))
			end
		end


	end


	#Fonction d'aide pour l'HUD exploration et rapide
	def aide
		@lblAide = Gtk::Label.new()
		@lblAide.use_markup = true
		self.styleLabel(@lblAide,"white","normal","x-large","Bienvenue sur notre super jeu !")
		#@lblAide.set_markup ("<span foreground='white' >Bienvenue sur notre super jeu !</span>");

		self.attach(@lblAide,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		image = Gtk::Image.new( :file => "../img/gris.png")
		image.pixbuf = image.pixbuf.scale((@@winX/2.5),(@@winY/@sizeGridWin)*2)
		self.attach(image,@varDebutPlaceGrid,@varFinPlaceGrid+3,@sizeGridJeu,2)

		taille = @grille.length

		@btnAide = Gtk::Button.new
		styleBouton(@btnAide,Gtk::Label.new("Aide"),"white","ultrabold","x-large")
		@btnAide.signal_connect("clicked") {

			tableau = @aide.cycle("rapide")
			caseAide = tableau.at(0)
			if caseAide != nil then

					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(scaleImage(caseAide.affichageSubr))
					puts(" X :" + caseAide.x.to_s + " Y :" +caseAide.y.to_s )

			end
			@lblAide.use_markup = true
			styleLabel(@lblAide,'white','ultrabold','x-large',tableau.at(1))

			indice = tableau.at(3)

			if tableau.at(2) != nil
				if tableau.at(2) == false
					lblIndice = @gridJeu.get_child_at(0,indice).child
				else
					lblIndice = @gridJeu.get_child_at(indice,0).child
				end
				styleLabel(lblIndice,'red','ultrabold','x-large',lblIndice.text)
				@lblIndiceSubr = lblIndice
			end
		}
	end

	def timer
		while true do
			@horloge = (Time.now - @timer) + @stockHorloge
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			styleLabel(@lblTime,"white","ultrabold","xx-large",strMinutes + ":" + strSecondes)
			sleep 1
		end
	end


	def initBoutonRemplissage
		@btnRemplissage = Gtk::Button.new
		styleBouton(@btnRemplissage,Gtk::Label.new("Remplir"),"white","ultrabold","x-large")
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

end
