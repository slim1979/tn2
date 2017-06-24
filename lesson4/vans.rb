module Vans

  attr_reader :type, :number, :kind, :status
  attr_writer :status

  def initialize(number, type, kind)
    @number = number
    @type = type
    @kind = kind
    @status = 'free'
  end
end
