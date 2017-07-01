# class Station
class Station

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
