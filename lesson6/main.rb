require_relative 'modules/manufacturer'
require_relative 'modules/object_validation'
require_relative 'modules/instance_counter'
require_relative 'station/station'
require_relative 'station/station_methods'
require_relative 'route/route'
require_relative 'route/route_methods'
require_relative 'train/train_methods'
require_relative 'train/train'
require_relative 'train/train_passenger'
require_relative 'train/train_cargo'
require_relative 'van/van_methods'
require_relative 'van/van'
require_relative 'van/vans_passenger'
require_relative 'van/vans_cargo'

class Game
  include StationMethods
  include RouteMethods
  include TrainMethods
  include VanMethods

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @vans = []
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

  # private

  attr_reader :trains, :stations, :routes, :vans, :result

  def choise
    print 'Выберите действие: '
    @action = gets.to_i
    case @action
    when 1
      print 'Введите название новой станции: '
      name = gets.strip.chomp
      create_station(name)
    when 2
      available_stations
    when 3
      trains_count
      trains_list_on_station
    when 4
      if @stations.empty?
        puts 'Список станций пуст. Создайте пару станций.'
      else
        available_stations
        puts pre_create_route_actions
      end
    when 5
      puts pre_edit_route
    when 6
      puts create_van
    when 7
      puts create_train_exceptions_handling
    when 8
      puts pre_add_van
    when 9
      puts pre_delete_van
    when 10
      if @routes.empty?
        'Список маршрутов пуст. Создайте маршрут.'
      else
        puts pre_path_assignment
      end
    when 11
      train_choise
      choise = 'up'
      puts trains_include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
    when 12
      train_choise
      choise = 'down'
      puts trains_include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
    when 13
      train_choise
      puts trains_include?(@id) ? train_stop(@id) : no_such_train(@id)
    when 14
      available_trains
      print 'Введите номер поезда: '
      id = gets.strip.chomp
      puts trains_include?(id) ? where_to_move_train(id) : no_such_train(id)
    when 15
      @trains.each { |train| puts "#{train.id}, #{train.route}, #{train.move}" }
    when 0
      'Всего хорошего! Приходите еще!'
    end
  end

  def fill
    puts create_station('aaa')
    puts create_station('bbb')
    puts create_station('ccc')
    puts create_route('ccc', 'bbb')
    puts create_train('vvv-45', 'g', 'НЭВЗ')
    path_assignment('vvv-45', 1)
    puts 'Увеличение скорости'
    change_speed('vvv-45', 'up')
    puts 'Движение'
    where_to_move_train('vvv-45')
  end

  def didnt_understand_you
    'Ввод не распознан. Попробуйте еще раз. Отмена.'
  end

  def puts_with_effects(string)
    3.times do
      print ' ' * string.length, "\r"
      sleep 0.3
      print string.to_s, "\r"
      sleep 0.3
    end
    puts
  end
end

@game = Game.new
loop do
  @game.menu
end
