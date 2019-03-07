require 'gtk3'
require_relative 'Hud'
require_relative 'HudAccueil'
require_relative 'HudOption'
require_relative 'HudModeDeJeu'
require_relative 'HudAventure'

class Fenetre < Gtk::Window
	def initialize
		super()
		#icone
		#nom
        #self.set_default_size(300,50)
        self.set_resizable(true) 
        self.signal_connect('destroy') { Gtk.main_quit }
        self.initAccueil
	end

	def initAccueil
		self.add(HudAccueil.new(self))
		self.show_all
		Gtk.main
	end

	def changerWidget(ancien,nouveau)
		self.remove(ancien).add(nouveau)
		self.show_all
		return self
	end

end
