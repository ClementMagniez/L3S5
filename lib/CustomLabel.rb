# Wrapper simplifiant la création d'un label
class CustomLabel < Gtk::Label
	def initialize(str="", nom="label")
		super(str)
		Stylizable::setStyle(self)
		self.name=nom
	end

protected
	attr_accessor :couleur, :size, :weight

end
