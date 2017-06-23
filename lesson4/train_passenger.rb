class PassengerTrain
  include Train

  def initialize(id)
    super
    @type = 'passenger'
  end
end
