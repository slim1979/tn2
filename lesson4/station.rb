# class Station
class Station

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def train_arrival(train)
    @trains << train
    "Поезд #{train.id} прибыл на станцию!"
  end

  def train_departure(train)
    @trains.delete(train)
    "Поезд #{train.id} покинул станцию!"
  end

  def type(type)
    @trains.count { |train| train.type == type }
  end
end
