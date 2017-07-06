module VanMethods
  def create_van
    puts 'Какой вагон Вы хотите создать?'
    print '(п)ассажирский или (г)рузовой: '
    type = gets.strip.chomp.downcase
    print 'Вид - Спальный (СВ), Купейный (КВ): ' if %w[п g].include?(type)
    print 'Вид - Угольный, Зерновой, Цистерна: ' if %w[г u].include?(type)
    kind = gets.strip.chomp
    print 'Укажите производитя вагона: '
    manufacturer = gets.strip.chomp
    adding_to_vans(type, kind, manufacturer)
  end

  def adding_to_vans(type, kind, manufacturer)
    number = @vans.empty? ? 1 : @vans[-1].number + 1
    if %w[п g].include?(type)
      @vans << PassengerVan.new(number, kind, manufacturer)
      "Пассажиркий вагон ##{@vans[-1].number} создан."
    elsif %w[г u].include?(type)
      @vans << CargoVan.new(number, kind, manufacturer)
      "Грузовой вагон ##{@vans[-1].number} создан"
    else
      'Такого типа вагонов не существует. Попробуйте еще раз. Отмена.'
    end
  end
end
