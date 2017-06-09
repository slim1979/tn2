letters = %w[а е ё и о у ы э ю я]
range = ('а'..'я').to_a.insert(6, 'ё')
hash = {}
letters.each do |letter|
  hash[letter] = (range.index letter) + 1 if range.include? letter
end
