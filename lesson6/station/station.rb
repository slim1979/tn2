# class Station
class Station
  include InstanceCounter
  include ObjectValidation

  attr_reader :name, :trains

  TITLE_FORMAT = /^[a-zа-я]{3,}$/i

  @list = []

  def initialize(name)
    @name = name
    @trains = []
    self.class.list << self
    register_instances
    validate!
  end

  def self.list
    @list
  end

  def train_arrival(train)
    @trains << train
    "Поезд #{train.id} прибыл на станцию #{name}!"
  end

  def train_departure(train)
    @trains.delete(train)
    "Поезд #{train.id} покинул станцию #{name}!"
  end

  private

  def validate!
    raise ArgumentError, 'Название не может быть короче 3 символов' if name !~ TITLE_FORMAT
    true
  end

end
