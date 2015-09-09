require_relative '../lib/night_write'
require 'pry'

class NightWriteTest < Minitest::Test
  def setup
    @output_file = 'braille.txt'
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
    assert_equal "0.\n00\n..", NightWrite.character_to_braille('h')
    assert_equal "0.\n0.\n..", NightWrite.character_to_braille('b')
    assert_equal "00\n.0\n00", NightWrite.character_to_braille('y')
  end

  def test_outputs_braille_characters_to_a_file
    NightWrite.export(@output_file, NightWrite.character_to_braille('h'))
    assert_equal "0.\n00\n..", File.read(@output_file)
  end

  def test_translates_a_sentence_to_braille
    hello_world_braille =
    <<-BRAILLE
    0.0.0.0.0....00.0.0.00
    00.00.0..0..00.0000..0
    ....0.0.0....00.0.0...
    BRAILLE
    # .chomp
    assert_equal hello_world_braille.chomp, NightWrite.to_braille('hello world')
  end
  # translates braille to normal characters
end
