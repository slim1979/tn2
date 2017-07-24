# Route
class Route
  extend Accessors
  include InstanceCounter
  include ObjectValidation
  include Validation

  attr_reader :id, :waypoints, :start, :finish

  validate :start, :type, Station
  validate :finish, :type, Station

  @list = {}

  def initialize(id, start, finish)
    @id = id
    @start = start
    @finish = finish
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
end
