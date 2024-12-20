# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class ClawContrptionTest < Minitest::Test
    def sample
      str = <<~EOS
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
      EOS
    end

    def test_
      claws = build_from_sample
      puts claws.min_tokens
    end

    def build_from_sample
      claw = ClawContraption.new
      Advent2024.array_from_string_lines(sample).each do |line|
        claw.add_line(line)
      end

      claw
    end
  end
end
