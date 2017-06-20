class Station
  def initialize(station)
    @station = station
    @trains = {}
  end

  def train_arrival(train)
    @trains[train.name] = train.type
  end

  def train_departure(train)
    @trains.delete(train)
  end

  def sort_trains_by_type
    @trains.sort_by { |_train, type| type }
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
    @route.delete(station)
  end

  def list
    @route.each_with_index do |station, i|
      puts "#{i + 1}.#{station}"
    end
  end
end

class Train
  attr_accessor :route

  def initialize(train, type, vans)
    @train = train
    @type = type
    @vans = vans
    @route = []
    @speed = 0
    @move = 0
    @global_move = 0
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
    @vans += vans if @speed.zero?
  end

  def decrease_vans(vans)
    @vans -= vans if @vans - vans >= 0 && @speed.zero?
  end

  def move_forward
    if @route.empty?
      puts 'Route not found'
    else
      @move += 1
      @route.reverse! && @move = 1 if @move == @route.length
      @route[@move]
    end
  end

  def move_backward
    if @route.empty?
      puts 'Route not found'
    else
      @move -= 1
      @route.reverse! && @move = @route.length - 2 if @move < 0
      @route[@move]
    end
  end

  def vans
    @vans
  end

  def name
    @train
  end

  def type
    @type
  end

  def location
    if @global_move < 1
      puts "Now in #{@route[@move]}"
      puts "Going to #{@route[@move + 1]}"
    else
      puts "Was in #{@route[@move - 1]}"
      puts "Now in #{@route[@move]}"
      puts "Going to #{@route[@move + 1]}"
    end
  end
end
