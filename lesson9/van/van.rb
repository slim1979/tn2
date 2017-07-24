class Van
  extend Accessors
  include Manufacturer
  include Validation

  attr_accessor :number
  attr_reader :type, :kind, :status
  attr_writer :status

  def initialize(number, kind, *, manufacturer)
    @number = number
    @kind = kind
    @manufacturer = manufacturer
    @status = 'free'
  end
end
