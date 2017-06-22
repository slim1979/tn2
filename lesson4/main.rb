require_relative 'train.rb'
require_relative 'train_cargo.rb'
require_relative 'train_passenger.rb'
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

@train = PassengerTrain.new(12,'cargo')
@train2 = PassengerTrain.new(123,'cargo')
@train.increase_vans(1,'cargo')
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
