class CargoVan < Van
  include InstanceCounter

  count_to_zero

  def initialize(number, kind, manufacturer)
    super
    @type = 'грузовой'
    register_instances
  end
end
