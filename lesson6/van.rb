class Van
  include Manufacturer

  attr_reader :type, :number, :kind, :status
  attr_writer :status

  def initialize(number, kind, manufacturer)
    @number = number
    @kind = kind
    @manufacturer = manufacturer
    @status = 'free'
  end
end
