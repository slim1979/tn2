# module Accessors
module Accessors
  def attr_accessor_with_history(*args)
    args.each do |arg|
      arr = "#{arg}_arr".to_sym
      arr = []
      var_name = "@#{arg}".to_sym
      define_method(arg) { instance_variable_get(var_name) }
      define_method("#{arg}=") do |value|
        instance_variable_set(var_name, value)
        arr << value
      end
      define_method("#{arg}_history") { arr }
    end
  end

  def strong_attr_accessor(attr_name, attr_class)
    var_name = "@#{attr_name}".to_sym
    define_method(attr_name) { instance_variable_get(var_name) }
    define_method("#{attr_name}=") do |value|
      raise ArgumentError, "Принимаются значения только класса #{attr_class}" unless value.is_a? attr_class
      instance_variable_set(var_name, value) if value.is_a? attr_class
    end
  end
end
