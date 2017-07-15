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

  def volume
    print 'Какой объем хотите занять?: '
    gets.to_i
  end

  def take_volume
    taken = volume unless free_volume.zero?
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
