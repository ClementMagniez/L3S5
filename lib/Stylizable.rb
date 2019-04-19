module Stylizable
	def self.getStyle
		css=Gtk::CssProvider.new
		css.load(path: "../css/style.css")
		css
	end
	
	def self.setStyle(widget)
		widget.style_context.add_provider(Stylizable::getStyle, 
																			Gtk::StyleProvider::PRIORITY_APPLICATION)
		widget
	end
end
