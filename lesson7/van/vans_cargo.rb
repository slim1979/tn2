class CargoVan < Van
  include InstanceCounter

  attr_accessor :free_volume, :occupied_volume
  attr_reader :van_volume

  def initialize(number, kind, van_volume, manufacturer)
    super
    @type = 'грузовой'
    @van_volume = van_volume
    @free_volume = van_volume
    register_instances
  end

  def take_volume(volume)
    if free_volume - volume <= 0
      "Нельзя занять столько места. Свободного места в вагоне - #{free_volume}."
    elsif free_volume.zero?
      'Свободного места в вагоне больше нет.'
    else
      self.occupied_volume ||= 0
      self.occupied_volume += volume
      self.free_volume -= volume
      "Место успешно куплено. Вы заняли #{volume}м3 объема вагона"
    end
  end
end
