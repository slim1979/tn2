class PassengerVan < Van
  include InstanceCounter

  def initialize(number, kind, manufacturer)
    super
    @type = 'пассажирский'
    register_instances
  end
end
