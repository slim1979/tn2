module Manufacturer
  attr_accessor :manufacturer
  TRAIN_MANUFACTURER_FORMAT = /^[a-zа-я0-9]{3,}$/i

  def validate!
    raise ArgumentError, 'Неверный формат наименования производителя' if manufacturer !~ TRAIN_MANUFACTURER_FORMAT
  end
end
