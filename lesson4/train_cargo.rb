class CargoTrain
  include Train

  def initialize(id)
    super
    @type = 'грузовой'
  end
end
