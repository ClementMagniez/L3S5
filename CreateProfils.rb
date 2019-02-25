##
# @title CreateProfils
# @author KAJAK Rémi
# @version 0.1
#
# Ce fichier gère la création de la table *Profil*, qui contient les informations des joueurs de l'application.
#
require "active_record"

class CreateProfils < ActiveRecord::Migration[5.0]
  def change
    create_table :profils do |c|
      c.string :pseudonyme
      c.string :mdpEncrypted
    end
  end
end
