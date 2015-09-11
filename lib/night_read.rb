require 'pry'

class NightRead
  def self.read(braille)
    # expects braille as a string separated by \n
    if braille.lines.count > 3
      normal_chars = read_multiple_lines(braille)
    else
      normal_chars = translate(braille, 0)
    end
    normal_chars.join
  end

  def self.read_multiple_lines(braille)
    start = 0
    normal_chars = []
    while start < braille.lines.count
      normal_chars << translate(braille, start)
      start += 3
    end
    normal_chars
  end

  def self.translate(braille, start)
    top, mid, bot = get_lines(braille, start)
    braille_chars = braille_lines_to_chars(top, mid, bot)
    braille_to_normal_chars(braille_chars)
  end

  def self.get_lines(braille, start)
    lines = braille.split("\n")
    top = lines[start]
    mid = lines[start + 1]
    bot = lines[start + 2]
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

  def self.braille_to_normal_chars(braille_chars)
    normal_chars = []
    if array?(braille_chars)
      normal_chars = normal_chars_from_array(braille_chars)
    elsif string?(braille_chars) # if a single character
      equivalent = find_equivalent(braille_chars)
      normal_chars << equivalent
    end
    capitalize(normal_chars)
  end

  def self.normal_chars_from_array(braille_chars)
    # expects array of braille characters
    normal_chars = []
    braille_chars.each do |braille_char|
      equivalent = find_equivalent(braille_char)
      normal_chars << equivalent
    end
    normal_chars
  end

  def self.find_equivalent(braille_char)
    braille_map = open_file('braille_mapping.txt')
    braille_map.each_line do |line|
      equivalents = line.chomp.split(',')
      if braille_char == equivalents[0]
        braille_map.rewind
        return equivalents[1]
      end
    end
  end

  def self.capitalize(normal_chars)
    # expects capital letters to be lowercase letters preceded by CAPITAL
    normal_chars.each_with_index do |char, idx|
      normal_chars[idx + 1].upcase! if char == 'CAPITAL'
    end
    normal_chars.delete('CAPITAL')
    normal_chars
  end

  def self.string?(object)
    object.class == String
  end

  def self.array?(object)
    object.class == Array
  end

  def self.export(filename, data)
    File.write(filename, data)
  end

  def self.open_file(filename)
    File.open(filename)
  end
end

if $PROGRAM_NAME == __FILE__ # if I'm running this file
  input_file = ARGV[0]
  output_file = ARGV[1]

  braille = File.read(input_file)
  text = NightRead.read(braille)
  NightRead.export(output_file, text.strip)

  puts "Created '#{output_file}' containing #{text.chars.count} characters"
end
