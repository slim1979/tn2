require_relative 'train.rb'
require_relative 'train_passenger.rb'
require_relative 'train_cargo.rb'
require_relative 'van.rb'
require_relative 'vans_passenger.rb'
require_relative 'vans_cargo.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class Game
  def initialize
    @stations = []

    @routes = []
    @route_id = 0

    @trains = []
    @train_id = 0

    @vans = []
    @van_id = 0

    @result = nil
    fill
  end

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
    choise
  end

  private

  attr_reader :trains, :stations, :routes, :vans, :result

  def choise
    print 'Выберите действие: '
    @action = gets.to_i
    case @action
    when 1
      print 'Введите название новой станции: '
      name = gets.strip.chomp
      create_station(name)
      puts_result
    when 2
      available_stations
    when 3
      available_stations
      trains_list_on_station
    when 4
      if @stations.empty?
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
      pre_add_van
      puts_result
    when 9
      pre_delete_van
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
      choise = 'up'
      @trains.map(&:id).include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
      puts_result
    when 12
      train_choise
      choise = 'down'
      @trains.map(&:id).include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
      puts_result
    when 13
      train_choise
      @trains.map(&:id).include?(@id) ? train_stop(@id) : no_such_train(@id)
      puts_result
    when 14
      available_trains
      print 'Введите номер поезда: '
      id = gets.to_i
      @trains.map(&:id).include?(id) ? where_to_move_train(id) : no_such_train(id)
      puts_result
    when 15
      @trains.each { |train| puts "#{train.id}, #{train.route}, #{train.move}" }
    when 0
      # @exit = true
      puts 'Всего хорошего! Приходите еще!'
      # break
    end
  end

  def fill
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
  end

  def create_station(name)
    if @stations.map(&:name).include?(name)
      @result = 'Станция уже существует. Отмена'
    else
      @stations << Station.new(name)
      @result = "Станция #{name} успешно создана!"
    end
  end

  def available_stations
    print 'Доступные станции: '
    if @stations.empty?
      @result = 'Список станций пуст. Для начала создайте станцию.'
    else
      @stations.map(&:name).each { |station| print "\'#{station}\' " }
    end
    puts
  end

  def trains_list_on_station
    print 'Выберите станцию, для которой хотите просмотреть список поездов: '
    name = gets.strip.chomp
    index = @stations.map(&:name).index name
    if index.nil?
      didnt_understand_you
      puts_result
    else
      station = @stations[index]
      puts "Поезда на станции #{station.name}:"
      station.trains.each { |train| puts "Поезд ##{train.id}, тип: #{train.type}, вагоны: #{train.vans.count} " }
    end
  end

  def pre_create_route_actions
    print 'Введите начальную точку маршрута: '
    start = gets.strip.chomp
    print 'Введите конечную точку маршрута: '
    finish = gets.strip.chomp
    create_route(start, finish)
  end

  def create_route(start, finish)
    if @stations.map(&:name).include?(start) && @stations.map(&:name).include?(finish)
      @route_id += 1
      @routes << Route.new(@route_id, start, finish)
      @result = 'Маршрут успешно создан!'
    elsif !@stations.map(&:name).include?(start)
      @result = 'Начальная точка маршрута не существует!'
    elsif !@stations.map(&:name).include?(finish)
      @result = 'Конечная точка маршрута не существует!'
    end
  end

  def route_and_waypoints
    @routes.each do |route|
      print "Маршрут #{route.id}-> "
      route.waypoints.each { |point| print "#{point} " }
      puts
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
    if %w[д Д l L].include?(answer)
      add_stations_to_route(id)
    elsif %w[у У e E].include?(answer)
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
    index = @routes.map(&:id).index id
    route = @routes[index]
    available_stations = @stations.map(&:name) - route.waypoints
    if available_stations.empty?
      @result = 'Доступных для добавления в этот маршрут станций нет. Выберите другой маршрут или создайте станции.'
    else
      print 'Доступные станции: '
      available_stations.each { |station| print "\'#{station}\' " }
      puts
      print 'Введите название станции, которую хотите добавить в маршрут: '
      station = gets.strip.chomp
      if available_stations.include?(station)
        route.add(station)
        @result = "Станция \'#{station}\' успешно добавлена в маршрут."
      else
        no_such_station_try_again(id, station)
      end
    end
  end

  def delete_stations_from_route(id)
    index = @routes.map(&:id).index id
    route = @routes[index]
    print 'В маршруте есть следующие станции: '
    route.waypoints.each { |waypoint| print "#{waypoint} " }
    puts
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp
    if route.waypoints.include?(station)
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

    if @trains.map(&:id).include?(train_id) && @routes.map(&:id).include?(route_id)
      path_assignment(train_id, route_id)
    else
      @result = 'Вы неверно ввели номер поезда или номер маршрута.'
    end
  end

  def path_assignment(train_id, route_id)
    index = @trains.map(&:id).index train_id
    train = @trains[index]

    index = @routes.map(&:id).index route_id
    route = @routes[index]
    train.route = route.waypoints

    index = @stations.map(&:name).index train.route.first
    station = @stations[index]
    message = station.train_arrival(train)

    @result = "Маршрут ##{route_id} успешно добавлен к поезду ##{train_id}. " + message
  end

  def create_train(type)
    if %w[п П g G].include?(type)
      @train_id += 1
      @trains << PassengerTrain.new(@train_id)
      @result = "Пассажирский поезд под номером ##{@train_id} создан!"
    elsif %w[г Г u U].include?(type)
      @train_id += 1
      @trains << CargoTrain.new(@train_id)
      @result = "Грузовой поезд под номером ##{@train_id} создан!"
    else
      didnt_understand_you
    end
  end

  def where_to_move_train(id)
    print 'Куда двигать поезд - (в)перед или (н)азад: '
    choise = gets.strip.chomp
    if %w[в В d D н Н y Y].include?(choise)
      move(id, choise)
    else
      didnt_understand_you
    end
  end

  def move(id, choise)
    index = @trains.map(&:id).index id
    train = @trains[index]
    departure = train.now_station
    arrival = train.move_forward if %w[в В d D].include?(choise)
    arrival = train.move_backward if %w[н Н y Y].include?(choise)
    departure_arrival(train, departure, arrival)
  end

  def departure_arrival(train, departure, arrival)
    index = @stations.map(&:name).index arrival
    if index.nil?
      @result = arrival
    else
      index = @stations.map(&:name).index departure
      station = @stations[index]
      @result = station.train_departure(train)
      puts_result
      index = @stations.map(&:name).index arrival
      station = @stations[index]
      @result = station.train_arrival(train)
    end
  end

  def create_van
    puts 'Какой вагон Вы хотите создать?'
    print '(п)ассажирский или (г)рузовой: '
    type = gets.strip.chomp
    print 'Вид - Спальный (СВ), Купейный (КВ): ' if %w[п П g G].include?(type)
    print 'Вид - Угольный, Зерновой, Цистерна: ' if %w[г Г u U].include?(type)
    kind = gets.strip.chomp
    entering_to_all_vans(type, kind)
  end

  def entering_to_all_vans(type, kind)
    if %w[п П g G].include?(type)
      @van_id += 1
      @vans << PassengerVan.new(@van_id, kind)
      @result = "Пассажиркий вагон ##{@van_id} создан."
    elsif %w[г Г u U].include?(type)
      @van_id += 1
      @vans << CargoVan.new(@van_id, kind)
      @result = "Грузовой вагон ##{@van_id} создан"
    else
      @result = 'Такого типа вагонов не существует. Попробуйте еще раз. Отмена.'
    end
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
    if @trains.map(&:id).include?(id) && @vans.map(&:number).include?(number)
      add_van(id, number)
    else
      didnt_understand_you
    end
  end

  def add_van(id, number)
    index = @vans.map(&:number).index number
    van = @vans[index]
    index = @trains.map(&:id).index id
    train = @trains[index]
    @result = train.add_van(van)
  end

  def pre_delete_van
    available_trains
    print 'Введите номер поезда, у которого Вы хотите отцепить вагон: '
    id = gets.to_i
    if @trains.map(&:id).include?(id)
      index = @trains.map(&:id).index id
      train = @trains[index]
      delete_van(train)
    else
      no_such_train
    end
  end

  def delete_van(train)
    if train.vans.count.zero?
      @result = 'Вагонов нет. Удалять нечего.'
    else
      puts "Поезд ##{train.id}. Тип: #{train.type}, скорость: #{train.speed}, имеет следующие вагоны:"
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
      @result = train.delete_van(van)
    else
      didnt_understand_you
    end
  end

  def change_speed(id, choise)
    index = @trains.map(&:id).index id
    train = @trains[index]
    print 'Введите скорость: '
    speed = gets.to_i
    @result = train.speed_up(speed) if choise == 'up'
    @result = train.speed_down(speed) if choise == 'down'
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

  # def puts_result
  #   puts @result
  # end

  def puts_result
    3.times do
      print ' ' * @result.length, "\r"
      sleep 0.3
      print @result.to_s, "\r"
      sleep 0.3
    end
    puts
  end
end

@game = Game.new
loop do
  @game.menu
end
