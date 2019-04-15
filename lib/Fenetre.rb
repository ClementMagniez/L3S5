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
		@fullscreen = false
        self.set_resizable(true)
		self.maximize
        self.signal_connect('destroy') { Gtk.main_quit }
		self.add(HudAccueil.new(self))
		self.show_all
		Gtk.main
	end

	def changerWidget(ancien,nouveau)
		self.remove(ancien).add(nouveau)
		self.show_all
		return self
	end

	def isFullscreen?
		return @fullscreen
	end

	def fullscreen
		super
		@fullscreen = true
		return self
	end

	def unfullscreen
		super
		@fullscreen = false
		return self
	end
end
