class PassengerTrain < Train

  def initialize(id)
    super
    @type = 'пассажирский'
    @vans_type = PassengerVan
  end
end
