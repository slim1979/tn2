module VanMethods
  def create_van
    puts 'Какой вагон Вы хотите создать?'
    print '(п)ассажирский или (г)рузовой: '
    type = gets.strip.chomp.downcase
    create_passenger_van if %w[п g].include? type
    create_cargo_van if %w[г u].include? type
    raise ArgumentError, 'Неверный тип вагона!' unless %w[п г g u].include? type
  rescue ArgumentError => e
    puts_with_effects e.to_s
  end

  def number
    @vans.empty? ? 1 : @vans[-1].number + 1
  end

  def kind
    puts 'Укажите вид вагона: '
    print '==> '
    gets.strip.chomp
  end

  def manufacturer
    print 'Укажите производителя вагона: '
    gets.strip.chomp
  end

  def create_passenger_van
    @vans << PassengerVan.new(number, kind, manufacturer)
    puts "Пассажиркий вагон ##{@vans[-1].number} создан."
  end

  def create_cargo_van
    @vans << CargoVan.new(number, kind, manufacturer)
    puts "Грузовой вагон ##{@vans[-1].number} создан"
  end
end
