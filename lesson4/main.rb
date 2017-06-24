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

loop do

  puts '1. Создать станцию'
  puts '2. Создать поезд'
  puts '3. Создать / редактировать маршрут'
  puts '4. Создать вагон'
  puts '5. Назначить маршрут поезду'
  puts '6. Добавить / отцепить вагоны к поезду'
  puts '7. Переместить поезд по маршруту'
  puts '8. Просмотреть список станций'
  puts '9. Просмотреть список поездов на станции'
  puts '0. Выйти из программы'

  def create_station(name)
    if @exists_stations_titles.include? name
      @result = 'Station already exist. Aborted.'
    else
      @exists_stations_titles << name
      @stations << Station.new(name)
      @result = "Station #{name.capitalize} successfully created!"
    end
  end

  def available_stations
    print 'Available stations: '
    if @exists_stations_titles.empty?
      print 'Stations list is empty. Create some stations first.'
    else
      @exists_stations_titles.each { |station| print station + ' ' }
    end
    puts
  end

  def pre_create_route_actions
    available_stations
    print 'Enter start point: '
    start = gets.strip.chomp
    print 'Enter final point: '
    finish = gets.strip.chomp
    create_route(start, finish)
  end

  def create_route(start, finish)
    if @exists_stations_titles.include?(start) && @exists_stations_titles.include?(finish)
      @routes_ids << @route_id += 1
      @routes << Route.new(@route_id, start, finish)
      @result = 'Route successfully created!'
    elsif !@exists_stations_titles.include? start
      @result = 'Start station is not exists'
    elsif !@exists_stations_titles.include?(finish)
      @result = 'Finish station is not exists'
    end
  end

  def pre_edit_route
    puts 'Available routes: '
    @routes.each { |route| puts "Route #{route.id}->#{route.waypoints} " }
    print 'Enter route id to edit: '
    id = gets.to_i
    if @routes_ids.include?(id)
      edit_route(id)
    else
      @result = 'Didnt understand you. Try again. Aborted'
    end
  end

  def edit_route(id)
    print 'You want to add stations or to delete? (a/d): '
    answer = gets.strip.chomp.downcase
    if answer == 'a'
      add_stations_to_route(id)
    elsif answer == 'd'
      delete_stations_from_route(id)
    else
      @result = 'Didnt understand you. Try again. Aborted'
    end
  end

  def add_stations_to_route(id)
    @routes.each { |route| @current_route = route.waypoints if route.id == id }
    available_stations = @exists_stations_titles - @current_route
    print "Available stations:"
    available_stations.each{ |station| print "#{station} " }
    puts
    print 'Enter station name to add it to route: '
    name = gets.strip.chomp.downcase
    if @exists_stations_titles.include?(name)
      @routes.each { |route| route.add(name) if route.id == id }
    else
      puts "No such station - #{name}. Try again? (y/n): "
      answer = gets.strip.chomp.downcase
      answer == 'y' ? add_stations_to_route(id) : @result = "No such station - #{name}"
    end
  end

  def pre_path_assignment
    puts 'Available trains: '
    @trains.each do |train|
      if train.route
        puts "Train #{train.id}->#{train.route} "
      else
        puts "Train #{train.id}-> no route "
      end
    end
    puts 'Available routes: '
    @routes.each { |route| puts "Route #{route.id}->#{route.waypoints} " }
    puts 'Choose train and route for it:'
    print 'Train id: '
    @trainid = gets.to_i
    print 'Route id: '
    @routeid = gets.to_i
  end

  def path_assignment
    if @trains_ids.include?(@trainid) && @routes_ids.include?(@routeid)
      @routes.each { |route| @choosed_route = route if route.id == @routeid }
      @trains.each { |train| train.route = @choosed_route.waypoints if train.id == @trainid }
      @result = "Success. Route #{@routeid} added to train #{@trainid}"
    else
      @result = 'Wrong train or route id'
    end
  end

  def create_train(type)
    if type == 'p'
      @trains_ids << @train_id += 1
      @trains << PassengerTrain.new(@train_id)
      @result = 'Passenger train created!'
    elsif type == 'c'
      @trains_ids << @train_id += 1
      @trains << CargoTrain.new(@train_id)
      @result = 'Cargo train created!'
    else
      @result = 'Didnt understand you. Try again. Aborted'
    end
  end

  def move_forward(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.move_forward if train.id == id }
    else
      no_such_train
    end
  end

  def move_backward(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.move_backward if train.id == id }
    else
      no_such_train
    end
  end

  def now(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.now_station if train.id == id }
    else
      no_such_train
    end
  end

  def route(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.route if train.id == id }
    else
      no_such_train
    end
  end

  def vans(id)
    if @trains_ids.include? id
      @trains.each { |train| @result = train.vans if train.id == id }
    else
      no_such_train
    end
  end

  def create_van
    puts 'To create van enter its type and kind: '
    loop do
      print 'Type (p/c): '
      @type = gets.strip.chomp.downcase
      break unless @type.nil? || @type.empty?
    end
    loop do
      print 'Kind: '
      @kind = gets.strip.chomp
      break unless @kind.nil? || @kind.empty?
    end
    entering_to_all_vans
  end

  def entering_to_all_vans
    if @type == 'p'
      @vans_ids << @van_id += 1
      @vans << PassengerVan.new(@van_id, 'passenger', @kind)
      "Passenger van ##{@van_id} created"
    elsif @type == 'c'
      @vans_ids << @van_id += 1
      @vans << CargoVan.new(@van_id, 'cargo', @kind)
      "Cargo van ##{@van_id} created"
    else
      'Sorry, no such van type. Try again'
    end
  end

  def add_van(train_id, van_number)
    @vans.each { |van| @van = van if van.number == van_number }
    if @trains_ids.include? train_id
      @trains.each { |train| @result = train.add_van(@van) if train.id == train_id }
    else
      no_such_train
    end
    @result
  end

  def no_such_train
    @result = "No such train - #{id}"
  end

  def puts_result
    puts @result.to_s
    puts
  end

  @action = gets.to_i
  case @action
  when 1
    print 'Enter new station name: '
    name = gets.strip.chomp
    create_station(name)
    puts_result
  when 2
    print 'Passenger or Cargo train? (p/c): '
    type = gets.strip.chomp.downcase
    create_train(type)
    puts_result
  when 3
    print 'Create or edit route? (c/e): '
    answer = gets.strip.chomp.downcase
    if answer == 'c'
      pre_create_route_actions
    elsif answer == 'e'
      pre_edit_route
    else
      @result = 'Didnt understand you. Try again. Aborted'
    end
    puts_result
  when 5
    @choosed_route = nil
    if @routes.empty?
      print 'Routes list is empty. Create some routes first.'
    else
      pre_path_assignment
      path_assignment
    end
    puts_result
  when 6
  when 7
    print 'What train? (id):'
    id = gets.to_i
    print 'Forward or backward? (f/b):'
    move = gets.strip.chomp.downcase
    if move == 'f'
      move_forward(id)
    elsif move == 'b'
      move_backward(id)
    end
    puts_result
  when 8
    print 'Available stations: '
    if @exists_stations_titles.empty?
      print 'Stations list is empty. Create some stations first.'
    else
      @exists_stations_titles.sort.each { |station| print station + ' ' }
    end
    puts
    puts
  when 9
  when 0
    puts 'Bye bye'
    break
  else
  end
end
