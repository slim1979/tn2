# class Station
class Station
  @@all_stations = {}

  def initialize(station)
    @@all_stations[station] = {}
    @@all_stations[station]['trains'] = []
  end

  def all_stations
    puts 'На данный момент доступны следующие станции:'
    @@all_stations.each { |station, _trains| print "**#{station}** " }
    puts
  end

  def all
    @@all_stations.key
  end

  def check(station)
    @@all_stations.key? station
  end

  def has_train?(station)
    !@@all_stations[station]['trains'].empty?
  end

  def train_arrival(station, train)
    @@all_stations[station]['trains'] << train
    puts "#{station} has #{@@all_stations[station]['trains'].length} trains."
  end

  def train_departure(station, train)
    @@all_stations[station]['trains'].delete train
  end

  def all_stations_trains
    @@all_stations.each do |station, depo|
      puts "#{station} --> #{depo}" unless depo['trains'].empty?
    end
  end

  def trains_kind(station)

  end
end

# class Route
class Route
  @@all_routes = {}
  @@route_counter = 0

  def initialize(route, start_point, end_point)
    @@route_counter += 1
    route.nil? || route.empty? ? route = "route#{@@route_counter}" : route
    @@all_routes[route] = start_point, end_point
  end

  def all
    @@all_routes
  end

  def add(route, waypoint)
    @@all_routes[route].insert(-2, waypoint)
  end

  def delete(route, waypoint)
    @@all_routes[route].delete(waypoint)
  end

  def list(route)
    @@all_routes[route].each_with_index do |waypoint, i|
      i == 0 ? (puts waypoint) : (puts "#{i}.#{waypoint}")
    end
  end

  def choose(route)
    @@all_routes[route]
  end
end

# class Train
class Train
  @@trains = {}
  @@current_move = 0
  # счетчик общего кол-ва шагов поезда.
  # нужен, по сути, только в одном месте.
  @@global_move = {}

  def initialize(train, type, vans)
    @@trains[train] = {}
    @@trains[train]['type'] = type
    @@trains[train]['vans'] = vans
    @@trains[train]['status'] = 'stopped'
    @@trains[train]['speed'] = 0
    @@global_move[train] = 0
  end

  def go(train, speed)
    if @@trains[train]['status'] == 'moving'
      'Already moving'
    else
      @@trains[train]['status'] = 'moving'
      @@trains[train]['speed'] = speed
    end
  end

  def stop(train)
    if @@trains[train]['status'] == 'stopped'
      'Already stopped'
    else
      @@trains[train]['status'] = 'stopped'
      @@trains[train]['speed'] = 0
    end
  end

  def increase_speed(train, speed)
    @@trains[train]['status'] == 'stopped' ? 'Launch your train first' : @@trains[train]['speed'] += speed
  end

  def decrease_speed(train, speed)
    (@@trains[train]['speed'] -= speed) < 0 ? 'Too much decrease, try again' : @@trains[train]['speed'] -= speed
  end

  def increase_vans(train, vans)
    @@trains[train]['status'] == 'moving' ? 'Stop your train first' : @@trains[train]['vans'] += vans
  end

  def decrease_vans(train, vans)
    @@trains[train]['status'] == 'moving' ? 'Stop your train first' : @@trains[train]['vans'] -= vans
  end

  def move_forward(train)
    if @@trains[train]['status'] == 'stopped'
      'Launch your train first'
    else
      # puts "Now in #{@@trains[train]['route'][@@current_move]}"
      @@current_move += 1
      @@global_move[train] += 1
      # для того, чтобы наш паровоз гонял по кругу, обнуляем счетчик на конечной и разворачиваем маршрут
      @@trains[train]['route'].reverse! && @@current_move = 0 if @@current_move == @@trains[train]['route'].length
      # puts "Moving to: #{@@trains[train]['route'][@@current_move]}"
      @@trains[train]['route'][@@current_move]
    end
  end

  def move_backward(train)
    if @@trains[train]['status'] == 'stopped'
      'Launch your train first'
    else
      # puts "Now in #{@@trains[train]['route'][@@current_move]}"
      @@current_move -= 1
      @@global_move[train] += 1
      @@trains[train]['route'].reverse! && @@current_move = 0 if @@current_move == @@trains[train]['route'].length
      # puts "Moving to: #{@@trains[train]['route'][@@current_move]}"
      @@trains[train]['route'][@@current_move]
    end
  end

  def info(train)
    puts "Train##{train}, status: #{@@trains[train]['status']}, speed: #{@@trains[train]['speed']}"
    puts "route: #{@@trains[train]['route']}, vans: #{@@trains[train]['vans']}, type: #{@@trains[train]['type']}"
  end

  def all
    @@trains
  end

  def global(train)
    @@global_move[train]
  end

  def route(train, route)
    @@trains[train]['route'] = route
  end

  def now(train)
    @@trains[train]['route'][@@current_move]
  end

  def position(train)
    if @@trains[train]['route']
      current_st = @@current_move
      next_st = @@current_move + 1
      # если @@global_move = 0, то поезд новый и предыдущей станции у него нет
      if @@global_move[train].zero?
        puts "Current station: #{@@trains[train]['route'][current_st]},
              next station: #{@@trains[train]['route'][next_st]}"
      else
        prev_st = @@current_move - 1
        puts "Current station: #{@@trains[train]['route'][current_st]},
              previous station: #{@@trains[train]['route'][prev_st]},
              next station: #{@@trains[train]['route'][next_st]}"
      end
    else
      'Your train has no route yet'
    end
  end
end

def create_world
  i = 0
  7.times do
    arr = ('a'..'z').to_a
    @station = Station.new arr[i] * 3
    i += 1
  end

  train = 12
  type = 'pass'
  vans = 20

  @train = Train.new(train, type, vans)
  @route = Route.new('', 'aaa', 'ggg')
  @route.add('route1', 'bbb')
  @route.add('route1', 'ccc')
  @route.add('route1', 'eee')
  @route.add('route1', 'fff')
end

def assignment_route(train, route)
  @train.route(train, @route.choose(route))
  @station.train_arrival(@train.now(train), train)
end

def move_train(train)
  @train.go(train, 1000)
  puts '1.Forward, 2.Backward (f/b)'
  move = gets.chomp
  if move == 'f'
    @station.train_departure(@train.now(train), train)
    @station.train_arrival(@train.move_forward(train), train)
  elsif move == 'b'
    @station.train_departure(@train.now(train), train)
    @station.train_arrival(@train.move_backward(train), train)
  else
    puts "Try again, #{move}"
  end
end

def station_move_train(station, train)
  if @station.has_train?(station)
    move_train(train)
  else
    puts 'Station has no trains yet'
  end
end

puts 'Create world? y/n'
create = gets.chomp

if create == 'y'
  create_world
else
  puts 'Come at wish'
end
