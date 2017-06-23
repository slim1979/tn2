module Vans

  attr_reader :type, :number, :kind

  def initialize(number, type, kind)
    @number = number
    @type = type
    @kind = kind
  end
end
