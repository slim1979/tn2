class Train
  include Manufacturer
  include ObjectValidation

  attr_accessor :route, :speed
  attr_reader :type, :vans, :move, :vans_type, :was_moved, :id

  TRAIN_ID_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i

  @@list = {}

  def initialize(id, manufacturer)
    @id = id
    @manufacturer = manufacturer
    validate!
    @vans = []
    @speed = 0
    @move = 0
    @was_moved = false
    @@list[id] = self
  end

  def self.list
    @@list
  end

  def speed_up(speed)
    self.speed += speed
    "Скорость увеличена на #{speed} и равна #{self.speed}."
  end

  def speed_down(speed)
    if self.speed - speed >= 0
      self.speed -= speed
      "Скорость уменьшена на #{speed} и равна #{self.speed}."
    else
      'Это даст отрицательный результат, а скорость не может быть отрицательной.'
    end
  end

  def stop
    self.speed = 0
    'Поезд остановлен.'
  end

  def each_van
    vans.each { |van| yield van }
  end

  def add_van(van)
    if speed.zero? && !vans.include?(van) && vans_type == van.class && van.status == 'free'
      van.number = vans.empty? ? 1 : vans.last.number + 1
      vans << van
      van.status = 'busy'
      "Вагон #{van.number} успешно прицеплен. \nКоличество вагонов - #{vans.count}"
    elsif !speed.zero?
      'Сначала остановите поезд. Отмена.'
    elsif vans.include?(van)
      'Этот вагон уже прицеплен к этому поезду. Отмена.'
    elsif vans_type != van.class
      "К этому поезду можно прицепить вагоны только типа \'#{type}\'. Отмена."
    elsif van.status != 'free'
      'Этот вагон уже прицеплен к другому поезду. Отмена.'
    end
  end

  def delete_van(van)
    if speed.zero? && vans.include?(van)
      van.status = 'free'
      vans.delete(van)
      "Вагон ##{van.number} успешно отцеплен от поезда."
    elsif !speed.zero?
      'Сначала остановите поезд.'
    else
      'Такого вагона нет в составе поезда. Отмена.'
    end
  end

  def move_forward
    if !route
      no_route_yet
    elsif move + 1 >= route.waypoints.length
      stop
      move = route.waypoints.length - 1
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{route.waypoints[move].name}\' и остановлен."
    elsif speed.zero?
      'Для движения увеличьте у поезда скорость'
    else
      self.was_moved = true
      route.waypoints[move].train_departure(self)
      move += 1
      route.waypoints[move].train_arrival(self)
    end
  end

  def move_backward
    if !route
      no_route_yet
    elsif move - 1 < 0
      stop
      move = 0
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{route.waypoints[move].name}\' и остановлен."
    elsif speed.zero?
      'Для движения увеличьте у поезда скорость'
    else
      route.waypoints[move].train_departure(self)
      move -= 1
      route.waypoints[move].train_arrival(self)
    end
  end

  def previous_station
    if route
      @was_moved ? route.waypoints[move - 1] : 'Это новый поезд. Предыдущей станции нет.'
    else
      no_route_yet
    end
  end

  def now_station
    route ? route.waypoints[move] : no_route_yet
  end

  def next_station
    route ? route.waypoints[move + 1] : no_route_yet
  end

  protected

  def no_route_yet
    "У поезда #{id} нет назначенного маршрута"
  end

  def validate!
    super
    raise ArgumentError, 'Неверный формат идентификатора / названия' if id !~ TRAIN_ID_FORMAT
    true
  end
end
