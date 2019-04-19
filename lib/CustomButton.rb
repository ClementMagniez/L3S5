# Gtk::Button dont le label est un CustomLabel
class CustomButton < Gtk::Button
	def initialize(str="", nom="button", labelNom="lblButton")
		super()

		Stylizable::setStyle(self)
		self.add(CustomLabel.new(str,labelNom))
		self.set_name(nom)



		if block_given?
			signal_connect("clicked") {
				yield
			}
		end
	end

	# Modifie le texte du bouton
	# - return self
	def set_text(str)
		self.child.text = str
		self
	end
	alias :text= :set_text

	# Redimensionne le texte de self puis self selon la nouvelle taille du texte
	# - return self
	def set_size(size)
		self.child.set_size(size)
		dimensions=self.child.size_request
		self.set_size_request(dimensions[0], dimensions[1])
		self
	end
	alias :size= :set_size
end
