
require 'gtk3'



class Builder < Gtk::Builder

	def initialize
		super()

		self.add_from_file(__FILE__.sub(".rb",".glade"))
		self.objects.each() { |p|
			unless p.builder_name.start_with?("___object")
				instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
			end
		}

		#  @windowJeu.show_all
		@windowJeu.signal_connect('destroy') { puts "Fermeture de l'application !"; Gtk.main_quit }
		# On connecte les signaux aux méthodes (qui doivent exister)
		puts "\nConnexion des signaux"
		self.connect_signals { |handler|
			puts "\tConnection du signal #{handler}"
			begin
				method(handler)
			rescue
				puts "\t\t[Attention] Vous devez definir la methode #{handler} :\n\t\t\tdef #{handler}\n\t\t\t\t....\n\t\t\t end\n"
				self.class.send( :define_method, handler.intern) {
					puts "La methode #{handler} n'est pas encore définie.. Arrêt"
					Gtk.main_quit
				}
				retry
			end
		}



	end



	def newGrille(grille,nombreLigne,nombreColonne,aide)
		#Grille de bouton
		grid = Gtk::Table.new(nombreLigne+1,nombreColonne+1,true)
		#Ajoute à une boite d'événement la grille
		@eventbGrille.add(grid)

		#liste de boutons
		listButton = Array.new()

		

		1.upto(nombreLigne) { |i|
			colonne = Gtk::Label.new(grille.tentesCol.fetch(i-1).to_s)
			#colonne.set_foreground("#4e4e9a9a0606")
			
			grid.attach(colonne,i,i+1,0,1)
			grid.attach(Gtk::Label.new(grille.tentesLigne.fetch(i-1).to_s),0,1,i,i+1)
		}

		# Changement des boutons quand on clique dessus
		0.upto(nombreLigne-1) { |i|
			0.upto(nombreColonne-1){ |j|
				
				button = Gtk::Button.new()
				button.set_relief(Gtk::ReliefStyle::NONE)
				
				listButton.push(button)
				
					button.set_image(Gtk::Image.new :file => grille[i][j].affichage)
					button.signal_connect("clicked") {
						grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)
						button.set_image(Gtk::Image.new :file => grille[i][j].affichage)
					}
				
				grid.attach(button,j+1,j+2,i+1,i+2)
			}
		}

		@btnReset.signal_connect("clicked") {

			compteur = 0
			0.upto(nombreLigne-1) { |i|
				0.upto(nombreColonne-1){ |j|

					if  not grille[i][j].estArbre

						if grille[i][j].statutVisible.isTente?
							grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)

						elsif grille[i][j].statutVisible.isGazon?
							grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)
							grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)
						end

						listButton.at(compteur).set_label(" ")
					else

						if grille[i][j].statutVisible.isArbreCoche?
							grille[i][j].cycle(i,j, grille.tentesLigne, grille.tentesCol)
							listButton.at(compteur).set_label("A")
						end

					end
					compteur = compteur +1
				}
			}

		}

		@btnAide.signal_connect("clicked") {
			@lblAide.set_label(aide.cycle)
		}

		fondecran = Gtk::Image.new :file => "ihm/img/fond2.png"
		fondgris = Gtk::Image.new :file => "ihm/img/gris.png"
		#@gridBody.attach(fondgris,0,0,1,6)
		@gridBody.attach(fondecran,0,0,1,6)

		
		@quit.signal_connect('activate') { puts "Fermeture de l'application !"; Gtk.main_quit }

		@windowJeu.fullscreen
		@windowJeu.show_all
		Gtk.main
	end
end
