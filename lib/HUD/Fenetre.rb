require 'gtk3'

require_relative 'Hud'
require_relative 'HudAccueil'
require_relative 'HudOption'
require_relative 'HudJeu'
require_relative 'HudModeDeJeu'
require_relative 'HudAventure'
require_relative 'HudRapide'
require_relative "HudInscription"
require_relative 'HudTutoriel'
require_relative 'HudFinDeJeu'
require_relative 'HudProfil'
require_relative 'HudExploration'
require_relative 'HudChoixDifficulte'
require_relative 'HudPresentationTutoriel'
require_relative 'HudRegle'

class Fenetre < Gtk::Window

	# Return une instance de Fenetre 480*270 centrée, exécutant Fenetre#update
	# au déplacement/redimensionnement
	def initialize
		super()
		self.name="mainWindow"
		self.set_default_size(480,270)
		self.window_position=Gtk::WindowPosition::CENTER
		self.icon="../img/tente.png"
		css=Gtk::CssProvider.new
		css.load(path: "../css/style.css")
		Gtk::StyleContext::add_provider_for_screen(Gdk::Screen.default,css,
																		Gtk::StyleProvider::PRIORITY_APPLICATION)

		self.updateData
		self.signal_connect('configure-event') {
			self.updateData
			false # exécute le handler par défaut
		}


		self.add(HudAccueil.new(self))
		self.show_all
		Gtk.main
	end

	# Une HudWindow ne comporte qu'un widget direct : changerWidget remplace le 
	# widget actuel par _nouveau_ et l'affiche
	# - nouveau : un Gtk::Widget à afficher dans self
	# - return self
	def changerWidget(nouveau)
		self.remove(self.child).add(nouveau)
		self.show_all
		self
	end

	# Wrapper de Gtk.main_quit ; enregistre les données utiles (position/taille
	# de la fenêtre) dans le fichier .ini _config_
	# - config : un Config initialisé
	# - return self
	def exit(config)
		self.updateConfig(config)
		Gtk.main_quit
		self
	end

	# - width : largeur de la fenêtre, équivalente à self.size[0]
	# - height : hauteur de la fenêtre, équivalente à self.size[1]
	attr_reader :width, :height

	def updateConfig(config)
		unless config==nil
			config.writeResolution(@width, @height)
			config.writePosition(@x, @y)
		end
		self
	end

	# Met à jour @width, @height, @x, @y selon les coordonnées de la fenêtre
	# - return self
	def updateData
		@width, @height=self.size
		@x, @y=self.position
		self
	end

end
