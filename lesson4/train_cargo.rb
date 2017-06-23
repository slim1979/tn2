class CargoTrain
  include Train

  def initialize(id)
    super
    @type = 'cargo'
  end
end
