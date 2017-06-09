arr = { 1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30,
        7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31 }

puts 'Введите дату в формате ДД.ММ.ГГГГ:'
print 'день: '
day = gets.chomp.to_i
print 'месяц: '
month = gets.chomp.to_i
print 'год: '
year = gets.chomp.to_i

# проверка введенных данных на валидность
if !day.zero? && day > 0 && day < 32 && !month.zero? && month > 0 && month < 13 && !year.zero? && year > 0

# поправка на високосный год
arr['02'] = 29 if (year % 4).zero? || (year % 400).zero?
count = 0

# магия Ruby
arr.each do |key, value|
  count += value if key < month
end
puts "Этот день в году #{count + day} по счету"

# обработка неправильного ввода
else
  puts 'Введите правильную дату'
end
