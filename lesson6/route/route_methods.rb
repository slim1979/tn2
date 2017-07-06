module RouteMethods
  def pre_create_route_actions
    print 'Введите начальную точку маршрута: '
    start = gets.strip.chomp
    print 'Введите конечную точку маршрута: '
    finish = gets.strip.chomp
    create_route(start, finish)
  end

  def create_route(start, finish)
    stations = @stations.map(&:name)
    if stations.include?(start) && stations.include?(finish)
      @routes << Route.new(@routes.empty? ? 1 : @routes[-1].id + 1, start, finish)
      @routes[-1].waypoints
    elsif !stations.include?(start)
      'Начальная точка маршрута не существует!'
    elsif !stations.include?(finish)
      'Конечная точка маршрута не существует!'
    end
  end

  def route_and_waypoints
    index = @routes.size
    index.times do |route_index|
      print "Маршрут #{route_index + 1} --> "
      puts @routes[route_index].waypoints.to_s
    end
  end

  def pre_edit_route
    puts 'Доступные маршруты: '
    route_and_waypoints
    print 'Введите номер маршрута: '
    id = gets.to_i
    if @routes.map(&:id).include?(id)
      edit_route(id)
    else
      didnt_understand_you
    end
  end

  def edit_route(id)
    print 'Вы хотите (д)обавить станцию или (у)далить?: '
    answer = gets.strip.chomp.downcase
    add_stations_to_route(id)      if %w[д l].include?(answer)
    delete_stations_from_route(id) if %w[у e].include?(answer)
    didnt_understand_you
  end

  def no_such_station_try_again(id, station)
    puts "Станция #{station} недоступна для добавления. Попробуете еще раз? (д/н): "
    answer = gets.strip.chomp.downcase
    %w[д l].include?(answer) ? add_stations_to_route(id) : 'Ввод отменен пользователем'
  end

  def add_stations_to_route(id)
    index = routes_index(id)
    route = @routes[index]
    available_stations = @stations.map(&:name) - route.waypoints
    if available_stations.empty?
      'Доступных для добавления в этот маршрут станций нет. Выберите другой маршрут или создайте станции.'
    else
      print 'Доступные станции: '
      available_stations.each { |station| print "\'#{station}\' " }
      puts
      print 'Введите название станции, которую хотите добавить в маршрут: '
      station = gets.strip.chomp
      if available_stations.include?(station)
        route.add(station)
        "Станция \'#{station}\' успешно добавлена в маршрут."
      else
        no_such_station_try_again(id, station)
      end
    end
  end

  def delete_stations_from_route(id)
    index = routes_index(id)
    route = @routes[index]
    print 'В маршруте есть следующие станции: '
    route.waypoints.each { |waypoint| print "#{waypoint} " }
    puts
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp
    if route.waypoints.include?(station)
      route.delete(station)
      "Станция \'#{station}\' успешно удалена из маршрута."
    else
      no_such_station_try_again
    end
  end

  def routes_index(id)
    @routes.map(&:id).index id
  end
end
