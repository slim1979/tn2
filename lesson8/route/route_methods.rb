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

  def station_name_is_not_exist(start, finish)
    if Station.list[start].nil?
      puts "Станции с названием #{start} не существует. Маршрут не создан."
    elsif Station.list[finish].nil?
      puts "Станции с названием #{finish} не существует. Маршрут не создан."
    end
  end

  def create_route(start, finish)
    new_route_id ||= 1
    new_route_id += 1
    Route.new(new_route_id, Station.list[start], Station.list[finish])
    puts "Маршрут №#{new_route_id} #{Route.list[new_route_id]} создан"
  # TypeError drops when start or finish stations is not exist
  rescue TypeError
    station_name_is_not_exist(start, finish)
  end

  def route_and_waypoints
    index = Route.list.size
    index.times do |route_index|
      puts "Маршрут #{route_index + 1} -> #{route_stations(route_index)}"
    end
  end

  def pre_edit_route
    puts 'Доступные маршруты: '
    route_and_waypoints
    print 'Введите номер маршрута: '
    id = gets.to_i
    if Route.list[id]
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
    if %w[д l].include?(answer)
      add_stations_to_route(id)
    else
      'Ввод отменен пользователем'
    end
  end

  def add_stations_to_route(id)
    route = Route.list[id]
    available_stations = @stations - route.waypoints
    if available_stations.empty?
      'Доступных для добавления в этот маршрут станций нет.'
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
    puts route_stations(id)
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp
    if Station.list[station]
      route.delete(Station.list[station])
    else
      no_such_station_try_again(id, station)
    end
  end

  def route_stations(route_index)
    Route.list[route_index].waypoints.map(&:name)
  end

  def last
    Route.list.length
  end
end
