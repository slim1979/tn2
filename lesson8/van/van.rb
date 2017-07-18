class Van
  include Manufacturer
  include ObjectValidation

  VAN_KIND = /^[a-zа-я0-9]{2,}-?\s?([a-zа-я0-9]+)?$/i
  VAN_MANUFACTURER = /^[a-zа-я0-9]{3,}$/i

  attr_accessor :number
  attr_reader :type, :kind, :status
  attr_writer :status

  def initialize(number, kind, *, manufacturer)
    @number = number
    @kind = kind
    @manufacturer = manufacturer
    validate!
    @status = 'free'
  end

  protected

  def validate!
    super
    raise ArgumentError, 'Проверьте правильность заполнения типа вагона' if kind !~ VAN_KIND
    true
  end
end
