module Manufacturer
  attr_accessor :manufacturer
  TRAIN_MANUFACTURER_FORMAT = /^[a-zа-я0-9]{3,}$/i
end
