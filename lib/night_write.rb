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
    when 'A'..'Z' # break into its own method
      '..' + to_braille_top_line(character.downcase)
    # when '0'..'9' # break into its own method
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
    # when '0'..'9'
    #   '.0'
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
    # when '0'..'9'
    #   '00'
    else
      raise ArgumentError
    end
  end

  def self.export(filename, data)
    File.write(filename, data)
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
