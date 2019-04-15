class CustomEventBox < Gtk::EventBox
	# Replace le widget actuel de l'event box par un nouveau
	# 	retourne self
	def replace(wdgt)
		self.remove(self.child)
		self.add(wdgt)
		self.show_all
		self
	end
end
