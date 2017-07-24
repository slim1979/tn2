class CargoVan < Van
  include InstanceCounter

  attr_accessor :free_volume, :occupied_volume
  attr_reader :van_volume

  validate :kind, :format, /^[a-zа-я0-9]{2,}-?\s?([a-zа-я0-9]+)?$/i
  validate :van_volume, :type, Integer
  validate :manufacturer, :format, /^[a-zа-я0-9]{3,}$/i

  def initialize(number, kind, van_volume, manufacturer)
    super
    @type = 'грузовой'
    @van_volume = van_volume
    @free_volume = van_volume
    register_instances
  end

  def take_volume(taken)
    if free_volume.zero?
      'Свободного места в вагоне больше нет.'
    elsif free_volume - taken < 0
      "Нельзя занять столько места. Свободного места в вагоне - #{free_volume}."
    else
      self.occupied_volume ||= 0
      self.occupied_volume += taken
      self.free_volume -= taken
      "Место успешно куплено. Вы заняли #{taken}м3 объема вагона"
    end
  end
end
