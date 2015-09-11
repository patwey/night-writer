class NightRead
  def self.braille_to_normal_chars(braille_chars)
    braille_map = File.open('braille_mapping.txt')
    normal_chars = []
    if braille_chars.class == Array
      braille_chars.each do |braille_char|
        braille_map.rewind # start at the top of the file each time
        equivalent = find_equivalent(braille_char, braille_map)
        normal_chars << equivalent
      end
    elsif braille_chars.class == String # if a single char
      equivalent = find_equivalent(braille_chars, braille_map)
      normal_chars << equivalent
    end # add another edge case?
    normal_chars = capitalize(normal_chars)
  end

  def self.read(braille)
    # expects braille as a string separated by \n
    top, mid, bot = get_lines(braille)
    braille_chars = braille_lines_to_chars(top, mid, bot)
    normal_chars = braille_to_normal_chars(braille_chars)
    normal_chars.join
  end

  def self.get_lines(braille)
    lines = braille.split("\n")
    top = lines[0]
    mid = lines[1]
    bot = lines[2]
    return top, mid, bot
  end

  def self.braille_lines_to_chars(top, mid, bot)
    braille_chars = []
    count = 0
    while count < top.size
      char = [top.slice(count, 2), mid.slice(count, 2),
             bot.slice(count, 2)].flatten.join('')
      braille_chars << char
      count += 2
    end
    braille_chars
  end

  def self.find_equivalent(braille_char, braille_map)
    braille_map.each_line do |line|
      equivalents = line.chomp.split(',')
      return equivalents[1] if braille_char == equivalents[0]
    end
    nil # neccessary?
  end

  def self.capitalize(normal_chars)
    # expects capital letters to be lowercase letters preceded by CAPITAL
    normal_chars.each_with_index do |char, idx|
      normal_chars[idx + 1].upcase! if char == 'CAPITAL'
    end
    normal_chars.delete('CAPITAL')
    normal_chars
  end

  def self.export(filename, data)
    File.write(filename, data)
  end
end

if $PROGRAM_NAME == __FILE__ # if I'm running this file
  input_file = ARGV[0]
  output_file = ARGV[1]

  braille = File.read(input_file)
  text = NightRead.read(braille)
  File.write(output_file, text.strip)

  puts "Created '#{output_file}' containing #{text.chars.count} characters"
end
