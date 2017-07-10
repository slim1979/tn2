class Van
  include Manufacturer
  include ObjectValidation

  attr_reader :type, :number, :kind, :status
  attr_writer :status

  VAN_NUMBER = /^\d+$/
  VAN_KIND = /^.{2,}-?$/
  VAN_MANUFACTURER = /^.{3,}$/

  def initialize(number, kind, manufacturer)
    @number = number
    @kind = kind
    @manufacturer = manufacturer
    validate!
    @status = 'free'
  end

  protected

  def validate!
    raise ArgumentError, 'У вагона должен быть номер - не менее 1 цифры' if number !~ VAN_NUMBER
    raise ArgumentError, 'Проверьте правильность заполнения типа вагона - не менее 2 символов' if kind !~ VAN_KIND
    raise ArgumentError, 'Проверьте правильность заполнения наименования производителя - не менее 3 символов' if manufacturer !~ VAN_MANUFACTURER
    true
  end
end
