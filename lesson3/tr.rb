class Station

  @@all_stations = []
  @@station_counter = 0

  def initialize(name)
    @@all_stations << name
  end

  def all_stations
    puts 'На данный момент доступны следующие станции:'
    @@all_stations.each_with_index { |station, i| print "#{i + 1}.#{station} " }
    puts
  end

  def list
  end

  def check(station)
    @@all_stations.include? station
  end

end

# class Route
class Route
  @@all_routes = {}
  @@route_counter = 0

  def initialize(start_point, end_point)
    @@all_routes["route#{@@route_counter+1}"] =  start_point, end_point
    @@route_counter += 1
  end

  def all
    @@all_routes
  end

  def add(route_name, waypoint)
    @@all_routes[route_name].insert(-2, waypoint)
  end

  def delete(route_name, waypoint)
    @@all_routes[route_name].delete(waypoint)
  end

  def list(route_name)
    @@all_routes[route_name].each_with_index do |waypoint, i|
      i == 0 ? (puts waypoint) : (puts "#{i}.#{waypoint}")
    end
  end

  def choise(route_name)
    @@all_routes[route_name]
  end

end

class Train

  @@train = {}
  @@move = 0

  def initialize(number, type, vans_amount)
    @@train['number'] = number
    @@train['type'] = type
    @@train['vans_amount'] = vans_amount
  end

  def move
    @@move += 1
    # для того, чтобы наш паровоз гонял по кругу, обнуляем счетчик на конечной и разворачиваем маршрут
    @@train['route'].reverse! && @@move = 0 if @@move == @@train['route'].length
    puts "Moving to: #{@@train['route'][@@move]}, #{@direct}"
  end

  def info
    @@train
  end

  def route(route)
    @@train['route'] = route
    puts @@train
  end

  def current_station
    puts "Current st: #{@@train['route'][@@move]}"
  end
end

# # создаем рандомные станции, чтобы не руками.
# # руками тоже можно, кстати.
# 10.times do
#   @stations = Station.new ('a'..'z').to_a.shuffle[0..2].join
# end
#
# # создаем маршрут и проверяем, чтобы точки маршрута были реальными станциями
# puts 'Создайте маршрут движения, задав начальный и конечный пункты:'
#
# # выводим подсказку с существующими станциями
# @stations.all_stations
# print 'Начальный: '
# @a = gets.strip.chomp
# print 'Конечный: '
# @b = gets.strip.chomp
# if @stations.check(@a) && @stations.check(@b)
#   Route.new(@a, @b)
#   puts 'Маршрут создан!'
# else
#   puts 'Проверьте правильность написания станций'
# end
#
route = Route.new('1', '5')
route.add 'route1', '2'
route.add 'route1', '3'
route.add 'route1', '4'

train = Train.new(123, 'passenger', 15)
train.route(route.choise 'route1')
loop do
  train.current_station
  train.move
  gets
end
