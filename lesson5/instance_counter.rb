module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    def counter
      @instances += 1
    end

    private

    def count_to_zero
      @instances = 0
    end
  end

  module InstanceMethods
    private

    def register_instances
      self.class.counter
    end
  end
end
