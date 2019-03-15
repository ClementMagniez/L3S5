require 'time'

temps = Time.now
timer = temps.to_s.split(" ").at(1).split(":").at(1) + ":" + temps.to_s.split(" ").at(1).split(":").at(2)
puts timer
