module Train

  attr_accessor :route
  attr_reader :type, :id, :speed, :vans

  def initialize(id)
    @id = id
    @vans = []
    @speed = 0
    @move = 0
    @was_moved = false
  end

  def speed_up(speed)
    @speed += speed
  end

  def speed_down(speed)
    if @speed - speed > 0
      @speed -= speed
    else
      'Это даст отрицательный результат, а скорость не может быть отрицательной.'
    end
  end

  def stop
    @speed = 0
  end

  def add_van(van)
    if @speed.zero? && !@vans.include?(van) && van.type == self.type && van.status == 'free'
      @vans << van
      van.status = 'busy'
      "Вагон #{van.number} успешно прицеплен. Количество вагонов - #{@vans.count}"
    elsif !@speed.zero?
      'Сначала остановите поезд. Отмена.'
    elsif @vans.include?(van)
      'Этот вагон уже прицеплен к этому поезду. Отмена.'
    elsif van.type != self.type
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
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{@route[@move]}\'"
    elsif @speed == 0
      'Для движения увеличьте у поезда скорость'
    else
      @was_moved = true
      @move += 1
      "Чу чу!!! Поезд приехал на станцию \'#{@route[@move]}\'"
    end
  end

  def move_backward
    if !@route
      no_route_yet
    elsif @move - 1 < 0
      stop
      @move = 0
      "Дальше двигаться некуда. Поезд достиг конечной станции -  \'#{@route[@move]}\'"
    elsif @speed == 0
      'Для движения увеличьте у поезда скорость'
    else
      @move -= 1
      "Чу чу!!! Поезд приехал на станцию \'#{@route[@move]}\'"
    end
  end

  def previous_station
    if @route
      @was_moved ? "Предыдущая станция \'#{@route[@move - 1]}\'" : 'Это новый поезд. Предыдущей станции нет.'
    else
      no_route_yet
    end
  end

  def now_station
    @route ? "Поезд сейчас на станции \'#{@route[@move]}\'" : no_route_yet
  end

  def next_station
    @route ? "Следующая станция \'#{@route[@move + 1]}\'" : no_route_yet
  end

  private

  def no_route_yet
    "У поезда #{self.id} нет назначенного маршрута"
  end
end
