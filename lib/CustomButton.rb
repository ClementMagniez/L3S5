# Gtk::Button dont le label est un CustomLabel
class CustomButton < Gtk::Button
	def initialize(str="", couleur="black", size="large", weight="bold")
		super()
		self.add(CustomLabel.new(str,couleur,size,weight))
	end

	# Modifie la couleur du bouton
	# - return self
	def set_color(c)
		label.set_color(c)
		self
	end
	alias :color= :set_color

	# Modifie le label du bouton
	# - return self
	def set_label(lbl)
		self.remove(self.child)
		self.add(lbl)
		self
	end
	alias :label= :set_label

	# Modifie le texte du bouton
	# - return self
	def set_text(str)
		self.child.text = str
		self
	end
	alias :text= :set_text
end
