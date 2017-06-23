class PassengerVan
  include Vans

  def initialize(number, type, kind)
    super
    @type = 'passenger'
  end

end
