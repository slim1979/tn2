class Station

  @@possible_stations = []
  def initialize(name)
    @name = name
    @@possible_stations << @name
  end

  def trains
    @trains
  end
end

class Routes

end

class Train < Routes

  def initialize(name)
    @name = name
  end

  def move
    @station
  end

  def station
    @station
  end
end

# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
