ActiveRecord::Base.establish_connection(
	:adapter	=>	"sqlite3",
	:database	=>	"maBase.sqlite3"
	:timeout	=>	5000
)