a = []
i = 1
a << i
while i < 101
  a << i
  i += a[-2]
end
