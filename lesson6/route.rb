class Route
  include InstanceCounter
  include ObjectValidation

  attr_reader :id, :waypoints

  ROUTE_WAYPOINT_FORMAT = Station::TITLE_FORMAT

  def initialize(id, start_point, end_point)
    @id = id
    @waypoints = [start_point, end_point]
    register_instances
    validate!
  end

  def add(station)
    @waypoints.insert(-2, station)
  end

  def delete(station)
    if @waypoints.include? station
      @waypoints.delete(station)
    else
      "Станции \'#{station}\' не существует на этом маршруте."
    end
  end

  def list
    @waypoints.each { |station| "#{station} " }
  end

  private

  def validate!
    raise ArgumentError, 'Проверьте правильность ввода начальной точки - не менее 3 букв' if @waypoints[0] !~ ROUTE_WAYPOINT_FORMAT
    raise ArgumentError, 'Проверьте правильность ввода конечной точки - не менее 3 букв' if @waypoints[-1] !~ ROUTE_WAYPOINT_FORMAT
    true
  end
end
