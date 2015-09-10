require 'pry'

class NightWrite
  def self.to_braille(text)
    chars = text.split('')
    top, mid, bot = '', '', ''
    chars.each do |char|
      unless char == "\n"
        t, m, b = character_to_braille(char)
        top += t
        mid += m
        bot += b
      end
    end
    assemble_braille(top, mid, bot)
  end

  def self.assemble_braille(top, mid, bot)
    top + "\n" + mid + "\n" + bot
  end

  def self.character_to_braille(character)
    top = to_braille_top_line(character)
    mid = to_braille_mid_line(character)
    bot = to_braille_bot_line(character)
    return top, mid, bot
  end

  def self.to_braille_top_line(character)
    case character
    when 'c', 'd', 'f', 'g', 'm',
         'n', 'p', 'q', 'x', 'y'
      '00'
    when ' '
      '..'
    when 'a', 'b', 'e', 'h', 'k',
         'l', 'o', 'r', 'u', 'v',
         'z'
      '0.'
    when 'i', 'j', 's', 't', 'w'
      '.0'
    when 'A'..'Z'
      '..' + to_braille_top_line(character.downcase)
    else
      raise ArgumentError
    end
  end

  def self.to_braille_mid_line(character)
    case character
    when 'g', 'h', 'j', 'q', 'r',
         't', 'w'
      '00'
    when 'a', 'c', 'k', 'm', 'u',
         'x', ' '
      '..'
    when 'b', 'f', 'i', 'l', 'p',
         's', 'v'
      '0.'
    when 'd', 'e', 'n', 'o', 'y',
         'z'
      '.0'
    when 'A'..'Z'
      '..' + to_braille_mid_line(character.downcase)
    else
      raise ArgumentError
    end
  end

  def self.to_braille_bot_line(character)
    case character
    when 'u', 'v', 'x', 'y', 'z'
      '00'
    when 'a', 'b', 'c', 'd', 'e',
         'e', 'f', 'g', 'h', 'i',
         'j', ' '
      '..'
    when 'k', 'l', 'm', 'n', 'o',
         'p', 'q', 'r', 's', 't'
      '0.'
    when 'w'
      '.0'
    when 'A'..'Z'
      '.0' + to_braille_bot_line(character.downcase)
    else
      raise ArgumentError
    end
  end

  def self.echo_characters(string)
    string += "\n" + string + "\n" + string
  end

  def self.export(filename, data)
    File.write(filename, data)
  end

  def self.to_normal_chars(braille)
    # expects braille as a string separated by \n
    top, mid, bot = get_lines(braille)
    braille_chars = braille_lines_to_chars(top, mid, bot)
    normal_chars = braille_to_normal_chars(braille_chars)
    normal_chars.join
  end

  def self.braille_to_normal_chars(braille_chars)
    # what if capital letter??
    braille_map = File.open('braille_mapping.txt')
    normal_chars = []
    braille_chars.each do |braille_char|
      braille_map.rewind # start at the top of the file each time
      equivalent = find_equivalent(braille_char, braille_map)
      normal_chars << equivalent
    end
    normal_chars = capitalize(normal_chars)
  end

  def self.capitalize(normal_chars)
    # expects capital letters to be lowercase letters preceded by CAPITAL
    normal_chars.each_with_index do |char, idx|
      normal_chars[idx + 1].upcase! if char == 'CAPITAL'
    end
    normal_chars.delete('CAPITAL')
    normal_chars
  end

  def self.find_equivalent(braille_char, braille_map)
    braille_map.each_line do |line|
      equivalents = line.chomp.split(',')
      return equivalents[1] if braille_char == equivalents[0]
    end
    nil # neccessary?
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

  def self.get_lines(braille)
    lines = braille.split("\n")
    top = lines[0]
    mid = lines[1]
    bot = lines[2]
    return top, mid, bot
  end
end


if $PROGRAM_NAME == __FILE__ # if I'm running this file
  input_file = ARGV[0]
  output_file = ARGV[1]

  text = File.read(input_file)
  braille = NightWrite.to_braille(text)
  File.write(output_file, braille.strip)

  puts "Created '#{output_file}' containing #{braille.chars.count} characters"
end
