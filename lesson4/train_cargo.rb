class CargoTrain < Train

  def initialize(id)
    super
    @type = 'грузовой'
    @vans_type = CargoVan
  end
end
