class Train

  attr_accessor :route
  attr_reader :vans, :type, :id

  def initialize(id)
    @id = id
    @vans = []
    @speed = 0
    @move = 0
    @was_moved = false
  end

  def increase_speed(speed)
    @speed += speed
  end

  def decrease_speed(speed)
    if @speed - speed > 0
      @speed -= speed
    else
      'Speed cant be negative'
    end
  end

  def stop
    @speed = 0
  end

  def increase_vans(number, type)
    if @speed.zero? && !@vans.include?(number) && type == self.type
      @vans << number
    else
      'Check van number, type or stop the train first'
    end
  end

  def decrease_vans(number)
    if @speed.zero? && @vans.include?(number)
      @vans.delete(number)
    else
      'Stop the train first or check vans amount'
    end
  end

  def move_forward
    if @route.nil? || @route.empty?
      puts 'Route not found'
    elsif @move + 1 >= @route.length
      stop
      @move = @route.length - 1
      "reached the terminus - #{@route[@move]}"
    else
      @was_moved = true
      @move += 1
      @route[@move]
    end
  end

  def move_backward
    if @route.nil? || @route.empty?
      puts 'Route not found'
    elsif @move - 1 < 0
      stop
      @move = 0
      "reached the terminus - #{@route[@move]}"
    else
      @move -= 1
      @route[@move]
    end
  end

  def previous_station
    if @was_moved
      @route[@move - 1]
    else
      'New train. Have no previous station'
    end
  end

  def now_station
    @route[@move]
  end

  def next_station
    @route[@move + 1]
  end
end
