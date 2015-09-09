require_relative '../lib/night_write'

class NightWriteTest < Minitest::Test
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
  # outputs braille characters to a file
end
