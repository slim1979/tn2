module Manufacturer
  attr_reader :manufacturer_is

  def manufactured_by(title)
    @manufacturer_is = title
  end
end
