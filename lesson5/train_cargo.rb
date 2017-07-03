class CargoTrain < Train
  include InstanceCounter

  def initialize(id, manufacturer)
    super
    @type = 'грузовой'
    @vans_type = CargoVan
    register_instances
  end
end
