class CargoVan < Van

  def initialize(number, kind)
    super
    @type = 'грузовой'
  end

end
