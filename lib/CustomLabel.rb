# Gtk::Label de couleur parametrable (par défaut noire), gras et de taille plus importante que les Gtk::Label de base
class CustomLabel < Gtk::Label
	def initialize(str, couleur="black")
		super(str)
		@couleur = couleur
		set_markup("<span foreground='" + @couleur + "' weight= 'bold' size='x-large' >"+str+"</span>")
	end

	# Modifie le texte du label
	def set_text(str)
		super(str)
		set_markup("<span foreground='" + @couleur + "' weight= 'bold' size='x-large' >"+str+"</span>")
	end

	# Modifie la couleur du label
	def set_color(c)
		@couleur = c
		set_markup("<span foreground='" + @couleur + "' weight= 'bold' size='x-large' >"+self.text+"</span>")
	end
end
