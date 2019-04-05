class Pile
	def initialize
		@array=[]
	end
	
	def push(elt)
		self.array.push(elt)
		self
	end
	
	def pop
		elt= self.array.pop()
		return elt
	end

	def isEmpty?
		return self.array.empty?
	end
	
	def clear
		self.array.clear
	end
	
	
	protected
		attr_accessor :array
end
