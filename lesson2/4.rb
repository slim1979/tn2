a = %w[а е ё и о у э ю я]
b = {}
count = 1
('а'..'я').each do |l| # перебираем диапазон
  a.each do |arr|   # находим гласные
    if l == arr
      b[l] = count  # присваиваем порядковый номер
    else
    end
  end
  # компенсируем отсутсвие ё в диапазоне
  if count == 7
    b['ё'] = count
    count += 2
  else
    count += 1
  end
end
puts b
