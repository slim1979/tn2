# Manufacturer
module Manufacturer

  MANUFACTURER_FORMAT = /^[a-zа-я0-9]{3,}$/i

  attr_accessor :manufacturer

  def validate!
    raise ArgumentError, 'Неверный формат наименования производителя' if manufacturer !~ MANUFACTURER_FORMAT
  end
end
