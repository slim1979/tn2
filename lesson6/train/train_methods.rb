module TrainMethods
  private

  def available_trains_with_waypoints
    puts 'Нет доступных поездов. ' if @trains.empty?
    puts 'Доступные поезда: ' unless @trains.empty?
    @trains.each do |train|
      puts "Поезд #{train.id}-> #{train.route.waypoints.map(&:name)} " if train.route
      puts "Поезд #{train.id}-> маршрут не назначен " unless train.route
    end
  end

  def available_routes
    puts 'Нет доступных маршрутов. ' if @routes.empty?
    puts 'Доступные маршруты: ' unless @routes.empty?
    @routes.each_with_index do |route, route_index|
      puts "Маршрут #{route.id} -> #{route_stations(route_index)} "
    end
  end

  def exists_train_id
    print 'Введите номер поезда: '
    gets.strip.chomp
  end

  def exists_route_id
    print 'Номер маршрута: '
    gets.to_i
  end

  def path_assignment
    available_trains_with_waypoints
    available_routes
    unless @trains.empty? || @routes.empty?
      puts 'Введите номер поезда и номер маршрута для него: '
      index = trains_map_index(exists_train_id)
      train = @trains[index]

      index = routes_index(exists_route_id)
      train.route = @routes[index]

      index = stations_index(train.route.waypoints.first)
      station = @stations[index]
      message = station.train_arrival(train)

      "Маршрут ##{train.route.id} успешно добавлен к поезду #{train.id}. \n" + message
    end
  end

  def create_train_exceptions_handling
    attempt ||= 0
    puts first_step_to_create_train
  rescue ArgumentError => e
    attempt += 1
    puts_with_effects(e.to_s)
    puts "Попробуем еще раз... Попыток: #{3 - attempt}" unless attempt >= 3
    retry unless attempt >= 3
  end

  def first_step_to_create_train
    print 'Какой поезд хотите создать - (п)ассажирский или (г)рузовой?: '
    type = gets.strip.chomp.downcase
    create_passenger_train if %w[п g].include? type
    create_cargo_train if %w[г u].include? type
    raise ArgumentError, 'Проверьте правильность ввода типа поезда' unless %w[п г g u].include? type
  end

  def new_train_id_text
    puts 'Придумайте номер / идентификатор для поезда.'
    puts 'Формат - три буквы или цифры в любом порядке,'
    puts 'дефис - по желанию, и 2 буквы или цифры после дефиса.'
    print '==> '
  end

  def new_train_id
    new_train_id_text
    id = gets.strip.chomp
    not_uniq = trains_include? id
    raise ArgumentError, 'Такой поезд уже существует!' if not_uniq
    id unless not_uniq
  end

  def train_manufacturer
    puts 'Укажите производителя поезда.'
    puts 'Формат - не менее 3 букв или цифр. Сторонние символы не допускаются.'
    print '==> '
    gets.strip.chomp
  end

  def create_passenger_train
    @trains << PassengerTrain.new(new_train_id, train_manufacturer)
    puts "Пассажирский поезд #{@trains[-1].id} создан!"
  end

  def create_cargo_train
    @trains << CargoTrain.new(new_train_id, train_manufacturer)
    puts "Грузовой поезд #{@trains[-1].id} создан!"
  end

  def train_moving_vector
    print 'Куда двигать поезд - (в)перед или (н)азад: '
    gets.strip.chomp.downcase
  end

  def move_train
    id = exists_train_id
    index = trains_map_index(id)
    train = @trains[index]
    choosen_vector = train_moving_vector
    train.move_forward if %w[в d].include?(choosen_vector)
    train.move_backward if %w[н y].include?(choosen_vector)
    raise ArgumentError unless %w[в d н y].include?(choosen_vector)
  rescue TypeError
    no_such_train(id) if train.nil?
  rescue ArgumentError
    puts_with_effects 'Неправильно выбрано направление'
  end

  def pre_add_van
    puts 'Прицепляем новые вагоны...'
    available_trains
    puts 'Доступные вагоны:'
    @vans.each { |van| puts "##{van.number}. Тип: #{van.type}, вид: #{van.kind}. " if van.status == 'free' }
    print 'Введите номер поезда: '
    id = gets.to_i
    print 'Введите номер вагона: '
    number = gets.to_i
    if trains_include?(id) && @vans.map(&:number).include?(number)
      add_van(id, number)
    else
      didnt_understand_you
    end
  end

  def add_van(id, number)
    index = @vans.map(&:number).index number
    van = @vans[index]
    index = trains_map_index(id)
    train = @trains[index]
    train.add_van(van)
  end

  def pre_delete_van
    available_trains
    print 'Введите номер поезда, у которого Вы хотите отцепить вагон: '
    id = gets.to_i
    if trains_include?(id)
      index = trains_map_index(id)
      train = @trains[index]
      delete_van(train)
    else
      no_such_train
    end
  end

  def delete_van(train)
    if train.vans.count.zero?
      'Вагонов нет. Удалять нечего.'
    else
      puts "Поезд #{train.id}. Тип: #{train.type}, скорость: #{train.speed}, имеет следующие вагоны:"
      train.vans.each { |van| puts "< Вагон ##{van.number}, \'#{van.type}\', \'#{van.kind}\' >" }
      van_choise(train)
    end
  end

  def van_choise(train)
    print 'Выберите номер вагона для отцепления: '
    number = gets.to_i
    if @vans.map(&:number).include?(number)
      index = @vans.map(&:number).index number
      van = @vans[index]
      train.delete_van(van)
    else
      didnt_understand_you
    end
  end

  def change_speed(id, choise)
    index = trains_map_index(id)
    train = @trains[index]
    print 'Введите скорость: '
    speed = gets.to_i
    train.speed_up(speed) if choise == 'up'
    train.speed_down(speed) if choise == 'down'
  end

  def train_stop(id)
    @trains.each { |train| train.stop if train.id == id }
  end

  def trains_include?(id)
    @trains.map(&:id).include?(id)
  end

  def trains_map_index(id)
    @trains.map(&:id).index id
  end

  def available_trains
    puts 'Доступные поезда:'
    @trains.each do |train|
      print "Поезд #{train.id}. Тип: #{train.type}, вагонов: #{train.vans.count}, скорость: #{train.speed}.\n"
    end
  end

  def train_choise
    available_trains
    print 'Введите номер поезда: '
    @id = gets.strip.chomp
  end

  def no_such_train(id)
    "Нет такого поезда - #{id}"
  end
end
