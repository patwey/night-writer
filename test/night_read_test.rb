require 'night_read'
require 'pry'

class NightReadTest < Minitest::Test
  def setup
    @output_file = 'output_message.txt'
  end

  def read(chars)
    normal_chars = NightRead.read(chars)
  end

  def export(filename, data)
    NightRead.export(filename, data)
  end

  def test_runs_in_the_command_line
    `ruby ./lib/night_read.rb braille.txt output_message.txt`
    assert $?.success?
  end

  def test_outputs_normal_characters_to_a_file
    export(@output_file, read("0.\n00\n.."))
    assert_equal 'h', File.read(@output_file)
  end

  def test_reads_braille_to_normal_characters
    assert_equal 'h', read("0.\n00\n..")

    hello_world_braille = "0.0.0.0.0....00.0.0.00\n00.00.0..0..00.0000..0\n....0.0.0....00.0.0..."
    assert_equal 'hello world', read(hello_world_braille)
  end

  def test_reads_capital_braille_to_normal_characters
    hello_world_caps_braille = "..0.0.0.0.0....00.0.0.00\n..00.00.0..0..00.0000..0\n.0....0.0.0....00.0.0..."
    normal = read(hello_world_caps_braille)

    assert_equal 'Hello world', normal
  end
end
