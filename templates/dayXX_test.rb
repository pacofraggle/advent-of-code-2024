# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class XXXTest < Minitest::Test
    def sample
      str = <<~EOS
      EOS
    end

    def test_
    end

    def build_from_sample
      sut = XXX.new
      Advent2024.array_from_string_lines(sample, / /).each do |line|
        sut.add_line(line)
      end

      sut
    end
  end
end
