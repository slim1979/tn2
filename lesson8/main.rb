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
    puts '  12. Посмотреть прицепленные вагоны'
    puts '  13. Назначить маршрут поезду'
    puts '  14. Увеличить скорость поезда'
    puts '  15. Уменьшить скорость поезда'
    puts '  16. Остановить поезд'
    puts '  17. Переместить поезд по маршруту'
    puts '======================================='
    puts '  0. Выйти из программы'
    choise_exceptions_handling
  end

  private

  attr_reader :stations, :vans

  def choise
    print 'Выберите действие: '
    action = gets.to_i
    do_this = {
      1 => -> { puts create_station },
      2 => -> { puts available_stations },
      3 => -> { puts trains_list_on_station },
      4 => -> { puts pre_create_route_actions },
      5 => -> { puts pre_edit_route },
      6 => -> { puts create_van },
      7 => -> { puts buy_place_in_passenger_van },
      8 => -> { puts buy_place_in_cargo_van },
      9 => -> { puts create_train_exceptions_handling },
      10 => -> { puts add_van },
      11 => -> { choose_train { |exist_train| puts delete_van(exist_train) } },
      12 => -> { choose_train { |exist_train| exist_train.each_van { |van| puts van_info_according_to_kind van } } },
      13 => -> { puts path_assignment },
      14 => -> { choose_train { |exist_train| puts change_speed(exist_train, 'up') } },
      15 => -> { choose_train { |exist_train| puts change_speed(exist_train, 'down') } },
      16 => -> { choose_train { |exist_train| puts train_stop(exist_train) } },
      17 => -> { choose_train { |exist_train| puts move_train(exist_train) } },
      18 => 'Всего хорошего! Приходите еще!'
    }
    do_this[action].call
  end

  def fill
    create_station
    create_station
    pre_create_route_actions
    create_passenger_train
    create_cargo_train
    path_assignment
    path_assignment
    create_van
    create_van
    add_van
    add_van
  end

  def choise_exceptions_handling
    choise
  rescue StandardError => e
    puts e
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
