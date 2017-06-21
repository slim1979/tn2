class Station
  def initialize(station)
    @station = station
    @trains = []
  end

  def train_arrival(train)
    @trains << train
    "Train #{train.id} has been arrived"
  end

  def train_departure(train)
    @trains.delete(train)
    "Train #{train.id} has been departed"
  end

  def type(type)
    @trains.count { |train| train.type == type }
  end
end

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

class Train
  attr_accessor :route
  attr_reader :vans, :type, :id

  def initialize(id, type, vans)
    @id = id
    @type = type
    @vans = vans
    @speed = 0
    @move = 0
    @was_moved = false
  end

  def increase_speed(speed)
    @speed += speed
  end

  def decrease_speed(speed)
    if @speed - speed > 0
      @speed -= speed
    else
      'Speed cant be negative'
    end
  end

  def stop
    @speed = 0
  end

  def increase_vans(vans)
    if @speed.zero?
      @vans += vans
    else
      'Stop the train first'
    end
  end

  def decrease_vans(vans)
    if @vans - vans >= 0 && @speed.zero?
      @vans -= vans
    else
      'Stop the train first or check vans amount'
    end
  end

  def move_forward
    if @route.empty?
      puts 'Route not found'
    elsif @move + 1 >= @route.length
      stop
      @move = @route.length - 1
      "reached the terminus - #{@route[@move]}"
    else
      @was_moved = true
      @move += 1
      @route[@move]
    end
  end

  def move_backward
    if @route.empty?
      puts 'Route not found'
    elsif @move - 1 < 0
      stop
      @move = 0
      "reached the terminus - #{@route[@move]}"
    else
      @move -= 1
      @route[@move]
    end
  end

  def previous_station
    if @was_moved
      @route[@move - 1]
    else
      'New train. Have no previous station'
    end
  end

  def now_station
    @route[@move]
  end

  def next_station
    @route[@move + 1]
  end
end

@train = Train.new(12, 'pass', 30)
@train2 = Train.new(124, 'pass', 25)
@train3 = Train.new(4, 'cargo', 5)
@route = Route.new('aaa', 'bbb')
@route.add('ccc2')
@route.add('ccc3')
@route.add('ccc4')
@train.route = @route.list
@station = Station.new('first')
@station.train_arrival(@train)
@station.train_arrival(@train2)
@station.train_arrival(@train3)
