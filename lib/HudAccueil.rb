
require "rubygems"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"
require_relative "Connexion.rb"

class HudAccueil < Hud
	# @btnConnecter
	# @btnInscrire
	# @btnQuitter
	# @entryIdentifiant
	# @entryMotDePasse
	# @lblErreur
	# @session

	def initialize(window)
		super(window)
		varX, varY = 0, 0
		@entryIdentifiant = Gtk::Entry.new
		@entryMotDePasse = Gtk::Entry.new

		# TODO TEMPORAIRE - confort de tests
		@entryIdentifiant.text="test"
		@entryMotDePasse.text="test"
		####################################

		initBoutonConnecter
		initBoutonInscription
		initBoutonQuitter

		# Rend le mot de passe entré invisible
		@entryMotDePasse.set_visibility(false)

		@lblErreur = Gtk::Label.new("Connectez-vous !")

		self.attach(@lblErreur, varX+2, varY-1, 1, 1)

		self.attach(Gtk::Label.new("Identifiant : "),varX+1, varY+1, 1, 1)
		self.attach(@entryIdentifiant,varX+2, varY+1, 1, 1)

		self.attach(Gtk::Label.new("Mot de passe : "),varX+1, varY+2, 1, 1)
		self.attach(@entryMotDePasse,varX+2, varY+2, 1, 1)

		self.attach(@btnInscrire,varX+1, varY+3, 1, 1)
		self.attach(@btnConnecter,varX+2, varY+3, 1, 1)

#		self.attach(@btnOptions, varX, varY+4, 1, 1)
		self.attach(@btnQuitter,varX+3, varY+4, 1, 1)

		ajoutFondEcran
	end


	def initBoutonConnecter
		@btnConnecter = Gtk::Button.new :label => "Se connecter"
		@btnConnecter.signal_connect("clicked") {
			# Vérification de l'existence du profil dans la BDD
			@session = Connexion.new()

			if @entryIdentifiant.text.empty? || @entryMotDePasse.text.empty?
				@lblErreur.set_label("Veuillez renseigner tous les champs.")
			elsif(@session.seConnecter(@entryIdentifiant.text(), @entryMotDePasse.text()) == -1)
				@lblErreur.set_label("Identifiant ou mot de passe incorrect.")
			else
				#$login = @session.seConnecter(@entryIdentifiant.text(), @entryMotDePasse.text())
				$login = @entryIdentifiant.text
				@@name=@entryIdentifiant.text
				f=IniFile.load("../config/#{@@name}.ini", encoding: 'UTF-8')
				@@winX=f['resolution']['width']
				@@winY=f['resolution']['height']
				self.resizeWindow(@@winX, @@winY)
				self.lancementModeJeu
			end
		}
	end

	def initBoutonInscription
		@btnInscrire = Gtk::Button.new :label => "S'inscrire"
		@btnInscrire.signal_connect('clicked'){
			self.lancementInscription
		}
	end
end
