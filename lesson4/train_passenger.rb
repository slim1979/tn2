class PassengerTrain
  include Train

  def initialize(id)
    super
    @type = 'пассажирский'
  end
end
