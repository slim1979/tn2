list = {}
puts
puts '********************************************************************************************'
puts 'Привествую Вас на нашем сайте. Выбирайте, что понравится.'
puts 'Если решите проверить корзину или приобрести выбранное, наберите stop в наименовании товара.'
puts 'Удачных покупок!'
puts

loop do

  loop do
    print 'Введите название товара: '
    @goods = gets.chomp.strip
    break unless @goods.empty?
  end

  if @goods == 'stop'
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
      puts
    else
      puts
      puts '********************************'
      puts "Общая сумма Вашего заказа #{man_with_last_name_itogo} руб"
      break
    end
  else
    loop do
      print 'Введите количество: '
      @amount = gets.chomp.to_f
      break unless @amount.zero? || @amount < 0
    end

    loop do
      print 'Почем брали?): '
      @price = gets.chomp.to_f
      break unless @price.zero? || @price < 0
    end

    puts

    info = { amount: @amount, price: @price }
    list[@goods] = info
  end
end
