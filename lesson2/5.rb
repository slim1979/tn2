
arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


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
  arr[1] = 29 if (year % 4).zero? && !(year % 100).zero? || (year % 400).zero?

  count = 0
  i = 1

  while i < month

    count += arr[i-1]

    i += 1
  end

  puts "Этот день в году #{count + day} по счету"

# обработка неправильного ввода
else
  puts 'Введите правильную дату'
end
