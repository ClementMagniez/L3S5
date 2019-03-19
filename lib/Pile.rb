class Pile
	def initialize
		@array=[]
	end
	
	def push(elt)
		self.array.push(elt)
		self
	end
	
	def pop
		self.array.pop(elt)
	end
	
	
	protected
		attr_accessor :array
end
