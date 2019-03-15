##
# @title TestConnexion
# @author BUON Romane
# @version 0.1
##

require "rubygems"
require_relative "connectSqlite3.rb"
require_relative "Profil.rb"

user1 = Profil.new(
	pseudonyme: "user1",
	mdpEncrypted: "mdppassecure15".crypt("mdppassecure15")
)
user1.save

puts user1

user1.seConnecter("user1","mdppassecure15")
