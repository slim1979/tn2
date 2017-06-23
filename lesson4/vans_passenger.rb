class PassengerVan
  include Vans

  attr_reader :type, :number

  # def re_kind(kind)
  #   self.kind = kind && "Changed to #{kind}" if %w[СВ КВ ПВ].include? kind
  # end

  private

  attr_writer :type
end
