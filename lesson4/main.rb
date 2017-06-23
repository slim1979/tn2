require_relative 'train.rb'
require_relative 'train_passenger.rb'
require_relative 'train_cargo.rb'
require_relative 'vans.rb'
require_relative 'vans_passenger.rb'
require_relative 'vans_cargo.rb'
require_relative 'station.rb'
require_relative 'route.rb'

# puts 'Создавать станции'
# puts 'Создавать поезда'
# puts 'Создавать маршруты и управлять станциями в нем (добавлять, удалять)'
# puts 'Назначать маршрут поезду'
# puts 'Добавлять вагоны к поезду'
# puts 'Отцеплять вагоны от поезда'
# puts 'Перемещать поезд по маршруту вперед и назад'
# puts 'Просматривать список станций и список поездов на станции'
@trains = []
@trains << PassengerTrain.new(1233) << PassengerTrain.new(1234)
@trains << PassengerTrain.new(1235) << PassengerTrain.new(1236)
@trains << CargoTrain.new(1233 / 3) << CargoTrain.new(1234 / 5)
@trains[1].route = 'aaa','bbb','ccc'
# @train.increase_vans(1,'cargo')
@van = PassengerVan.new(1,'passenger','СВ')
@van2 = PassengerVan.new(123,'aaa','dsds')
# @train = Train.new(12, 'pass', 30)
# @train2 = Train.new(124, 'pass', 25)
# @train3 = Train.new(4, 'cargo', 5)
# @route = Route.new('aaa', 'bbb')
# @route.add('ccc2')
# @route.add('ccc3')
# @route.add('ccc4')
# @train.route = @route.list
# @station = Station.new('first')
# @station.train_arrival(@train)
# @station.train_arrival(@train2)
# @station.train_arrival(@train3)
@trains[0].add_vans(PassengerVan.new(5,'passenger','ПВ'))
@trains[0].add_vans(PassengerVan.new(15,'passenger','ПВ'))
@trains[0].add_vans(PassengerVan.new(2,'passenger','ПВ'))
@trains[0].vans.sort_by!(&:number)
@p_vans, @c_vans = []

def move(id)
  @trains.each do |train|
    if train.id.eql? id
      @answer = train.move_forward
      break
    else
      @answer = "No such train - #{id}"
    end
  end
  @answer
end

def now(id)
  @trains.each do |train|
    if train.id.eql? id
      @answer = train.now_station
      break
    else
      @answer = "No such train - #{id}"
    end
  end
  @answer
end

def route(id)
  @trains.each do |train|
    if train.id.eql? id
      @answer = train.route
      break
    else
      @answer = "No such train - #{id}"
    end
  end
  @answer
end

def vans(id)
  @trains.each do |train|
    if train.id.eql? id
      @answer = train.vans
      break
    else
      @answer = "No such train - #{id}"
    end
  end
  @answer
end

def create_van
  puts 'To create van enter its number, type and kind: '
  loop do
    print 'Number: '
    @number = gets.strip.chomp
    break unless @number.nil? || @number.empty?
  end
  loop do
    print 'Type: '
    @type = gets.strip.chomp.downcase
    break unless @type.nil? || @type.empty?
  end
  loop do
    print 'Kind: '
    @kind = gets.strip.chomp
    break unless @kind.nil? || @kind.empty?
  end

  if @type == 'passenger'
    @p_vans << PassengerVan.new(@number, @type, @kind)
    'Van created'
  elsif @type == 'cargo'
    @c_vans << CargoVan.new(@number, @type, @kind)
    'Van created'
  else
    'Sorry no such van type. Try again'
  end
end
