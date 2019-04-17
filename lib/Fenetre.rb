require 'gtk3'

# TODO génériciser ce truc

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
	def initialize
		super()

		css=Gtk::CssProvider.new
		css.load(path: "../css/style.css")
		self.name="mainWindow"
		self.style_context.add_provider(css)
		self.set_default_size(480,270)
		self.set_resizable(false)
		self.window_position=Gtk::WindowPosition::CENTER
		self.signal_connect('destroy') { Gtk.main_quit }
		self.add(HudAccueil.new(self))
		self.show_all
		Gtk.main
	end

	def changerWidget(nouveau)
		self.remove(self.child).add(nouveau)
		self.show_all
		return self
	end
end
