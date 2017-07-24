module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations
    def validate(attribute, validation_type, *args)
      @validations ||= []
      @validations << { attribute: attribute,
                        validation_type: validation_type,
                        args: args }
    end
  end

  module InstanceMethods
    private

    def validate!
      self.class.validations.each do |validation|
        method = validation[:validation_type]
        attribute = instance_variable_get("@#{validation[:attribute]}".to_sym)
        args = validation[:args]
        send method, attribute, args
      end
    end

    def presence(attribute, _args)
      raise ArgumentError, 'Значение атрибута не может быть пустым' if attribute.nil? || attribute.empty? || attribute =~ /^\s+$/i
    end

    def type(attribute, attr_class)
      raise ArgumentError, "Атрибут #{attribute} не соответствует классу #{attr_class[0]}" unless attribute.is_a? attr_class[0]
    end

    def format(attribute, regexp)
      raise ArgumentError, 'Несоответствие формату' if attribute !~ regexp[0]
    end

    def valid?
      if validate!
        true
      else
        false
      end
    end
  end
end
