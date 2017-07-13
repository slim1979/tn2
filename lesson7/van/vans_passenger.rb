class PassengerVan < Van
  include InstanceCounter

  attr_accessor :free_seats, :solded_seats
  attr_reader :seats

  def initialize(number, kind, seats, manufacturer)
    super
    @type = 'пассажирский'
    @seats = seats
    register_instances
  end

  def buy_ticket
    self.free_seats ||= seats
    if free_seats <= 0
      'Свободные места закончились'
    else
      self.solded_seats ||= 0
      self.solded_seats += 1
      self.free_seats -= 1
      'Билет куплен, удачной поездки!'
    end
  end
end
