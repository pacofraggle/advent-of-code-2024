# frozen_string_literal: true

module Advent2024
  class ClawContraption
    class Machine 
      attr_accessor :a, :b, :prize

      def win?(x, y)
        (a*x) + (b*y) == prize
      end

      def to_s
        "A: #{a}, B: #{b}. Prize: #{prize}"
      end
    end

    attr_reader :machines

    def initialize
      @machines = []
    end

    def self.from_file(name)
      claw = ClawContraption.new
      Advent2024.read_data(name, nil) do |line|
        claw.add_line(line)
      end

      claw
    end

    def add_line(line)
      return if line.empty?
      m = line.match(/^Button (?<button>[AB]): X\+(?<x>\d+), Y\+(?<y>\d+)/)
      unless m.nil?
        last = @machines.last
        if last.nil? || !last.prize.nil?
          @machines << Machine.new
          last = @machines.last
        end
        move = Coord.new(m["x"].to_i, m["y"].to_i)
        last.a = move if m["button"] == "A"
        last.b = move if m["button"] == "B"
      end

      m = line.match(/^Prize: X=(?<x>\d+), Y=(?<y>\d+)/)
      unless m.nil?
        last = @machines.last
        last.prize = Coord.new(m["x"].to_i, m["y"].to_i)
      end
    end

    def min_tokens
      total = 0
      machines.each_with_index do |machine, i|
        cost = min_cost_for(machine)
        total += cost unless cost.nil?
      end

      total
    end

    def min_cost_for(machine)
      min = 1000000
      solutions = all_solutions_for(machine)
      solutions.each do |sol|
        cost = (3*sol[0]) + sol[1]
        min = cost if cost < min
      end

      min_cost = min == 1000000 ? nil : min
      binding.pry if solutions.size > 1
      puts "#{machine} (#{solutions.size}) |  cost = #{min_cost}"
      min_cost
    end

    def all_solutions_for(machine)
      solutions = []
      (0..100).each do |x|
        (0..100).each do |y|
          solutions << [x, y] if machine.win?(x, y)
        end
      end
      solutions
    end
  end

  class Day13
    def self.run(argv)
      claw = ClawContraption.from_file(argv[0])
      puts "Part 1: #{claw.min_tokens}"

      # 63794 is too high
      # I HAD COPIED THE INPUT TWICE and my brute force solution wouldn't work !!!!!

      #puts "Part 2: #{prob.method2}"
    end
  end
end
