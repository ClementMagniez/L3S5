# Cette classe fait à peu près les mêmes choses que HudInscription
require 'inifile'
require "rubygems"
require "digest/sha1"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"

class HudProfil < Hud
	def initialize
		super()
		self.setTitre("#{@@joueur.login} - Profil")
		@lblErreur = CustomLabel.new
		@lblErreur.color = 'red'
		entNom = Gtk::Entry.new
		entMdp = Gtk::Entry.new
		entMdp.set_visibility(false)
		@@joueur.mode = :aventure
		@sortCriteria= :montantScore
		@sortDown=true

		initBoutonRetour

		initBoutonsChampScore
		initChampScore
#		initBoutonsTriScore
		@champScores.set_min_content_height(150)

		vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
		vBox.add(@lblErreur)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Nouveau nom"))
			hBox.add(entNom)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(CustomLabel.new("Nouveau mot de passe"))
			hBox.add(entMdp)
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true
			hBox.add(@btnAventure)
			hBox.add(@btnExploration)
			hBox.add(@btnChrono)
		vBox.add(initBoutonSauvegarderLogin(entNom, entMdp))
		vBox.add(CustomLabel.new("Vos scores"))
		vBox.add(hBox)
			hBox = Gtk::Box.new(Gtk::Orientation::HORIZONTAL)
			hBox.homogeneous = true


			hBox.add(initBoutonTri("Score", :montantScore))
			hBox.add(initBoutonTri("Date", :dateObtention))
		vBox.add(hBox)
		vBox.add(@champScores)
		vBox.add(@btnRetour)
		vBox.valign = Gtk::Align::CENTER
		vBox.halign = Gtk::Align::CENTER

		self.attach(vBox, 0, 0, 1, 1)

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
	def refreshChampScore(sortCriteria=:montantScore, sortDown=true)
		@champScores.remove(@champScores.child)		 if @champScores.child != nil
		listeScores = @@joueur.rechercherScores(@@joueur.mode.to_s)

		# trie la liste en ordre ascendant selon le critère donné
		arr = listeScores.sort do |a, b|
				a.send(sortCriteria) <=> b.send(sortCriteria)
		end
		# inverse si on la veut descendante
		arr.reverse! if sortDown

		unless listeScores.empty?
			boxChamp = Gtk::Box.new(Gtk::Orientation::VERTICAL)
			arr.each do |score|
				# /!\ Le whitespace ASCII typique n'est apparemment pas reconnu par
				# rjust ; il s'agit ici d'un whitespace U+2000, à ne pas remplacer
				# naïvement
				boxChamp.add(CustomLabel.new("#{score.montantScore.to_s.rjust(4,' ')}"+" "*25	+
																		 "#{score.dateObtention}"))
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
			@@joueur.mode = :aventure
			refreshChampScore
		end

		@btnExploration = CustomButton.new("Exploration") do
			@@joueur.mode = :explo
			refreshChampScore
		end

		@btnChrono = CustomButton.new("Contre-la-montre") do
			@@joueur.mode = :rapide
			refreshChampScore
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
			@lblErreur.color = 'red'
			if strNom != entNom.text
				@lblErreur.text = "Caractères autorisés :\nmajuscules, minuscules, nombres, -, _, espace"
			elsif strNom.length > 32
				@lblErr.text = "Identifiant trop long (> 32) !"
			elsif(strNom.empty? && strMdp.empty?)
				@lblErreur.text = "Vous devez remplir au moins un champ !"
			else
				user = Profil.find_by(pseudonyme: @@joueur.login)
				unless strMdp.empty?
					# Enregistrement du mot de passe crypté
					user.mdpEncrypted = strMdp.crypt(strMdp)
					user.save
				end
				unless strNom.empty?
					# Enregistrement du pseudo
					# Si l'identifiant est déjà présent dans la base de données
					if Profil.find_by(pseudonyme: strNom) != nil
						@lblErreur.text="Cet identifiant existe déjà."
					else
						user.pseudonyme = strNom
						user.save
						File.rename("../config/#{@@joueur.login}.ini", "../config/#{strNom}.ini")
						File.rename("../saves/#{@@joueur.login}.txt", "../saves/#{strNom}.txt")		if File.exist?("../saves/#{@@joueur.login}.txt")
						@@joueur.login = strNom
						self.setTitre("#{@@joueur.login} - Profil")
					end
				end
				@lblErreur.color = 'green'
				@lblErreur.text = "Modifications enregistrées !"
			end
		end
		btnSauvegarde
	end

	# Initie @champScores et génère une liste des scores
	# - return self
	def initChampScore
		@champScores = Gtk::ScrolledWindow.new
		refreshChampScore
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
			refreshChampScore(sortCriteria, sortDown)
		end
		btn.set_relief(Gtk::ReliefStyle::NONE)
		btn
	end



end
