module Stylizable
	def self.getStyle	
		css=Gtk::CssProvider.new
		css.load(path: "../css/style.css")
		css
	end
end
