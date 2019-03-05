class HudModeDeJeu < Gtk::Grid
	def initialize (window)
		super()
		@fenetre=window

		@btntest = Gtk::Button.new
		@btntest.set_label("Pouet")
		self.attach(@btntest,8,10,2,2)
	end




end