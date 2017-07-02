class PassengerTrain < Train
  include InstanceCounter

  count_to_zero

  def initialize(id, manufacturer)
    super
    @type = 'пассажирский'
    @vans_type = PassengerVan
    register_instances
  end
end
