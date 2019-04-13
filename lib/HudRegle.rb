class HudRegle < Hud
	def initialize (window)
		super(window)

		self.attach(Gtk::Label.new("Regles à definir"),0,0,1,1)
	end
end
