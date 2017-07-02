class PassengerVan < Van
  include InstanceCounter

  count_to_zero

  def initialize(number, kind, manufacturer)
    super
    @type = 'пассажирский'
    register_instances
  end
end
