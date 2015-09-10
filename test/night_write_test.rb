require_relative '../lib/night_write'
require 'pry'

class NightWriteTest < Minitest::Test
  def setup
    @output_file = 'braille.txt'
  end

  def assemble_braille_char(char)
    top, mid, bot = NightWrite.character_to_braille(char)
    top.to_s + "\n" + mid.to_s + "\n" + bot.to_s
  end

  def export(filename, data)
    NightWrite.export(filename, data)
  end

  def test_runs_in_the_command_line
    skip
    `ruby ./lib/night_write.rb message.txt braille.txt`
    assert $?.success?
  end

  def test_outputs_the_input_line_three_times
    assert_equal "hello world\nhello world\nhello world", NightWrite.echo_characters('hello world')
  end

  def test_translates_a_normal_character_to_the_braille_equivalent
    braille = assemble_braille_char('h')
    assert_equal "0.\n00\n..", braille

    braille = assemble_braille_char('b')
    assert_equal "0.\n0.\n..", braille

    braille = assemble_braille_char('y')
    assert_equal "00\n.0\n00", braille
  end

  def test_outputs_braille_characters_to_a_file
    export(@output_file, assemble_braille_char('h'))
    assert_equal "0.\n00\n..", File.read(@output_file)
  end

  def test_translates_a_sentence_to_braille
    hello_world_braille ="0.0.0.0.0....00.0.0.00\n00.00.0..0..00.0000..0\n....0.0.0....00.0.0..."
    # .chomp
    assert_equal hello_world_braille.chomp, NightWrite.to_braille('hello world')
  end

  def test_translates_capital_letters
    braille = assemble_braille_char('H')
    assert_equal "..0.\n..00\n.0..", braille
  end
  # translates braille to normal characters

end
