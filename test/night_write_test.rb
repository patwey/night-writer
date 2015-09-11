require 'night_write'
require 'night_read'
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
    `ruby ./lib/night_write.rb message.txt braille.txt`
    assert $?.success?
  end

  def test_outputs_braille_characters_to_a_file
    export(@output_file, assemble_braille_char('h'))
    assert_equal "0.\n00\n..", File.read(@output_file)
  end

  def test_writes_normal_characters_to_braille
    braille = assemble_braille_char('h')
    assert_equal "0.\n00\n..", braille

    braille = assemble_braille_char('b')
    assert_equal "0.\n0.\n..", braille
  end

  def test_writes_a_sentence_to_braille
    hello_world_braille = "0.0.0.0.0....00.0.0.00\n00.00.0..0..00.0000..0\n....0.0.0....00.0.0..."
    assert_equal hello_world_braille.chomp, NightWrite.to_braille('hello world')
  end

  def test_writes_capital_letters_to_braille
    braille = assemble_braille_char('B')
    assert_equal "..0.\n..0.\n.0..", braille

    braille = assemble_braille_char('H')
    assert_equal "..0.\n..00\n.0..", braille
  end
  def test_only_writes_braille_eighty_characters_wide
    braille = NightWrite.to_braille('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
    assert_equal 6, braille.lines.count
  end
end
