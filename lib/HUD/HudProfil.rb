require 'inifile'

require_relative "../DB/Profil"

class HudProfil < Hud
	def initialize
		super(Gtk::Orientation::VERTICAL)
		self.setTitre("#{@@joueur.login} - Profil")
		@lblErreur = CustomLabel.new('', 'lblErr')
		entNom = Gtk::Entry.new
		entMdp = Gtk::Entry.new
		entMdp.set_visibility(false)

		initBoutonRetour

		initBoutonsChampScore
		initChampScore
		@champScores.set_min_content_height(150)
		@champScores.name="boxScores"


			hBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox.hexpand=true
				vBox.vexpand = true
				vBox.halign = Gtk::Align::CENTER
				vBox.valign = Gtk::Align::CENTER
				vBox.add(CustomLabel.new("Votre compte"))
				vBox.add(@lblErreur)
					hBox2 = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
					hBox2.homogeneous = true
					hBox2.add(CustomLabel.new("Nouveau nom"))
					hBox2.add(entNom)
				vBox.add(hBox2)
					hBox2 = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
					hBox2.homogeneous = true
					hBox2.add(CustomLabel.new("Nouveau mot de passe"))
					hBox2.add(entMdp)
				vBox.add(hBox2)
				vBox.add(initBoutonSauvegarderLogin(entNom, entMdp))
			hBox.add(vBox)
				vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
				vBox.vexpand = true
				vBox.halign = Gtk::Align::CENTER
				vBox.valign = Gtk::Align::CENTER
				vBox.add(CustomLabel.new("Vos scores"))
					hBox2 = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
					hBox2.homogeneous = true
					hBox2.add(@btnAventure)
					hBox2.add(@btnExploration)
					hBox2.add(@btnChrono)
				vBox.add(hBox2)
					hBox2 = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
					hBox2.homogeneous = true
					hBox2.add(initBoutonTri("Score", :montantScore))
					hBox2.add(initBoutonTri("Date", :dateObtention))
				vBox.add(hBox2)
				vBox.add(@champScores)
			hBox.add(vBox)
		self.add(hBox)
			@btnRetour.halign = Gtk::Align::END
		self.add(@btnRetour)
		# self.hexpand = true
		# self.vexpand = true
		# self.valign = Gtk::Align::CENTER
		# self.halign = Gtk::Align::CENTER
	end

