# Manufacturer
module Manufacturer
  attr_accessor :manufacturer
  MANUFACTURER_FORMAT = /^[a-zа-я0-9]{3,}$/i

  def validate!
    raise ArgumentError, 'Неверный формат наименования производителя' if manufacturer !~ MANUFACTURER_FORMAT
  end
end
