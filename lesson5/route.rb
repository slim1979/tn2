class Route
  attr_reader :id, :waypoints

  def initialize(id, start_point, end_point)
    @id = id
    @waypoints = [start_point, end_point]
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
    @waypoints.each_with_index do |station, i|
      print "#{i + 1}.#{station} "
    end
  end
end
