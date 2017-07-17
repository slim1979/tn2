module VanMethods
  # private

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

  def taken
    print 'Какой объем хотите занять?: '
    gets.to_i
  end

  def van_number
    @vans.empty? ? 1 : @vans[-1].number + 1
  end

  def exists_van_number
    print 'Введите номер вагона: '
    gets.to_i
  end

  def van_kind
    puts 'Укажите вид вагона: '
    print '==> '
    gets.strip.chomp
  end

  def van_seats
    print 'Введите количество мест в вагоне: '
    gets.to_i
  end

  def van_volume
    print 'Введите доступный объем вагона: '
    gets.to_i
  end

  def van_manufacturer
    print 'Укажите производителя вагона: '
    gets.strip.chomp
  end

  def create_passenger_van
    @vans << PassengerVan.new(van_number, van_kind, van_seats, van_manufacturer)
    puts "пассажирский вагон ##{@vans[-1].number} создан."
  end

  def create_cargo_van
    @vans << CargoVan.new(van_number, van_kind, van_volume, van_manufacturer)
    puts "Грузовой вагон ##{@vans[-1].number} создан"
  end

  def van_info_according_to_kind(van)
    if van.is_a? PassengerVan
      puts "  Вагон №#{van.number}. #{van.type}, свободных мест: #{van.free_seats}, продано мест: #{van.solded_seats}"
    elsif van.is_a? CargoVan
      puts "  Вагон №#{van.number}. #{van.type}, свободный объем: #{van.free_volume}, занятый объем: #{van.occupied_volume}"
    end
  end

  def buy_place_in_passenger_van
    if PassengerVan.instances.nil?
      puts 'Сначала надо создать пассажирский вагон'
    elsif PassengerVan.instances
      puts 'Выберите станцию.'
      trains_count
      trains_list_on_station
      train_and_van_choise
    end
  end

  def buy_place_in_cargo_van
    if CargoVan.instances.nil?
      puts 'Сначала надо создать грузовой вагон'
    elsif CargoVan.instances
      puts 'Выберите станцию.'
      trains_count
      trains_list_on_station
      train_and_van_choise
    end
  end

  def train_and_van_choise
    train = Train.find[exists_train_id]
    index = train_vans_index train, exists_van_number
    if train.is_a? PassengerTrain
      train.vans[index].buy_ticket
    elsif train.is_a? CargoTrain
      train.vans[index].take_volume(taken)
    else
      didnt_understand_you
    end
  end

  def all_vans_map_index(number)
    @vans.map(&:number).index number
  end

  def train_vans_index(train, number)
    train.vans.map(&:number).index number
  end
end
