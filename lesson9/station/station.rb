# class Station
class Station
  extend Accessors
  include InstanceCounter
  include Validation

  validate :name, :format, /^[a-zа-я0-9]{3,}-?\s?([a-zа-я0-9]+)?$/i

  attr_reader :name, :trains

  @list = {}

  def initialize(name)
    @name = name
    @trains = []
    self.class.list[name] = self
    register_instances
  end

  class << self
    attr_reader :list
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
end
