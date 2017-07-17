class PassengerTrain < Train
  include InstanceCounter

  def initialize(id, manufacturer)
    super
    @type = 'пассажирский'
    @vans_type = PassengerVan
    register_instances
  end
end
