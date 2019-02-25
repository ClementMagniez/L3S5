##
# @title CreateScores
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère la création de la table *Score*, qui contient les informations des joueurs de l'application.
#
require "active_record"

class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |c|
      c.integer :montantScore
      c.string :modeJeu
      c.date :dateObtention
    end
  end
end
