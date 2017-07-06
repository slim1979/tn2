module ObjectValidation
  def valid?
    validate!
  rescue
    false
  end
end
