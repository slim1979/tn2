list = {}

loop do

  loop do
    puts
    print 'Товар: '
    @goods = gets.chomp
    break unless @goods.empty?
  end

  unless @goods == 'stop'

    loop do
      print 'Кол-во: '
      @amount = gets.chomp.to_f
      break unless @amount.zero?
    end

    loop do
      print 'Цена за единицу: '
      @price = gets.chomp.to_f
      break unless @price.zero?
    end

    info = { amount: @amount, price: @price }
    list[@goods] = info

  else
    man_with_last_name_itogo = 0
    puts
    puts '********************************'
    puts "Вы заказали #{list.size} товаров"

    list.each do |goods, info|
      sum_by_each_goods = info[:amount] * info[:price]
      puts "#{goods} - #{info[:amount]} шт по #{info[:price]} руб. Сумма: #{sum_by_each_goods}"
      man_with_last_name_itogo += sum_by_each_goods
    end

    puts
    print 'Продолжить покупки? (д/н) '
    continue = gets.chomp.downcase
    if continue == 'y' || continue == 'д'
    else
      puts
      puts '********************************'
      puts "Общая сумма Вашего заказа #{man_with_last_name_itogo} руб"
      break
    end
  end

end
