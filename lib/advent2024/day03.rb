module Advent2024
  class MultiplierComputer

    def initialize
      @sections = []
    end

    def add_section(section)
      @sections << section
    end

    def self.from_file(name)
      problem = MultiplierComputer.new
      Advent2024.read_data(name, nil) do |section|
        problem.add_section(section)
      end

      problem
    end

    def instructions
      @sections.map do |section|
        section.scan(/mul\(\d{1,3},\d{1,3}\)/)
      end.flatten
    end

    def enablable_instructions
      @sections.map do |section|
        section.scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/)
      end.flatten
    end


    def add_multiplications
      instructions.inject(0) { |sum, op| sum += mul(op) }
    end

    def add_enablable_multiplications
      @enabled = true
      enablable_instructions.inject(0) do |sum, op|
        state(op)
        if op.start_with?(/mul/) && @enabled
          sum += mul(op)
        else
          sum += 0
        end
      end
    end


    private

    def state(op)
      return if op.start_with?(/mul/)

      @enabled = !op.start_with?(/don't/)
    end

    def mul(str)
      a, b = str.split(/,/)

      a.delete("mul(").to_i * b.delete(")").to_i
    end
  end

  class Day03
    def self.run(argv)
      comp = MultiplierComputer.from_file(argv[0])
      puts "Part 1: #{comp.add_multiplications}"
      puts "Part 2: #{comp.add_enablable_multiplications}"
    end
  end
end


