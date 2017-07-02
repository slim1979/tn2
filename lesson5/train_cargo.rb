class CargoTrain < Train
  include InstanceCounter
  count_to_zero

  def initialize(id, manufacturer)
    super
    @type = 'грузовой'
    @vans_type = CargoVan
    register_instances
  end
end
