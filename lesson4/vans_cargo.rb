class CargoVan
  include Vans

  def initialize(number, kind)
    super
    @type = 'cargo'
  end

end
