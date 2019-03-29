
class HudInscription < Hud
	def initialize(fenetre)
		super(fenetre)

		#label : Titre - Identifiant - Mot de passe
		@lblTitreInscr = Gtk::Label.new(" INSCRIPTION ")
		@lblId = Gtk::Label.new("Identifiant : ")
		@lblMdp = Gtk::Label.new("Mot de passe : ")
		#Entrée : Identifiat - Mot de passe
		@entId = Gtk::Entry.new
		@entMdp = Gtk::Entry.new
		#Label d'erreur
		@lblErreur = Gtk::Label.new("Bonne inscription !")

		initBoutonEnregistrement
		initBoutonRetour

		self.attach(@btnRetour,16,25,2,2)
		self.attach(@lblErreur,2,1,2,1)
		self.attach(@lblTitreInscr,2,0,2,1)
		self.attach(@lblId,2,2,1,1)
		self.attach(@entId,3,2,1,1)
		self.attach(@lblMdp,2,3,1,1)
		self.attach(@entMdp,3,3,1,1)
		self.attach(@btnEnr,2,5,1,1)
	end

	
	# Créé et initialise le bouton de retour
	def initBoutonRetour
		@btnRetour = Gtk::Button.new :label => "Retour"
		@btnRetour.signal_connect("clicked") {
			self.lancementAccueil
		}
	end

	#Créé et initialise le bouton s'enregistrer
	def initBoutonEnregistrement
		#Bouton : Enregistrer
		@btnEnr = Gtk::Button.new :label => "S'enregistrer"
		@btnEnr.signal_connect("clicked") {
		if @entMdp.text.empty? || @entId.text.empty?
			@lblErreur.set_label("Veuillez renseigner toutes les informations.")
		else
			@lblErreur.set_label("Enregistrement base de donnée à faire.")

		end
		}
	end

end
