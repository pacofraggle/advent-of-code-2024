# frozen_string_literal: true

module Advent2024
  class ListOfLocations
    def initialize
      @group_a = []
      @group_b = []
    end

    def self.from_file(name)
      problem = ListOfLocations.new
      Advent2024.read_data(name) do |words|
        problem.add_a_and_b(words[0].to_i, words[-1].to_i)
      end

      problem
    end

    def add_a_and_b(a, b)
      @group_a << a
      @group_b << b
    end

    def locations
      @group_a.sort!
      @group_b.sort!

      total = 0
      @group_a.each_with_index do |v, i|
        diff = (v - @group_b[i]).abs
        total += diff
      end

      total
    end

    def similarity_score
      @group_a.sort!
      @group_b.sort!

      simil_total = 0
      @group_a.each do |v|
        times = (@group_b.find_all { |x| x == v }).size
        simil_total += v*times
      end

      simil_total
    end
  end

  class Day01
    def self.run(argv)
      lol = ListOfLocations.from_file(argv[0])
      puts "Part 1: #{lol.locations}"
      puts "Part 2: #{lol.similarity_score}"
    end
  end
end


