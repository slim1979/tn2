# class Station
class Station
  include InstanceCounter
  attr_reader :name, :trains
  @list = []

  def initialize(name)
    @name = name
    @trains = []
    self.class.list << self
    register_instances
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
end
