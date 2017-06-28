class CargoVan < Vans

  def initialize(number, kind)
    super
    @type = self.class
  end

end
