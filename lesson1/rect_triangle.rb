puts 'Здравствуйте. Введите значения сторон треугольника: '
print '1 => '
a = gets.chomp.to_f
print '2 => '
b = gets.chomp.to_f
print '3 => '
c = gets.chomp.to_f

#массив для сторон треугольника
arr = []
arr << a << b << c
arr.sort!

# проверка на существование треугольника
if (a < b + c) && (a > b - c) && (b < a + c) && (b > a - c) && (c < a + b) && (c > a - b)
  puts 'Вы ввели правильные размеры треугольника.'

#получение минимальных и максимальных значений
  min1 = arr[0]
  min2 = arr[1]
  max = arr[2]

#вычисление равенства сторон
  if min1 == min2 && min1 == max
    adv_info = ', равносторонний.'
  elsif min1 == min2 || min1 == max || min2 == max
    adv_info = ', равнобедренный.'
  else
    adv_info = ''
  end
#вычисление типа треугольника
  if max**2 == min1**2 + min2**2
    puts 'Этот треугольник прямоугольный' + adv_info
  elsif max**2 < min1**2 + min2**2
    puts 'Этот треугольник остроугольный' + adv_info
  else
    puts 'Этот треугольник тупоугольный' + adv_info
  end

else
  puts 'С такими сторонами треугольник не получается.'
  puts "Третья сторона в этом треугольнике должна равняться #{Math.sqrt(a**2 + b**2).to_i}"
end
