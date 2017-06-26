require_relative 'train.rb'
require_relative 'train_passenger.rb'
require_relative 'train_cargo.rb'
require_relative 'vans.rb'
require_relative 'vans_passenger.rb'
require_relative 'vans_cargo.rb'
require_relative 'station.rb'
require_relative 'route.rb'

@stations = []
@stations_titles = []

@routes = []
@route_id = 0
@routes_ids = []

@trains = []
@train_id = 0
@trains_ids = []

@vans = []
@van_id = 0
@vans_ids = []


@count = 0
while @exit != true
  # результаты действий
  @result = nil
  @count += 1

  def menu
    puts '**************** Станция ****************'
    puts '   1. Создать новую станцию'
    puts '   2. Посмотреть список созданных станций'
    puts '   3. Посмотреть список поездов на станции'
    puts '**************** Маршрут ****************'
    puts '   4. Создать маршрут'
    puts '   5. Редактировать маршрут'
    puts '**************** Вагон ****************'
    puts '   6. Создать вагон'
    puts '**************** Поезд ****************'
    puts '   7. Создать новый поезд'
    puts '   8. Добавить вагоны'
    puts '   9. Отцепить вагоны'
    puts '  10. Назначить маршрут поезду'
    puts '  11. Увеличить скорость поезда'
    puts '  12. Уменьшить скорость поезда'
    puts '  13. Остановить поезд'
    puts '  14. Переместить поезд по маршруту'
    puts '======================================='
    puts '  0. Выйти из программы'
  end

  def create_station(name)
    if @stations_titles.include? name
      @result = 'Станция уже существует. Отмена'
    else
      @stations_titles << name
      @stations << Station.new(name)
      @stations.sort_by!(&:name)
      @result = "Станция #{name} успешно создана!"
    end
  end

  def available_stations
    print 'Доступные станции: '
    if @stations_titles.empty?
      @result = 'Список станций пуст. Для начала создайте станцию.'
    else
      @stations_titles.each { |station| print "\'#{station}\' " }
    end
    puts
  end

  def pre_create_route_actions
    print 'Введите начальную точку маршрута: '
    start = gets.strip.chomp
    print 'Введите конечную точку маршрута: '
    finish = gets.strip.chomp
    create_route(start, finish)
  end

  def create_route(start, finish)
    if @stations_titles.include?(start) && @stations_titles.include?(finish)
      @routes_ids << @route_id += 1
      @routes << Route.new(@route_id, start, finish)
      @routes.sort_by!(&:id)
      @result = 'Маршрут успешно создан!'
    elsif !@stations_titles.include?(start)
      @result = 'Начальная точка маршрута не существует!'
    elsif !@stations_titles.include?(finish)
      @result = 'Конечная точка маршрута не существует!'
    end
  end

  def route_and_waypoints
    @routes.each do |route|
      print "Маршрут #{route.id}-> "
      route.waypoints.each do |point|
        print "#{point} "
      end
    end
    puts
  end

  def pre_edit_route
    puts 'Доступные маршруты: '
    route_and_waypoints
    print 'Введите номер маршрута: '
    id = gets.to_i
    if @routes_ids.include?(id)
      edit_route(id)
    else
      didnt_understand_you
    end
  end

  def edit_route(id)
    print 'Вы хотите (д)обавить станцию или (у)далить?: '
    answer = gets.strip.chomp.downcase
    if %w[д Д l L].include? answer
      add_stations_to_route(id)
    elsif %w[у У e E].include? answer
      delete_stations_from_route(id)
    else
      didnt_understand_you
    end
  end

  def no_such_station_try_again(id, station)
    puts "Станция #{station} недоступна для добавления. Попробуете еще раз? (д/н): "
    answer = gets.strip.chomp
    %w[д l].include?(answer) ? add_stations_to_route(id) : @result = 'Ввод отменен пользователем'
  end

  def add_stations_to_route(id)
    index = @routes_ids.sort.index id
    route = @routes[index]
    available_stations = @stations_titles - route.waypoints
    if available_stations.empty?
      @result = 'Доступных для добавления в этот маршрут станций нет. Выберите другой маршрут или создайте станции.'
    else
      print 'Доступные станции: '
      available_stations.each { |station| print "\'#{station}\' " }
      puts
      print 'Введите название станции, которую хотите добавить в маршрут: '
      station = gets.strip.chomp
      if available_stations.include? station
        route.add(station)
        @result = "Станция \'#{station}\' успешно добавлена в маршрут."
      else
        no_such_station_try_again(id, station)
      end
    end
  end

  def delete_stations_from_route(id)
    index = @routes_ids.sort.index id
    route = @routes[index]
    print 'В маршруте есть следующие станции: '
    route.each { |waypoint| print "#{waypoint} " }
    puts
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp
    if route.include?(station)
      route.delete(station)
      @result = "Станция \'#{station}\' успешно удалена из маршрута."
    else
      no_such_station_try_again
    end
  end

  def pre_path_assignment
    puts 'Доступные поезда: '
    @trains.each do |train|
      train.route ? (puts "Поезд #{train.id}->#{train.route} ") : (puts "Поезд #{train.id}-> маршрут не назначен ")
    end
    puts 'Доступные маршруты: '
    @routes.each { |route| puts "Маршрут #{route.id}->#{route.waypoints} " }
    puts 'Введите номер поезда и номер маршрута для него: '
    print 'Номер поезда: '
    train_id = gets.to_i
    print 'Номер маршрута: '
    route_id = gets.to_i
    if @trains_ids.include?(train_id) && @routes_ids.include?(route_id)
      path_assignment(train_id, route_id)
    else
      @result = 'Вы неверно ввели номер поезда или номер маршрута.'
    end
  end

  def path_assignment(train_id, route_id)
    index = @trains_ids.sort.index train_id
    train = @trains[index]
    index = @routes_ids.sort.index route_id
    route = @routes[index]
    train.route = route.waypoints
    index = @stations_titles.sort.index train.route.first
    station = @stations[index]
    message = station.train_arrival(train)
    @result = "Маршрут ##{route_id} успешно добавлен к поезду ##{train_id}. " + message
  end

  def create_train(type)
    if %w[п П g G].include? type
      @trains_ids << @train_id += 1
      @trains << PassengerTrain.new(@train_id)
      @result = "Пассажирский поезд под номером ##{@train_id} создан!"
    elsif %w[г Г u U].include? type
      @trains_ids << @train_id += 1
      @trains << CargoTrain.new(@train_id)
      @result = "Грузовой поезд под номером ##{@train_id} создан!"
    else
      didnt_understand_you
    end
    @trains.sort_by!(&:id)
  end

  def move_forward(id)
    index = @trains_ids.sort.index id
    train = @trains[index]
    departure = train.now_station
    @result = arrival = train.move_forward
    puts_result
    departure_arrival(train, departure, arrival)
  end

  def move_backward(id)
    index = @trains_ids.sort.index id
    train = @trains[index]
    departure = train.now_station
    @result = arrival = train.move_backward
    puts_result
    departure_arrival(train, departure, arrival)
  end

  def departure_arrival(train, departure, arrival)
    index = @stations_titles.sort.index departure
    station = @stations[index]
    @result = station.train_departure(train)
    puts_result

    index = @stations_titles.sort.index arrival
    station = @stations[index]
    @result = station.train_arrival(train)
  end

  def create_van
    puts 'Какой вагон Вы хотите создать?'
    loop do
      print '(п)ассажирский или (г)рузовой: '
      @type = gets.strip.chomp.downcase
      break unless @type.nil? || @type.empty?
    end
    loop do
      print 'Вид: '
      @kind = gets.strip.chomp
      break unless @kind.nil? || @kind.empty?
    end
    entering_to_all_vans
  end

  def entering_to_all_vans
    if %w[п g].include? @type
      @vans_ids << @van_id += 1
      @vans << PassengerVan.new(@van_id, @kind)
      @result = "Пассажиркий вагон ##{@van_id} создан."
    elsif %w[г u].include? @type
      @vans_ids << @van_id += 1
      @vans << CargoVan.new(@van_id, @kind)
      @result = "Грузовой вагон ##{@van_id} создан"
    else
      @result = 'Такого типа вагонов не существует. Попробуйте еще раз. Отмена.'
    end
  end

  def pre_add_vans
    puts 'Прицепляем новые вагоны...'
    available_trains
    puts 'Доступные вагоны:'
    @vans.each { |van| puts "##{van.number}. Тип: #{van.type}, вид: #{van.kind}. " if van.status == 'free' }
    print 'Введите номер поезда: '
    @tid = gets.to_i
    print 'Введите номер вагона: '
    @vid = gets.to_i
    add_vans(@tid, @vid)
  end

  def add_vans(train_id, van_number)
    @vans.each { |van| @van = van if van.number == van_number }
    if @trains_ids.include? train_id
      @trains.each { |train| @result = train.add_van(@van) if train.id == train_id }
    else
      no_such_train(train_id)
    end
    @result
  end

  def delete_vans
    available_trains
    print 'Введите номер поезда, у которого Вы хотите отцепить вагон: '
    @tid = gets.to_i
    if @trains_ids.include?(@tid)
      @trains.each do |train|
        if train.id == @tid && train.vans.count.zero?
          @result =  'Вагонов нет. Удалять нечего.'
        elsif train.id == @tid && !train.vans.count.zero?
        puts "Поезд ##{train.id}. Тип: #{train.type}, скорость: #{train.speed}, имеет следующие вагоны:"
        train.vans.each { |van| puts "< Вагон ##{van.number}, \'#{van.type}\', \'#{van.kind}\' >" }
        print 'Введите номер вагона для отцепления: '
        number = gets.to_i
        train.vans.each { |van| @result = train.delete_van(van) if van.number == number }
        end
      end
    end
  end

  def increase_speed(id)
    @trains.each do |train|
      next unless train.id == id
      print 'Введите скорость: '
      speed = gets.to_i
      @result = train.speed_up(speed)
    end
  end

  def decrease_speed(id)
    @trains.each do |train|
      next unless train.id == id
      print 'Введите скорость: '
      speed = gets.to_i
      @result = train.speed_down(speed)
    end
  end

  def train_stop(id)
    @trains.each { |train| @result = train.stop if train.id == id }
  end

  def available_trains
    puts 'Доступные поезда:'
    @trains.each { |train| puts "Поезд ##{train.id}. Тип: #{train.type}, вагонов: #{train.vans.count}, скорость: #{train.speed}."}
  end

  def train_choise
    available_trains
    print 'Введите номер поезда: '
    @id = gets.to_i
  end

  def didnt_understand_you
    @result = 'Ввод не распознан. Попробуйте еще раз. Отмена.'
  end

  def no_such_train(id)
    @result = "Нет такого поезда - #{id}"
  end

  def puts_result
    3.times do
      print " "*@result.length,"\r"; sleep 0.3
      print @result.to_s,"\r"; sleep 0.3
    end
    # puts @result.to_s
    puts
  end

  def fill
    if @count == 1
      create_station('aaa')
      puts_result
      create_station('bbb')
      puts_result
      create_station('ccc')
      puts_result
      create_route('aaa', 'bbb')
      puts_result
      create_train('g')
      puts_result
      pre_path_assignment
      puts_result
      increase_speed(1)
      puts_result
    end
  end

  menu
  fill

  @action = gets.to_i
  case @action
  when 1
    print 'Введите название новой станции: '
    name = gets.strip.chomp
    create_station(name)
    puts_result
  when 2
    available_stations
    puts_result
  when 3
    available_stations
    print 'Выберите станцию, для которой хотите просмотреть список поездов: '
    name = gets.strip.chomp
    if @stations_titles.include?(name)
      puts "Поезда на станции #{name}:"
      @stations.each do |station|
        next unless station.name == name
        station.trains.each { |train| puts "Поезд ##{train.id}, тип: #{train.type}, вагоны: #{train.vans.count} " }
      end
    end
    # puts_result
  when 4
    if @stations_titles.empty?
      @result = 'Список станций пуст. Создайте пару станций.'
    else
      available_stations
      pre_create_route_actions
    end
    puts_result
  when 5
    pre_edit_route
    puts_result
  when 6
    create_van
    puts_result
  when 7
    print 'Какой поезд хотите создать - (п)ассажирский или (г)рузовой?: '
    type = gets.strip.chomp.downcase
    create_train(type)
    puts_result
  when 8
    pre_add_vans
    puts_result
  when 9
    delete_vans
    puts_result
  when 10
    @choosed_route = nil
    if @routes.empty?
      @result = 'Список маршрутов пуст. Создайте маршрут.'
    else
      pre_path_assignment
    end
    puts_result
  when 11
    train_choise
    @trains_ids.include?(@id) ? increase_speed(@id) : no_such_train(@id)
    puts_result
  when 12
    train_choise
    @trains_ids.include?(@id) ? decrease_speed(@id) : no_such_train(@id)
    puts_result
  when 13
    train_choise
    @trains_ids.include?(@id) ? train_stop(@id) : no_such_train(@id)
    puts_result
  when 14
    available_trains
    print 'Введите номер поезда: '
    id = gets.to_i
    print 'Куда двигать поезд - (в)перед или (н)азад: '
    move = gets.strip.chomp
    if %w[в В d D].include? move
      move_forward(id)
    elsif %w[и И b B].include? move
      move_backward(id)
    end
    puts_result
  when 15
    @trains.each { |train| puts "#{train.id}, #{train.route}, #{train.move}"}
  when 0
    # @exit = true
    puts 'Всего хорошего! Приходите еще!'
    # break
  end
end
