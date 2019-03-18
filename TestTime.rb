require 'time'

class TestTime

  def convertirTempsEnEntier(temps)
    return temps.to_s.split(" ").at(1).split(":").at(1) + ":" + temps.to_s.split(" ").at(1).split(":").at(2)
  end

end

temps = Time.now
puts TestTime.convertirTempsEnEntier(temps)
