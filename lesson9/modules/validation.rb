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
    # private

    def validate!
      self.class.validations.each do |validation|
        method = validation[:validation_type]
        native = validation[:attribute]
        attribute = instance_variable_get("@#{validation[:attribute]}".to_sym)
        args = validation[:args]
        send method, native, attribute, args
      end
    end

    def presence(native, attribute, _args)
      raise ArgumentError, "Значение атрибута #{native} не может быть пустым" if attribute.nil? || attribute.empty? || attribute =~ /^\s+$/i
    end

    def type(native, attribute, attr_class)
      raise ArgumentError, "Атрибут #{native} не соответствует классу #{attr_class[0]}" unless attribute.is_a? attr_class[0]
    end

    def format(native, attribute, regexp)
      raise ArgumentError, "Значение атрибута #{native} не соответствует формату" if attribute !~ regexp[0]
    end

    def valid?
      true if validate!
    rescue StandardError
      false
    end
  end
end
