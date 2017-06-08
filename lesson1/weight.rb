print 'Здравствуйте. Введите Ваше имя: '
name = gets.chomp.capitalize!
print 'Введите Ваш вес: '
weight = gets.chomp

opt_weight = weight.to_i - 110

if opt_weight < 0
  puts "#{name}, Ваш вес уже в норме."
else
  puts "#{name}, оптимальный вес для Вас - #{opt_weight}"
end
