class NightWrite
  def self.character_to_braille(character)
    top_line = to_braille_top_line(character)
    mid_line = to_braille_mid_line(character)
    bot_line = to_braille_bot_line(character)

    top_line + "\n" + mid_line + "\n" + bot_line
  end

  def self.to_braille_top_line(character)
    case character
    when 'c', 'd', 'f', 'g', 'm',
         'n', 'p', 'q', 'x', 'y'
      '00'
    when 'a', 'b', 'e', 'h', 'k',
         'l', 'o', 'r', 'u', 'v',
         'z'
      '0.'
    when 'i', 'j', 's', 't', 'w'
      '.0'
    else
      raise ArgumentError
    end
  end

  def self.to_braille_mid_line(character)
    case character
    when 'g', 'h', 'j', 'q', 'r',
         't', 'w'
      '00'
    when 'a' 'c', 'k', 'm', 'u',
         'x'
      '..'
    when 'b', 'f', 'i', 'l', 'p',
         's', 'v'
      '0.'
    when 'd', 'e', 'n', 'o', 'y',
         'z'
      '.0'
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
         'j'
      '..'
    when 'k', 'l', 'm', 'n', 'o',
         'p', 'q', 'r', 's', 't'
      '0.'
    when 'w'
      '.0'
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
end


if $PROGRAM_NAME == __FILE__ # if I'm running this file
  input_file = ARGV[0]
  output_file = ARGV[1]

  text = File.read(input_file)
  braille = NightWrite.to_braille(text)
  File.write(output_file, braille.strip)

  puts "Created '#{output_file}' containing #{braille.chars.count} characters"
end
