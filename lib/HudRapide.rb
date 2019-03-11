class HudRapide < HudJeu
	# @btnPause
	# @timer
	
	def initialize(window,grille)
		super(window,grille)
		@btnPause = Gtk::Button.new :label => "Pause"
		@lblTime = Gtk::Label.new(" 0:0 ")
		@timer = Time.now
		@pause = false
		@horloge = 0
		@stockHorloge = 0
		self.setTitre("Partie rapide")
		self.setDesc("Ici la desc du mode rapide")


		self.initBoutonOptions
		initBoutonPause
		

		self.attach(@btnPause,5,0,2,1)
		self.attach(@lblTime,0,2,1,1)

		@t=Thread.new{timer}
	end

	def timer
		while true do
			@horloge = (Time.now - @timer) + @stockHorloge
			@lblTime.set_label((@horloge/60).to_i.to_s + ":" + (@horloge%60).to_i.to_s)
			sleep 1
		end
	end

	def initBoutonPause
		@btnPause.signal_connect('clicked'){
			if @pause
				@timer = Time.now
				@t = Thread.new{timer}
				@btnPause.set_label("Pause")
				@pause = false
			else
				@stockHorloge = @stockHorloge + (Time.now - @timer)
				@t.kill
				@btnPause.set_label("Play")
				@pause = true
			end
		}

	end


end
