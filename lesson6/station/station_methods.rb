module StationMethods
  def create_station(name)
    if @stations.map(&:name).include?(name)
      'Станция уже существует. Отмена'
    else
      @stations << Station.new(name)
      "Станция #{name} успешно создана!"
    end
  end

  def available_stations
    puts 'Доступные станции: '
    if @stations.empty?
      'Список станций пуст. Для начала создайте станцию.'
    else
      @stations.map(&:name)
    end
  end

  def trains_list_on_station
    print 'Выберите станцию, для которой хотите просмотреть список поездов: '
    name = gets.strip.chomp
    index = stations_index(name)
    if index.nil?
      didnt_understand_you
    else
      station = @stations[index]
      puts "Поезда на станции #{station.name}:"
      station.trains.each { |train| "Поезд #{train.id}, тип: #{train.type}, вагоны: #{train.vans.count} " }
    end
  end

  def stations_index(name)
    @stations.map(&:name).index name
  end
end
