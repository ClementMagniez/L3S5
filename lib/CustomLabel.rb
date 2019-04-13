class CustomLabel < Gtk::Label
	def initialize(str, couleur="black")
		super(str)
		@couleur = couleur
		set_markup("<span foreground='" + @couleur + "' weight= 'bold' size='x-large' >"+str+"</span>")
	end

	def set_text(str)
		super(str)
		set_markup("<span foreground='" + @couleur + "' weight= 'bold' size='x-large' >"+str+"</span>")
	end
end
