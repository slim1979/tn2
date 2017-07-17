# class Station
class Station
  include InstanceCounter
  include ObjectValidation

  attr_reader :name, :trains

  TITLE_FORMAT = /^[a-zа-я0-9]{3,}-?\s?([a-zа-я0-9]+)?$/i

  @list = {}

  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.list[name] = self
    register_instances
  end

  def self.list
    @list
  end

  def train_arrival(train)
    if trains.include? train
      "У поезда #{train} на станции #{name} был изменен маршрут."
    else
      trains << train
      "Поезд #{train.id} прибыл на станцию #{name}!"
    end
  end

  def train_departure(train)
    trains.delete(train)
    "Поезд #{train.id} покинул станцию #{name}!"
  end

  def each_train
    trains.each { |train| yield train }
  end

  # private

  def validate!
    raise ArgumentError, 'Введенное название не соотвествует требуемому формату.' if name !~ TITLE_FORMAT
    true
  end
end
