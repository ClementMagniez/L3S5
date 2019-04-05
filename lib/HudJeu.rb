require_relative 'Hud'

# class abstraite permettant de créer un ecran de jeu
class HudJeu < Hud
	attr_reader :grille, :timer
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
		initBoutonSauvegarde


		self.attach(@btnSauvegard,@varPlaceGrid/2,3,2,1)
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

						@gridJeu.get_child_at(k+1,i+1).image=scaleImage(@grille[i][k].affichage)
						# @gridJeu.get_child_at(k+1,i+1).set_image(scaleImage(i,k))

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

					if @caseSurbrillanceList != nil
						while not @caseSurbrillanceList.empty? # TODO chercher autre chose
								caseSubr = @caseSurbrillanceList.shift
								@gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).image=\
													scaleImage(@grille[caseSubr.x][caseSubr.y].affichage)
								# @gridJeu.get_child_at(caseSubr.y+1,caseSubr.x+1).set_image(scaleImage(caseSubr.x,caseSubr.y))

						end
					end
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
			@lblIndiceSubr.set_markup ("<span foreground='white' weight='ultrabold' size='x-large'> "+@lblIndiceSubr.text+"</span>")
			@lblIndiceSubr = nil
		end
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


	# A partir du fichier en path _string_, crée une Gtk::Image
	# et la redimensionne pour s'adapter à la taille de la fenêtre
	# Return cette Gtk::Image redimensionnée
	def scaleImage(string)
		image=Gtk::Image.new(:file => string)
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
			@grille.score.reset()
			reset
			if @lblAide != nil
			@lblAide.set_markup ("<span foreground='white' > Alors comme ça, on recommence? :O !</span>")
			end
		}
	end

	def initBoutonResetRapide
		@btnReset.signal_connect("clicked") {
			@t.kill
			@stockHorloge =0
			@timer = Time.now
			@t = Thread.new{timer}
			if @pause
				@btnPause.set_label("Pause")
			end
		}

	end

	def initBoutonTimer
		@btnPause = Gtk::Button.new :label => "Pause"
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

	def timer
		while true do
			@horloge = (Time.now - @timer) + @stockHorloge
				minutes = (@horloge/60).to_i
					strMinutes = (minutes < 10 ? "0" : "") + minutes.to_s
				secondes = (@horloge%60).to_i
					strSecondes = (secondes < 10 ? "0" : "") + secondes.to_s
			@lblTime.set_label(strMinutes + ":" + strSecondes)
			sleep 1
		end
	end

	def initBoutonCancel
		@btnCancel = Gtk::Button.new :label => "Cancel"
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
		puts(@grille.estComplete?)
	end

	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") { self.lancementModeJeu }
	end

	# Méthode invoquée a la fin du jeu
	def jeuTermine
		self.lancementFinDeJeu
	end

	def initBoutonSauvegarde
		@btnSauvegard = Gtk::Button.new :label => "Sauvegarder"
		@btnSauvegard.signal_connect('clicked') {
			puts(" Je ne fais actuellement rien, mais j'aimerai charger une sauvegarder et j'aime aussi les Pommes.")
		}
	end

	#Fonction d'aide pour l'HUD exploration et rapide
	def aide
		taille = @grille.length
		@btnAide = Gtk::Button.new :label => " Aide "
		@btnAide.signal_connect("clicked") {
			tableau = @aide.cycle("rapide")
			caseAide = tableau.at(0)
			if caseAide != nil then

					@gridJeu.get_child_at(caseAide.y+1,caseAide.x+1).set_image(scaleImage(caseAide.affichageSubr))
					puts(" X :" + caseAide.x.to_s + " Y :" +caseAide.y.to_s )

			end
			@lblAide.use_markup = true
			@lblAide.set_markup ("<span foreground='white' >"+tableau.at(1)+"</span>");

			indice = tableau.at(3)

			if tableau.at(2) != nil
				if tableau.at(2) == false
					lblIndice = @gridJeu.get_child_at(0,indice).child
					puts(indice)
					lblIndice.set_markup ("<span foreground='red' weight='ultrabold' size='x-large'>" + lblIndice.text + "</span>" )


				else
					lblIndice = @gridJeu.get_child_at(indice,0).child
					puts(indice)
					lblIndice.set_markup ("<span foreground='red' weight='ultrabold' size='x-large'>" +lblIndice.text + "</span>")
				end
				@lblIndiceSubr = lblIndice
			end
		}
	end
end
