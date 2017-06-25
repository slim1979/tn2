class PassengerVan
  include Vans

  def initialize(number, kind)
    super
    @type = 'пассажирский'
  end

end
