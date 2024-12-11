# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class PlutonianPeeblesTest < Minitest::Test
    def test_read_stones
      line = build_from("0 1 10 99 999")

      assert_equal [0, 1, 10, 99, 999], line.stones
    end

    def test_blinks
      line = build_from("0 1 10 99 999")

      line.blink
      assert_equal [1, 2024, 1, 0, 9, 9, 2021976], line.stones
    end

    def test_blinks_times
      line = build_from("125 17")

      assert_equal "125 17", line.to_s

      line.blink
      assert_equal "253000 1 7", line.to_s

      line.blink
      assert_equal "253 0 2024 14168", line.to_s

      line.blink
      assert_equal "512072 1 20 24 28676032", line.to_s

      line.blink
      assert_equal "512 72 2024 2 0 2 4 2867 6032", line.to_s

      line.blink
      assert_equal "1036288 7 2 20 24 4048 1 4048 8096 28 67 60 32", line.to_s

      line.blink
      assert_equal "2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2", line.to_s
    end

    def test_blinks_times
      line = build_from("125 17")

      line.blink(25)

      assert_equal 55312, line.stones.size
    end

    def build_from(sample)
      Advent2024.array_from_string_lines(sample, / /).each do |line|
        return PlutonianPeebles.new(line.map(&:to_i))
      end
    end
  end
end
