module RouteMethods
  def pre_create_route_actions
    unless @stations.empty?
      print 'Введите начальную точку маршрута: '
      start = gets.strip.chomp
      print 'Введите конечную точку маршрута: '
      finish = gets.strip.chomp
      create_route(start, finish)
    end
  end

  def create_route(start, finish)
    stations_names_array = @stations.map(&:name)
    start_station = @stations[stations_names_array.index start]
    finish_station = @stations[stations_names_array.index finish]
    route_id = @routes.empty? ? 1 : @routes[-1].id + 1
    @routes << Route.new(route_id, start_station, finish_station)
    "Маршрут №#{@routes[-1].id} #{@routes[-1].waypoints.map(&:name)} создан"
  # TypeError выбрасывается тогда, когда пользователь ввел название несуществующей станции,
  # в результате чего start_station и finish_station равны nil
  rescue TypeError
    puts "Станции с названием #{start} не существует. Маршрут не создан." if start_station.nil?
    puts "Станции с названием #{finish} не существует. Маршрут не создан." if finish_station.nil?
  end

  def route_and_waypoints
    index = @routes.size
    index.times do |route_index|
      print "Маршрут #{route_index + 1} -> #{@routes[route_index].waypoints.map(&:name)} \n"
    end
  end

  def pre_edit_route
    puts 'Доступные маршруты: '
    route_and_waypoints
    print 'Введите номер маршрута: '
    id = gets.to_i
    if routes_include?(id)
      edit_route(id)
    else
      didnt_understand_you
    end
  end

  def edit_route(id)
    print 'Вы хотите (д)обавить станцию или (у)далить?: '
    answer = gets.strip.chomp.downcase
    if %w[д l].include?(answer)
      add_stations_to_route(id)
    elsif %w[у e].include?(answer)
      delete_stations_from_route(id)
    else
      didnt_understand_you
    end
  end

  def no_such_station_try_again(id, station)
    puts "Не такой станции - #{station}. Попробуете еще раз? (д/н): "
    answer = gets.strip.chomp.downcase
    %w[д l].include?(answer) ? add_stations_to_route(id) : 'Ввод отменен пользователем'
  end

  def add_stations_to_route(id)
    index = routes_index(id)
    route = @routes[index]
    available_stations = @stations.map(&:name) - route.waypoints.map(&:name)
    if available_stations.empty?
      'Доступных для добавления в этот маршрут станций нет. Выберите другой маршрут или создайте станции.'
    else
      print 'Доступные станции: '
      available_stations.each { |station| print "\'#{station}\' " }
      puts
      print 'Введите название станции, которую хотите добавить в маршрут: '
      station = gets.strip.chomp
      if available_stations.include?(station)
        index = stations_names(station)
        station = @stations[index]
        route.add(station)
      else
        no_such_station_try_again(id, station)
      end
    end
  end

  def delete_stations_from_route(id)
    index = routes_index(id)
    route = @routes[index]
    route_waypoints_array = route.waypoints.map(&:name)

    puts 'В маршруте есть следующие станции: '
    puts route_waypoints_array
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp

    if route_waypoints_array.include?(station)
      index = route_waypoints_array.index station
      station = route.waypoints[index]
      route.delete(station)
    else
      no_such_station_try_again(id, station)
    end
  end

  def routes_index(id)
    @routes.map(&:id).index id
  end

  def route_stations(route_index)
    @routes[route_index].waypoints.map(&:name)
  end

  def routes_include?(id)
    @routes.map(&:id).include?(id)
  end
end