private

	# Génère une Box contenant une liste des scores sous forme de CustomLabel,
	# indiquant leur valeur et la date d'enregistrement
	# ; la liste est triée selon _sortCriteria_ et ascendante/descendante selon
	# _sortDown_ avant d'être intégrée à @champScores.
	# - sortCriteria : symbole d'une méthode de Score, typiquement :montantScore
	# ou :dateObtention ; par défaut :montantScore
	# - sortDown : booléen, true => afficher une liste décroissante,
	# false => croissante ; par défaut true, affichant les derniers/meilleurs scores
	# - return self
	def refreshChampScore(mode, sortCriteria=:montantScore, sortDown=true)
		@mode=mode
		@champScores.remove(@champScores.child)		 if @champScores.child != nil
		listeScores = @@joueur.rechercherScores(mode.to_s)

		# trie la liste en ordre ascendant selon le critère donné
		arr = listeScores.sort do |a, b|
				a.send(sortCriteria) <=> b.send(sortCriteria)
		end
		# inverse si on la veut descendante
		arr.reverse! if sortDown

		unless listeScores.empty?
			boxChamp = Gtk::Grid.new
			boxChamp.set_column_homogeneous(true)
			arr.each_with_index do |score,i|
			
				hbox=Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
				btnDeleteRow=CustomButton.new {
					Connexion.supprimerScore(score.id)
					refreshChampScore(mode,sortCriteria, sortDown)
				}
				btnDeleteRow.image=Gtk::Image.new(stock: Gtk::Stock::DELETE, size: Gtk::IconSize::BUTTON)
				hbox.add(btnDeleteRow)
				hbox.add(CustomLabel.new("#{score.montantScore.to_s.rjust(4,' ')}",
																				"lblScores"))
			
				# /!\ Le whitespace ASCII typique n'est apparemment pas reconnu par
				# rjust ; il s'agit ici d'un whitespace U+2000, à ne pas remplacer
				# naïvement
				boxChamp.attach(hbox, 0,i,1,1)
				boxChamp.attach(CustomLabel.new("#{score.dateObtention}",
																			  "lblScores"), 1,i,1,1)
			end
			@champScores.add(boxChamp)
		else
			@champScores.add(CustomLabel.new("Aucun score trouvé pour ce mode !"))
		end
		@champScores.show_all
		self
	end

	def initBoutonsChampScore
		@btnAventure = CustomButton.new("Aventure") do
			refreshChampScore(:aventure)
		end

		@btnExploration = CustomButton.new("Exploration") do
			refreshChampScore(:exploration)
		end

		@btnChrono = CustomButton.new("Contre-la-montre") do
			refreshChampScore(:rapide)
		end
	end

	def initBoutonRetourMenu
		@btnRetour = CustomButton.new("Retour") do
			lancementModeJeu
		end
	end

	# Crée un bouton permettant d'enregistrer les modifications du login/mot de passe
	# et le renvoie
	# - entNom, entMdp : deux Gtk::Entry contenant les données utilisée
	# - return un CustomButton
	def initBoutonSauvegarderLogin(entNom, entMdp)
		btnSauvegarde = CustomButton.new("Sauvegarder les modifications") do

			strNom = entNom.text.tr("^[a-z][A-Z][0-9]\s_-", "")
			strMdp = entMdp.text

			if(strNom.empty? && strMdp.empty?)
				@lblErreur.text = "Vous devez remplir au moins un champ !"
			elsif strNom != entNom.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
			elsif strNom.length > 32
				@lblErreur.text = "Identifiant trop long (> 32) !"
			elsif !strMdp.empty? && strMdp.length < 2
				@lblErreur.text = "Le mot de passe doit faire au moins 2 caractères"
			else
				user = Profil.find_by(pseudonyme: @@joueur.login)
				unless strMdp.empty?
					# Enregistrement du mot de passe crypté
					user.mdpEncrypted = strMdp.crypt(strMdp)
					user.save
				end
				unless strNom.empty? || @@joueur.login==strNom
					# Enregistrement du pseudo
					# Si l'identifiant est déjà présent dans la base de données
					if Profil.find_by(pseudonyme: strNom) != nil
						@lblErreur.text="Cet identifiant existe déjà."
					else
						user.pseudonyme = strNom
						user.save
						@@config.filename=@@config.filename.sub(@@joueur.login, strNom)						
						puts @@config.filename
						@@config.save
						File.delete("../config/#{@@joueur.login}.ini")
						if File.exist?("../saves/#{@@joueur.login}.txt")
							File.rename("../saves/#{@@joueur.login}.txt", "../saves/#{strNom}.txt")	
						@@joueur.login = strNom
						self.setTitre("#{@@joueur.login} - Profil")
						end
					end
				end
				@lblErreur.name = 'lblInfo'
				@lblErreur.text = "Modifications enregistrées !"
			end
		end
		btnSauvegarde
	end

	# Initie @champScores et génère une liste des scores
	# - return self
	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		refreshChampScore(:aventure)
		self
	end


	# Crée un CustomButton permettant de trier la liste des scores
	# - label : contenu du CustomButton
	# - sortCriteria : symbole de la méthode de tri (@see HudProfil#refreshChampScore)
	# - return un CustomButton sans relief
	def initBoutonTri(label, sortCriteria)
		sortDown=true
		btn=CustomButton.new(label) do
			sortDown=!sortDown
			refreshChampScore(@mode, sortCriteria, sortDown)
		end
		btn
	end



end
