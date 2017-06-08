puts 'Здравствуйте. Введите значения коэффициентов: '
print '1 => '
a = gets.chomp.to_i
print '2 => '
b = gets.chomp.to_i
print '3 => '
c = gets.chomp.to_i

discr = (b**2 - 4 * a * c)

if discr > 0
  discr_sqrt = Math.sqrt(discr).to_i
  x1 = (-b + discr_sqrt) / (2 * a)
  x2 = (-b - discr_sqrt) / (2 * a)
  puts "Квадратное уравнение имеет два корня х1: #{x1} и х2: #{x2}. Дискриминант: #{discr}"
elsif discr.zero?
  x1 = -b / (2 * a)
  puts "Квадратное уравнение имеет один корень х1: #{x1}. Дискриминант: #{discr}"
else
  puts "Квадратное уравнение не имеет корней. Дискриминант: #{discr}"
end
