module RouteMethods
  # private

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
    start_station = Station.list[start]
    finish_station = Station.list[finish]
    new_route_id = Route.list.empty? ? 1 : Route.list[last].id + 1
    @routes << Route.new(new_route_id, start_station, finish_station)
    puts "Маршрут №#{new_route_id} #{Route.list[new_route_id]} создан"
  # TypeError выбрасывается тогда, когда пользователь ввел название несуществующей станции,
  # в результате чего start_station и finish_station равны nil
  rescue TypeError
    puts "Станции с названием #{start} не существует. Маршрут не создан." if start_station.nil?
    puts "Станции с названием #{finish} не существует. Маршрут не создан." if finish_station.nil?
  end

  def route_and_waypoints
    index = Route.list.size
    index.times do |route_index|
      print "Маршрут #{route_index + 1} -> #{Route.list[route_index].waypoints.map(&:name)} \n"
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
    puts "Нет такой станции - #{station}. Попробуете еще раз? (д/н): "
    answer = gets.strip.chomp.downcase
    %w[д l].include?(answer) ? add_stations_to_route(id) : 'Ввод отменен пользователем'
  end

  def add_stations_to_route(id)
    route = Route.list[id]
    available_stations = @stations - route.waypoints
    if available_stations.empty?
      'Доступных для добавления в этот маршрут станций нет. Выберите другой маршрут или создайте станции.'
    else
      print 'Доступные станции: '
      available_stations.each { |station| print "\'#{station.name}\' " }
      puts
      print 'Введите название станции, которую хотите добавить в маршрут: '
      name = gets.strip.chomp
      if available_stations.map(&:name).include?(name)
        station = Station.list[name]
        route.add(station)
      else
        no_such_station_try_again(id, name)
      end
    end
  end

  def delete_stations_from_route(id)
    route = Route.list[id]

    puts 'В маршруте есть следующие станции: '
    puts route_waypoints_array
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp

    if Station.list[station]
      route.delete(Station.list[station])
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

  def last
    Route.list.length
  end
end
