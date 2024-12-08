# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class WordSearcherTest < Minitest::Test
    def sample
      str = <<~EOS
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
      EOS
    end

    def test_count_xmas_sample

      searcher = WordSearcher.new
      Advent2024.array_from_string_lines(sample, "").each do |line|
        searcher.add_line(line)
      end

      assert_equal 18, searcher.count_all_directions("XMAS")
    end

    def test_count_mas_sample
      searcher = WordSearcher.new
      Advent2024.array_from_string_lines(sample, "").each do |line|
        searcher.add_line(line)
      end

      assert_equal 9, searcher.count_crosses("MAS")
    end

  end
end


