class Station

  attr_accessor :trains

  def initialize(station)
    @station = station
    @trains = []
  end

  def add(train)
    @trains << train
  end

  def delete(train)
    @trains.delete(train)
  end

  def type
    @trains.each { |train| train[type] }
  end
end

class Route
  attr_accessor :route

  def initialize(route, start_point, end_point)
    @route = route
    @route = []
    @route << start_point << end_point
  end

  def all
    @route
  end

  def add(waypoint)
    @route.insert(-2, waypoint)
  end

  def delete(route, waypoint)
    @route.delete(waypoint)
  end

  def list(route)
    @route.each_with_index do |waypoint, i|
      i.zero? ? (puts waypoint) : (puts "#{i}.#{waypoint}")
    end
  end

  def choose
    @route
  end
end

class Train
  attr_accessor :train
  @@move = 0
  def initialize(train, type, vans)
    @train = train
    @train = {}
    @train['type'] = type
    @train['vans'] = vans
    @train['route'] = {}
    @train['status'] = 'stopped'
    @train['speed'] = 0
  end

  def go(speed)
    @train['status'] = 'moving'
    @train['speed'] = speed
  end

  def stop
    @train['status'] = 'stopped'
    @train['speed'] = 0
  end

  def increase_speed(speed)
    @train['speed'] += speed
  end

  def decrease_speed(speed)
    @train['speed'] -= speed
  end

  def increase_vans(vans)
    @train['vans'] += vans
  end

  def decrease_vans(vans)
    @train['vans'] -= vans
  end

  def move_forward
    @@move += 1
    @train['route'][@@move]
  end

  def move_backward
    @@move -= 1
    @train['route'][@@move]
  end
end
