# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class MultiplierComputerTest < Minitest::Test
    def sample
      "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    end

    def complete_sample
      "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    end

    def test_sample
      comp = MultiplierComputer.new

      comp.add_section(sample)

      assert_equal [ "mul(2,4)", "mul(5,5)", "mul(11,8)", "mul(8,5)" ], comp.instructions
      assert_equal 161, comp.add_multiplications
    end

    def test_complete_sample
      comp = MultiplierComputer.new

      comp.add_section(complete_sample)

      assert_equal 48, comp.add_enablable_multiplications
    end
  end
end


