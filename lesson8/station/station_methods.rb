module StationMethods
  # private

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
    Station.list.each { |_, station| puts "#{station.name} > #{station.trains.count}" }
  end

  def train_vans(train)
    train.each_van do |van|
      van_info_according_to_kind(van)
    end
  end

  def station_trains(station)
    station.each_train do |train|
      puts "Поезд \'#{train.id}\'-> #{train.type}, вагонов: #{train.vans.count}"
      train_vans(train)
    end
  end

  def trains_list_on_station
    print 'Выберите станцию, для которой хотите просмотреть список поездов: '
    name = gets.strip.chomp
    if Station.list[name]
      station = Station.list[name]
      puts "Поезда на станции #{name}:"
      station_trains(station)
    else
      didnt_understand_you
    end
  end

  def stations_index(station)
    @stations.index station
  end

  def stations_names(station)
    @stations.map(&:name).index station
  end
end
