##
# @title CreateGrilles
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère la création de la table *Grille*, qui contient les informations des joueurs de l'application.
#
require "active_record"

class CreateGrilles < ActiveRecord::Migration[5.0]
  def change
    create_table :grilles do |c|
      c.string :taille
      c.string :difficulte
    end
  end
end
