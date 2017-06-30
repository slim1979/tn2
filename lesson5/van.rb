require_relative 'manufacturer.rb'

class Van
  include Manufacturer

  attr_reader :type, :number, :kind, :status
  attr_writer :status

  def initialize(number, kind)
    @number = number
    @kind = kind
    @status = 'free'
  end
end
