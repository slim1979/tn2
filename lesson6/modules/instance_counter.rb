# module InstanceCounter
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # module ClassMethods
  module ClassMethods
    attr_reader :instances

    def increase_counter
      @instances ||= 0
      @instances += 1
    end
  end

  # module InstanceMethods
  module InstanceMethods
    private

    def register_instances
      self.class.increase_counter
    end
  end
end
