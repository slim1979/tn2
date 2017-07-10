class Route
  include InstanceCounter
  include ObjectValidation

  attr_reader :id, :waypoints, :start, :finish

  def initialize(id, start, finish)
    @id = id
    @waypoints = [start, finish]
    validate!
    register_instances
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

  private

  def validate!
    raise ArgumentError unless waypoints[0].is_a? Station
    raise ArgumentError unless waypoints[1].is_a? Station
    true
  end
end
