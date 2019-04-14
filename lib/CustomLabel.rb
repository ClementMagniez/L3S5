# Gtk::Label de couleur parametrable (par défaut noire), gras et de taille plus importante que les Gtk::Label de base
class CustomLabel < Gtk::Label
	def initialize(str="", couleur="black", size="x-large", weight="bold")
		super(str)
		self.use_markup = true
		@couleur=couleur
		@size=size
		@weight=weight
		self.update
	end

	# Modifie le texte du label
	# - return self
	def set_text(str)
		super(str)
		self.update 
	end

	# Modifie la couleur du label
	# - return self
	def set_color(c)
		@couleur = c
		self.update 
	end


	# Modifie la taille du label
	# - return self
	def set_size(size)
		self.size=size
		self.update 
	end

	# Met à jour l'affichage du label
	# - return self
	def update 
		set_markup("<span foreground='"+self.couleur+"' weight='"+self.weight+"'size='"\
							 +self.size+"'>"+self.text+"</span>")
		self
	end
	
	protected
	
	attr_accessor :couleur, :size, :weight
	
end
