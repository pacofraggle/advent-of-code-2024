# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class BridgeRepairTest < Minitest::Test
    def sample
      str = <<~EOS
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
      EOS
    end

    def test_read_equations
      rep = build_from_sample([:+, :*])

      assert_equal 9, rep.equations.size
      assert_equal 190, rep.equations[0].test_result
      assert_equal [10, 19], rep.equations[0].coeficients
    end

    def test_calculations
      assert_equal 9, BridgeRepair::Calculator.calculate([1, 2, 3], [:+, :*])
      assert_equal 94213, BridgeRepair::Calculator.calculate([94, 213], [:l])
    end

    def test_operate
      eq = BridgeRepair::Equation.new(190, [10, 19])

      assert_equal 29, eq.operate([:+])
      refute eq.correct?([:+])
      assert_equal 190, eq.operate([:*])
      assert eq.correct?([:*])
    end

    def test_simple_calibration
      rep = build_from_sample([:+, :*])

      assert_equal 3749, rep.total_calibration
    end

    def test_extra_calibration
      rep = build_from_sample([:+, :*, :l])

      assert_equal 11387, rep.total_calibration

    end

    def build_from_sample(operators)
      rep = BridgeRepair.new(operators)
      Advent2024.array_from_string_lines(sample, / /).each do |line|
        rep.add_line(line)
      end

      rep
    end
  end
end
