# Gtk::Label de couleur parametrable (par défaut noire), gras et de taille plus importante que les Gtk::Label de base
class CustomLabel < Gtk::Label
	def initialize(str="", couleur="black", size="x-large", weight="bold", background=nil, bgalpha=nil)
		super(str)
		self.use_markup = true
		@couleur=couleur
		@size=size
		@weight=weight
		@background=background
		@bgalpha=bgalpha
		self.update
	end


	# Modifie la couleur du label
	# - return self
	def set_color(c)
		@couleur = c
		self.update
	end
	alias :color= :set_color

	# Modifie la taille du label
	# - return self
	def set_size(size)
		self.size=size
		self.update
	end

	# Modifie le texte du label
	# - return self
	def set_text(str)
		super(str)
		self.update
	end
	alias  :text= :set_text

	# Modifie le surlignage du label
	# - bg : couleur hexa du surlignage
	# - alpha : transparence du surlignage, 0 (invisible) à 100 (opaque)
	# - return self
	def set_background(bg, alpha)
		@background=bg
		@bgalpha=alpha
		self.update
	end
	alias :background= :set_background
	# Met à jour l'affichage du label
	# - return self
	def update
		background=@background ? "background='#{@background}'" : ''
		bgalpha=@bgalpha ? "bgalpha='#{@bgalpha}%'" : ''

		set_markup("<span #{background} #{bgalpha} foreground='#{self.couleur}' weight='#{self.weight}'"+"
							 size='#{self.size}'>#{self.text}</span>")
		self
	end

protected
	attr_accessor :couleur, :size, :weight

end
