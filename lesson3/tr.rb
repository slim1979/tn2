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
  @@all_routes = []
  @@route_counter = 0

  def initialize(start_point, end_point)
    @@all_routes[@@route_counter] = "Маршрут ##{@@route_counter+1}", start_point, end_point
    @@route_counter += 1
  end

  def all
    @@all_routes
  end

  def add(route_number, waypoint)
    @@all_routes[route_number - 1].insert(-2, waypoint)
  end

  def delete(route_number, waypoint)
    @@all_routes[route_number - 1].delete(waypoint)
  end

  def list(route_number)
    @@all_routes[route_number - 1].each_with_index do |waypoint, i|
      i == 0 ? (puts waypoint) : (puts "#{i}.#{waypoint}")
    end
  end

  def choise(route_number)
    @@all_routes[route_number - 1]
  end
end

class Train

  @@train = {}

  def initialize(number, type, vans_amount)
    @@train['number'] = number
    @@train['type'] = type
    @@train['vans_amount'] = vans_amount
  end

  def move
    @@a
  end

  def info
    @@train
  end

  def route(route)
    @@train['route'] = route
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
