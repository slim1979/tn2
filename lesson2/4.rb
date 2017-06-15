letters = %w[а е ё и о у ы э ю я]
range = ('а'..'я').to_a.insert(0, nil).insert(7, 'ё')
hash = {}
letters.each do |letter|
  hash[letter] = range.index letter if range.include? letter
end
puts hash
