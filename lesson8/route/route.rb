class Route
  include InstanceCounter
  include ObjectValidation

  attr_reader :id, :waypoints, :start, :finish

  @list = {}

  def initialize(id, start, finish)
    @id = id
    @start = start
    @finish = finish
    validate!
    @waypoints = [start, finish]
    self.class.list[id] = self
    register_instances
  end

  class << self
    attr_reader :list
  end

  def add(station)
    waypoints.insert(-2, station)
    "Станция \'#{station.name}\' успешно добавлена в маршрут."
  end

  def delete(station)
    waypoints.delete(station)
    "Станция \'#{station.name}\' успешно удалена из маршрута."
  end

  def list
    waypoints.each { |station| "#{station.name} " }
  end

  # private

  def validate!
    raise ArgumentError, 'Начальный пункт маршрута не является станцией. Маршрут не создан.' unless start.is_a? Station
    raise ArgumentError, 'Конечный пункт маршрута не является станцией. Маршрут не создан.' unless finish.is_a? Station
    true
  end
end
