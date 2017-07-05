class Train
  include Manufacturer
  include ObjectValidation

  attr_accessor :route, :id
  attr_reader :type, :speed, :vans, :move, :vans_type

  TRAIN_ID_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i
  TRAIN_MANUFACTURER_FORMAT = /^[a-zа-я0-9]{3,}$/i

  @@list = {}

  def initialize(id, manufacturer)
    @id = id
    @manufacturer = manufacturer
    @vans = []
    @speed = 0
    @move = 0
    @was_moved = false
    @@list[id] = self
    validate!
  end

  def self.find(train)
    @@list[train]
  end

  def speed_up(speed)
    @speed += speed
    "Скорость увеличена на #{speed} и равна #{@speed}."
  end

  def speed_down(speed)
    if @speed - speed >= 0
      @speed -= speed
      "Скорость уменьшена на #{speed} и равна #{@speed}."
    else
      'Это даст отрицательный результат, а скорость не может быть отрицательной.'
    end
  end

  def stop
    @speed = 0
    'Поезд остановлен.'
  end

  def add_van(van)
    if @speed.zero? && !@vans.include?(van) && self.vans_type == van.class && van.status == 'free'
      @vans << van
      van.status = 'busy'
      "Вагон #{van.number} успешно прицеплен. Количество вагонов - #{@vans.count}"
    elsif !@speed.zero?
      'Сначала остановите поезд. Отмена.'
    elsif @vans.include?(van)
      'Этот вагон уже прицеплен к этому поезду. Отмена.'
    elsif self.vans_type != van.class
      "К этому поезду можно прицепить вагоны только типа \'#{self.type}\'. Отмена."
    elsif van.status != 'free'
      'Этот вагон уже прицеплен к другому поезду. Отмена.'
    end
  end

  def delete_van(van)
    if @speed.zero? && @vans.include?(van)
      @vans.delete(van)
      van.status = 'free'
      "Вагон ##{van.number} успешно отцеплен от поезда."
    elsif !@speed.zero?
      'Сначала остановите поезд.'
    else
      'Такого вагона нет в составе поезда. Отмена.'
    end
  end

  def move_forward
    if !@route
      no_route_yet
    elsif @move + 1 >= @route.length
      stop
      @move = @route.length - 1
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{@route[@move]}\' и остановлен."
    elsif @speed == 0
      'Для движения увеличьте у поезда скорость'
    else
      @was_moved = true
      @move += 1
      @route[@move]
    end
  end

  def move_backward
    if !@route
      no_route_yet
    elsif @move - 1 < 0
      stop
      @move = 0
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{@route[@move]}\' и остановлен."
    elsif @speed == 0
      'Для движения увеличьте у поезда скорость'
    else
      @move -= 1
      @route[@move]
    end
  end

  def previous_station
    if @route
      @was_moved ? @route[@move - 1] : 'Это новый поезд. Предыдущей станции нет.'
    else
      no_route_yet
    end
  end

  def now_station
    @route ? @route[@move]: no_route_yet
  end

  def next_station
    @route ? @route[@move + 1] : no_route_yet
  end

  protected

  def no_route_yet
    "У поезда #{id} нет назначенного маршрута"
  end

  def validate!
    raise 'Неверный формат идентификатора / названия' if id !~ TRAIN_ID_FORMAT
    raise 'Должно быть не менее 3 символов в наименовании производителя' if manufacturer.length < 3
    true
  end
end
