print 'Здравствуйте. Введите Ваше имя: '
name = gets.chomp.capitalize!
print 'Введите Ваш рост: '
weight = gets.chomp.to_f

opt_weight = weight - 110

if opt_weight < 0
  puts "#{name}, Ваш вес уже в норме."
else
  puts "#{name}, оптимальный вес для Вас - #{opt_weight}"
end
