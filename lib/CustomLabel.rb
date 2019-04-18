# Wrapper simplifiant la création d'un label
class CustomLabel < Gtk::Label
	def initialize(str="", nom="label")
		super(str)
		self.style_context.add_provider(Stylizable::getStyle, Gtk::StyleProvider::PRIORITY_APPLICATION)
		self.name=nom
	end

protected
	attr_accessor :couleur, :size, :weight

end
