# class Station
class Station

  attr_reader :name
  
  def initialize(name)
    @name = name
    @trains = []
  end

  def train_arrival(train)
    @trains << train
    "Train #{train.id} has been arrived"
  end

  def train_departure(train)
    @trains.delete(train)
    "Train #{train.id} has been departed"
  end

  def type(type)
    @trains.count { |train| train.type == type }
  end
end
