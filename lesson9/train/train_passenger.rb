class PassengerTrain < Train
  include InstanceCounter

  validate :id, :format, /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i
  validate :manufacturer, :format, /^[a-zа-я0-9]{3,}$/i

  def initialize(id, manufacturer)
    super
    @type = 'пассажирский'
    @vans_type = PassengerVan
    register_instances
  end
end
