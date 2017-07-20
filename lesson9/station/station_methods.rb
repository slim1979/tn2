module StationMethods
  private

  def create_station
    print 'Введите название новой станции: '
    name = gets.strip.chomp
    if Station.list[name]
      'Станция уже существует. Отмена'
    else
      @stations << Station.new(name)
      "Станция #{name} успешно создана!"
    end
  rescue ArgumentError => e
    puts e.to_s
  end

  def available_stations
    if Station.list.empty?
      'Список станций пуст. Для начала создайте станцию.'
    else
      puts 'Доступные станции: '
      puts Station.list.keys
    end
  end

  def trains_count
    if Station.list.empty?
      'Не было создано ни одной станции'
    else
      puts 'Станции > Поезда на станции'
      Station.list.each { |_, station| puts "#{station.name} > #{station.trains.count}" }
    end
  end

  def train_vans(train)
    train.each_van do |van|
      van_info_according_to_kind(van)
    end
  end

  def station_trains(station)
    if station.trains.count.zero?
      'На этой станции нет поездов'
    else
      station.each_train do |train|
        puts "Поезд \'#{train.id}\'-> #{train.type}, вагонов: #{train.vans.count}"
        train_vans(train)
      end
    end
  end

  def trains_list_on_station
    trains_count
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
end
