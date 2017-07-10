module StationMethods
  def create_station
    print 'Введите название новой станции: '
    name = gets.strip.chomp
    if @stations.map(&:name).include?(name)
      'Станция уже существует. Отмена'
    else
      @stations << Station.new(name)
      "Станция #{name} успешно создана!"
    end
  rescue ArgumentError => e
    puts e.to_s
  end

  def available_stations
    if @stations.empty?
      'Список станций пуст. Для начала создайте станцию.'
    else
      puts 'Доступные станции: '
      puts @stations.map(&:name)
    end
  end

  def trains_count
    puts 'Станции > Поезда на станции'
    @stations.each { |station| puts "#{station.name} > #{station.trains.count}" }
  end

  def trains_list_on_station
    print 'Выберите станцию, для которой хотите просмотреть список поездов: '
    station = gets.strip.chomp
    index = stations_names(station)
    if index.nil?
      didnt_understand_you
    else
      station = @stations[index]
      puts "Поезда на станции #{station.name}:"
      station.trains.each { |train| puts "Поезд #{train.id}, тип: #{train.type}, вагоны: #{train.vans.count} " }
    end
  end

  def stations_index(station)
    @stations.index station
  end

  def stations_names(station)
    @stations.map(&:name).index station
  end
end
