class CargoVan < Van
  include InstanceCounter

  def initialize(number, kind, manufacturer)
    super
    @type = 'грузовой'
    register_instances
  end
end
