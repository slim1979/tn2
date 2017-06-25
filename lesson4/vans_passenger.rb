class PassengerVan
  include Vans

  def initialize(number, kind)
    super
    @type = 'passenger'
  end

end
