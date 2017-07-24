class PassengerVan < Van
  include InstanceCounter

  attr_accessor :free_seats, :solded_seats
  attr_reader :seats

  validate :seats,        :type, Integer
  validate :kind,         :format, /^[a-zа-я0-9]{2,}-?\s?([a-zа-я0-9]+)?$/i
  validate :manufacturer, :format, /^[a-zа-я0-9]{3,}$/i

  def initialize(number, kind, seats, manufacturer)
    super
    @type = 'пассажирский'
    @seats = seats
    @free_seats = seats
    @solded_seats = 0
    register_instances
  end

  def buy_ticket
    if free_seats <= 0
      'Свободные места закончились'
    else
      self.solded_seats += 1
      self.free_seats -= 1
      'Билет куплен, удачной поездки!'
    end
  end
end
