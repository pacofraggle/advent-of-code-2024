# frozen_string_literal: true

module Advent2024
  class XXX
    def initialize
    end

    def self.from_file(name)
      problem = XXX.new
      Advent2024.read_data(name, nil) do |section|
        problem.add_section(section)
      end

      problem
    end
  end

  class DayXX
    def self.run(argv)
      prob = XXX.from_file(argv[0])
      puts "Part 1: #{prob.method}"

      puts "Part 2: #{prob.method2}"
    end
  end
end
