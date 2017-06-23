require_relative 'train.rb'
require_relative 'train_passenger.rb'
require_relative 'train_cargo.rb'
require_relative 'vans.rb'
require_relative 'vans_passenger.rb'
require_relative 'vans_cargo.rb'
require_relative 'station.rb'
require_relative 'route.rb'
@stations = []
@routes = []
@trains = []
@all_vans = []

# id создаваемого поезда
@id = 0
# номер вагона
@number = 0

loop do

  puts '1. Создавать станции'
  puts '2. Создавать поезда'
  puts '3. Создавать маршруты и управлять станциями в нем (добавлять, удалять)'
  puts '4. Назначать маршрут поезду'
  puts '5. Добавлять вагоны к поезду'
  puts '6. Отцеплять вагоны от поезда'
  puts '7. Перемещать поезд по маршруту вперед и назад'
  puts '8. Просматривать список станций и список поездов на станции'
  puts '9. Выйти из программы'

  def create_station(name)
    @stations << Station.new(name)
    @result = "Station successfully created!"
  end

  def create_route(start, finish)
    @a = []
    @stations.each { |station| @a << station.name }
    if @a.include?(start) && @a.include?(finish)
      @routes << Route.new(start, finish)
      @result = 'Route successfully created!'
    elsif !@a.include? start
      @result = 'Start station is not exists'
    elsif !@a.include?(finish)
      @result = 'Finish station is not exists'
    end
  end

  def create_train(type)
    @id += 1
    if type == 'p'
      @trains << PassengerTrain.new(@id)
      @result = 'Passenger train created!'
    elsif type == 'c'
      @trains << CargoTrain.new(@id)
      @result = 'Cargo train created!'
    else
      @id -= 1
      @result = 'Didnt understand you. Try again. Aborted'
    end
  end

  def move_forward(id)
    @trains.each do |train|
      if train.id.eql? id
        @result = train.move_forward
        break
      else
        @result = "No such train - #{id}"
      end
    end
    # @result
  end

  def move_backward(id)
    @trains.each do |train|
      if train.id.eql? id
        @result = train.move_forward
        break
      else
        @result = "No such train - #{id}"
      end
    end
    # @result
  end

  def now(id)
    @trains.each do |train|
      if train.id.eql? id
        @result = train.now_station
        break
      else
        @result = "No such train - #{id}"
      end
    end
    # @result
  end

  def route(id)
    @trains.each do |train|
      if train.id.eql? id
        @result = train.route
        break
      else
        @result = "No such train - #{id}"
      end
    end
    # @result
  end

  def vans(id)
    @trains.each do |train|
      if train.id.eql? id
        @result = train.vans
        break
      else
        @result = "No such train - #{id}"
      end
    end
    # @result
  end

  def create_van
    puts 'To create van enter its type and kind: '
    @number += 1
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
      @type = 'passenger'
      @all_vans << PassengerVan.new(@number, @type, @kind)
      "Passenger van ##{@number} created"
    elsif @type == 'c'
      @type = 'cargo'
      @all_vans << CargoVan.new(@number, @type, @kind)
      "Cargo van ##{@number} created"
    else
      'Sorry, no such van type. Try again'
    end
  end

  def add_van(train_id, van_number)
    @all_vans.each { |van| @van = van if van.number == van_number }
    @trains.each do |train|
      if train.id == train_id
        @result = train.add_vans(@van)
        break
      else
        @result = "No such train - #{train_id}"
      end
    end
    @result
  end

  def puts_result
    puts @result.to_s
    puts
  end

  @action = gets.to_i
  case @action
  when 1
    print 'Enter new station name: '
    name = gets.strip.chomp.capitalize!
    create_station(name)
    puts_result
  when 2
    print 'Passenger or Cargo train? (p/c): '
    type = gets.strip.chomp.downcase
    create_train(type)
    puts_result
  when 3
    print 'Available stations: '
    if @stations.empty?
      print 'Stations list is empty. Create some stations first.'
    else
      @stations.each { |station| print station.name.to_s + ' ' }
      puts
      print 'Enter start point: '
      start = gets.strip.chomp.downcase.capitalize!
      print 'Enter final point: '
      finish = gets.strip.chomp.downcase.capitalize!
      create_route(start, finish)
    end
    puts_result
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
  when 9
    puts 'Bye bye'
    break
  else
  end
end
