require 'time'

class Time

  def convertirTempsEnEntier()
    return this.to_s.split(" ").at(1).split(":").at(1) + ":" + this.to_s.split(" ").at(1).split(":").at(2)
  end
end

temps = Time.now
puts temps.convertirTempsEnEntier()
