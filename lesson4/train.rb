module Train

  attr_accessor :route
  attr_reader :vans, :type, :id, :speed

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
      'Speed cant be negative'
    end
  end

  def stop
    @speed = 0
  end

  def add_vans(van)
    if @speed.zero? && !@vans.include?(van) && van.type == self.type && van.status == 'free'
      @vans << van
      van.status = 'busy'
      "Van #{van.number} successfully added. Vans count - #{@vans.count}"
    elsif !@speed.zero?
      'Stop the train first. Aborted.'
    elsif @vans.include?(van)
      'This van already connected to this train. Aborted.'
    elsif van.type != self.type
      "This train is only supported #{self.type} vans. Aborted."
    elsif van.status != 'free'
      'Van is already added to another train. Aborted.'
    end
  end

  def delete_vans(number)
    if @speed.zero? && @vans.include?(number)
      @vans.delete(number)
    else
      'Stop the train first or check vans amount'
    end
  end

  def move_forward
    if !@route
      no_route_yet
    elsif @move + 1 >= @route.length
      stop
      @move = @route.length - 1
      "Can\'t do it. Train is reached the terminus - station \'#{@route[@move]}\'"
    else
      @was_moved = true
      @move += 1
      "Chu chu!!! Train arrived on station \'#{@route[@move]}\'"
    end
  end

  def move_backward
    if !@route
      no_route_yet
    elsif @move - 1 < 0
      stop
      @move = 0
      "Can\'t do it. Train is reached the terminus - station \'#{@route[@move]}\'"
    else
      @move -= 1
      "Chu chu!!! Train arrived on station \'#{@route[@move]}\'"
    end
  end

  def previous_station
    if @route
      @was_moved ? "Previous station is \'#{@route[@move - 1]}\'" : 'New train. Have no previous station'
    else
      no_route_yet
    end
  end

  def now_station
    @route ? "Train now on \'#{@route[@move]}\' station" : no_route_yet
  end

  def next_station
    @route ? "Station \'#{@route[@move + 1]}\'" : no_route_yet
  end

  private

  def no_route_yet
    "Train #{self.id} have no route yet"
  end
end
