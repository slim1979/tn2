class CargoVan
  include Vans

  def initialize(number, kind)
    super
    @type = 'грузовой'
  end

end
