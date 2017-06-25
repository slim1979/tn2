require_relative 'train.rb'
require_relative 'train_passenger.rb'
require_relative 'train_cargo.rb'
require_relative 'vans.rb'
require_relative 'vans_passenger.rb'
require_relative 'vans_cargo.rb'
require_relative 'station.rb'
require_relative 'route.rb'

@stations = []
@exists_stations_titles = []

@routes = []
@route_id = 0
@routes_ids = []

@trains = []
@train_id = 0
@trains_ids = []

@vans = []
@van_id = 0
@vans_ids = []

# результаты действий
@result = nil

while @exit != true
  puts
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
  puts '  13. Уменьшить скорость поезда'
  puts '  14. Переместить поезд по маршруту'
  puts '======================================='
  puts '  0. Выйти из программы'

  def create_station(name)
    if @exists_stations_titles.include? name
      @result = 'Станция уже существует. Отмена'
    else
      @exists_stations_titles << name
      @stations << Station.new(name)
      @result = "Станция #{name.capitalize} успешно создана!"
    end
  end

  def available_stations
    print 'Доступные станции: '
    if @exists_stations_titles.empty?
      print 'Список станций пуст. Для начала создайте станцию.'
    else
      @exists_stations_titles.each { |station| print station + ' ' }
    end
    puts
  end

  def pre_create_route_actions
    available_stations
    print 'Введите начальную точку маршрута: '
    start = gets.strip.chomp
    print 'Введите конечную точку маршрута: '
    finish = gets.strip.chomp
    create_route(start, finish)
  end

  def create_route(start, finish)
    if @exists_stations_titles.include?(start) && @exists_stations_titles.include?(finish)
      @routes_ids << @route_id += 1
      @routes << Route.new(@route_id, start, finish)
      @result = 'Маршрут успешно создан!'
    elsif !@exists_stations_titles.include? start
      @result = 'Начальная точка маршрута не существует!'
    elsif !@exists_stations_titles.include?(finish)
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

  def no_such_station_try_again
    puts "Нет такой станции - #{station}. Попробуете еще раз? (д/н): "
    answer = gets.strip.chomp.downcase
    %w[д l].include?(answer) ? add_stations_to_route(id) : @result = "Нет такой станции - #{station}"
  end

  def add_stations_to_route(id)
    @routes.each { |route| @current_route = route.waypoints if route.id == id }
    available_stations = @exists_stations_titles - @current_route
    print 'Доступные станции: '
    available_stations.each{ |station| print "#{station} " }
    puts
    print 'Введите название станции, которую хотите добавить в маршрут: '
    station = gets.strip.chomp.downcase
    if @exists_stations_titles.include?(station)
      @routes.each { |route| route.add(station) if route.id == id }
      @result = "Станция \'#{station}\' успешно добавлена в маршрут."
    else
      no_such_station_try_again
    end
  end

  def delete_stations_from_route(id)
    @routes.each { |route| @current_route = route.waypoints if route.id == id }
    print 'В маршруте есть следующие станции: '
    @current_route.each { |waypoint| print "#{waypoint} " }
    puts
    print 'Выберите станцию для удаления: '
    station = gets.strip.chomp
    if @current_route.include?(station)
      @routes.each { |route| route.delete(station) if route.id == id }
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
    @trainid = gets.to_i
    print 'Номер маршрута: '
    @routeid = gets.to_i
  end

  def path_assignment
    if @trains_ids.include?(@trainid) && @routes_ids.include?(@routeid)
      @routes.each { |route| @choosed_route = route if route.id == @routeid }
      @trains.each { |train| train.route = @choosed_route.waypoints if train.id == @trainid }
      @result = "Маршрут ##{@routeid} успешно добавлен к поезду ##{@trainid}"
    else
      @result = 'Вы неверно ввели номер поезда или номер маршрута.'
    end
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
  end

  def move_forward(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.move_forward if train.id == id }
    else
      no_such_train(id)
    end
  end

  def move_backward(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.move_backward if train.id == id }
    else
      no_such_train(id)
    end
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

  def available_trains
    puts 'Доступные поезда:'
    @trains.each { |train| puts "Поезд ##{train.id}. Тип: #{train.type}, вагонов: #{train.vans.count}, скорость: #{train.speed}."}
  end

  def didnt_understand_you
    @result = 'Ввод не распознан. Попробуйте еще раз. Отмена.'
  end

  def no_such_train(id)
    @result = "Не такого поезда - #{id}"
  end

  def puts_result
    puts @result.to_s
    puts
  end

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
    station = gets.strip.chomp
    if @exists_stations_titles.include?(station)
    end
  when 2-1
    print 'Какой поезд хотите создать - (п)ассажирский или (г)рузовой?: '
    type = gets.strip.chomp.downcase
    create_train(type)
    puts_result
  when 3-1
    print 'Вы хотите (с)оздать новый или (и)зменить существующий маршрут?: '
    answer = gets.strip.chomp.downcase
    if %w[с С c C].include? answer
      pre_create_route_actions
    elsif %w[и И b B].include? answer
      pre_edit_route
    else
      didnt_understand_you
    end
    puts_result
  when 4
    create_van
    puts_result
  when 5
    @choosed_route = nil
    if @routes.empty?
      @result = 'Список маршрутов пуст. Создайте маршрут.'
    else
      pre_path_assignment
      path_assignment
    end
    puts_result
  when 6
    print 'Вы хотите (п)рицепить или (о)тцепить вагоны?: '
    choise = gets.strip.chomp
    if %w[п П g G].include? choise
      pre_add_vans
    elsif %w[о О j J].include? choise
      delete_vans
    end
    puts_result
  when 7
    print 'Введите номер поезда: '
    id = gets.to_i
    print 'Куда двигать поезд - (в)перед или (н)азад: '
    move = gets.strip.chomp.downcase
    if %w[в В d D].include? move
      move_forward(id)
    elsif %w[и И b B].include? move
      move_backward(id)
    end
    puts_result
  when 9
  when 0
    # @exit = true
    puts 'Всего хорошего! Приходите еще!'
    # break
  end
end
