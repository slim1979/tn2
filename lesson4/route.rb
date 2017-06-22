class Route
  def initialize(start_point, end_point)
    @route = [start_point, end_point]
  end

  def add(station)
    @route.insert(-2, station)
  end

  def delete(station)
    if @route.include? station
      @route.delete(station)
    else
      "Station #{station} is not exist in this route"
    end
  end

  def list
    @route.each_with_index do |station, i|
      puts "#{i + 1}.#{station}"
    end
  end
end
