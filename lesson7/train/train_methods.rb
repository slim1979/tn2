module TrainMethods
  # private

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
      train = Train.find[exists_train_id]

      index = routes_index(exists_route_id)
      train.route = @routes[index]

      message = train.route.waypoints.first.train_arrival(train)

      "Маршрут ##{train.route.id} успешно добавлен к поезду #{train.id}. \n" + message
    end
  rescue TypeError => e
    puts e.to_s
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
    raise ArgumentError, 'Такой поезд уже существует!' if Train.find[id]
    id unless Train.find[id]
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

  def move_train(train)
    choosen_vector = train_moving_vector
    train.move_forward if %w[в d].include?(choosen_vector)
    train.move_backward if %w[н y].include?(choosen_vector)
    raise ArgumentError unless %w[в d н y].include?(choosen_vector)
  rescue TypeError
    no_such_train(id) if train.nil?
  rescue ArgumentError
    puts_with_effects 'Неправильно выбрано направление'
  end

  def add_van
    puts 'Прицепляем новые вагоны...'
    train = choose_train
    puts 'Доступные вагоны:'
    @vans.each { |van| puts "##{van.number}. Тип: #{van.type}, вид: #{van.kind}. " if van.status == 'free' }
    index = all_vans_map_index exists_van_number
    van = @vans[index]
    if train && van
      puts train.add_van(van)
    else
      didnt_understand_you
    end
  end

  def delete_van(train)
    if train.vans.count.zero?
      'Вагонов нет. Удалять нечего.'
    else
      puts "Поезд #{train.id}. Тип: #{train.type}, скорость: #{train.speed}, имеет следующие вагоны:"
      train.each_van { |van| puts "  < Вагон ##{van.number}, \'#{van.type}\', \'#{van.kind}\' >" }
      print 'Выберите номер вагона для отцепления: '
      index = train.vans.map(&:number).index gets.to_i
      van = train.vans[index]
      train.delete_van(van)
    end
  end

  def change_speed(train, choise)
    print 'Введите скорость: '
    speed = gets.to_i
    puts train.speed_up(speed) if choise == 'up'
    puts train.speed_down(speed) if choise == 'down'
  end

  def train_stop(train)
    train.stop
  end

  def available_trains
    puts 'Доступные поезда:'
    @trains.each do |train|
      print "Поезд #{train.id}. Тип: #{train.type}, вагонов: #{train.vans.count}, скорость: #{train.speed}.\n"
    end
  end

  def choose_train
    available_trains
    id = exists_train_id
    train = Train.find[id]
    if train.nil?
      no_such_train(id)
    elsif !block_given?
      train
    else
      yield train
    end
  end

  def no_such_train(id)
    "Нет такого поезда - #{id}"
  end
end
