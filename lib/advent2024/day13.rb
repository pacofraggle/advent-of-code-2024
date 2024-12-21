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

      def prize_correction(correction)
        @prize.row += correction
        @prize.col += correction
      end

      def solution
        if all_zeros?(a) && all_zeros?(b) && all_zeros?(prize)
          # This case should not be part of the problem,
          # but including it for completeness
          raise "Multiple solutions. Not prepared for that yet"
        end

        det = det(a, b)

        if det == 0
          if det(b, prize) == 0 && det(a, prize) == 0
            # rank A = rank Ab = 1
            raise "Multiple solutions. Not prepared for that yet"
          end
          # rank A < rank Ab. No solution
          return nil
        end

        # rank A = rank Ab = 2. Unique solution
        # Keep only if integer
        x, rem = det(prize, b).divmod(det)
        return nil unless rem == 0

        y, rem = det(a, prize).divmod(det)
        return nil unless rem == 0

        [x, y]
      end

      private

      def det(a, b)
        a.row*b.col - a.col*b.row
      end

      def all_zeros?(a)
        a.row == 0 && a.col == 0
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

    def correct_prizes(correction)
      machines.each { |machine| machine.prize_correction(correction) }
    end

    def min_tokens
      solutions.compact.inject(0) do |total, sol|
        total + (sol[0]*3 + sol[1])
      end
    end

    def solutions
      machines.map do |machine| 
        sol = machine.solution
        puts "#{machine} | #{sol}"
        sol
      end
    end
  end

  class Day13
    def self.run(argv)
      # I kept getting 63794 is too high
      # I HAD COPIED THE INPUT TWICE and my brute force
      # solution wouldn't work !!!!!
      #
      # I had a clear idea that this had an algebraic solution analyzing
      # the equations system, however the min path wording was confusing
      # I suspected integer programming, but I kept feeling that it was
      # simply a system of equations
      # I also feared that indeterminate systems would lead to several
      # solutions from which I'd have to find which one is integer
      # In the end, I left the code raising exceptions in that case but
      # the problem did not present any machines of that kind
      #
      # I got stuck for 7 days. Unit testing dismissed for this exercise

      claw = ClawContraption.from_file(argv[0])
      puts "Part 1: #{claw.min_tokens}"

      claw.correct_prizes(10000000000000)
      puts "Part 2: #{claw.min_tokens}"
    end
  end
end
