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
    puts '   7. Купить место в пассажирском вагоне'
    puts '   8. Купить место в грузовом вагоне'
    puts '**************** Поезд ****************'
    puts '   9. Создать новый поезд'
    puts '  10. Добавить вагоны'
    puts '  11. Отцепить вагоны'
    puts '  12. Назначить маршрут поезду'
    puts '  13. Увеличить скорость поезда'
    puts '  14. Уменьшить скорость поезда'
    puts '  15. Остановить поезд'
    puts '  16. Переместить поезд по маршруту'
    puts '======================================='
    puts '  0. Выйти из программы'
    choise_exceptions_handling
  end

  private

  attr_reader :trains, :stations, :routes, :vans, :result

  def choise
    print 'Выберите действие: '
    @action = gets.to_i
    case @action
    when 1
      puts create_station
    when 2
      puts available_stations
    when 3
      trains_count
      trains_list_on_station
    when 4
      puts available_stations
      puts pre_create_route_actions
    when 5
      puts pre_edit_route
    when 6
      puts create_van
    when 7
      puts buy_place_in_passenger_van
    when 8
      puts buy_place_in_cargo_van
    when 9
      puts create_train_exceptions_handling
    when 10
      puts pre_add_van
    when 11
      puts pre_delete_van
    when 12
      puts path_assignment
    when 13
      train_choise
      choise = 'up'
      puts trains_include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
    when 14
      train_choise
      choise = 'down'
      puts trains_include?(@id) ? change_speed(@id, choise) : no_such_train(@id)
    when 15
      train_choise
      puts trains_include?(@id) ? train_stop(@id) : no_such_train(@id)
    when 16
      available_trains
      puts move_train
    when 0
      'Всего хорошего! Приходите еще!'
    end
  end

  def fill
    create_station
    create_station
    create_route(@stations.first.name, @stations.last.name)
    create_passenger_train
    create_cargo_train
    path_assignment
    path_assignment
    create_van
    create_van
    pre_add_van
    pre_add_van
  end

  def choise_exceptions_handling
    choise
  rescue StandardError => e
    puts e.to_s
  end

  def didnt_understand_you
    puts 'Ввод не распознан. Попробуйте еще раз. Отмена.'
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
