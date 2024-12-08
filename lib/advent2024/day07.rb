# frozen_string_literal: true

class Integer
  def l(other)
    "#{self.to_s}#{other.to_s}".to_i
  end
end
module Advent2024
  class BridgeRepair
    class Calculator
      def self.calculate(numbers=[], operations)
        nums = [0] + numbers
        operators = [:+] + operations

        total = 0
        numbers.each_with_index do |num, i|
          op = operators[i] 
          total = total.send(op, num)
        end

        total
      end
    end

    class Combinations
      attr_reader :operators

      def initialize(operators=[])
        @base = operators.size
        @operators = operators
        @cache = {}
      end

      def call(length)
        @cache[length] ||= all_for(length)
      end

      private

      def all_for(length)
        options = []
        i = 0
        value = value_to_array(i.to_s(@base).rjust(length, "0"))
        # TODO: this should stop at base^length, not checking string sizes
        while value.length <= length do
          options << value
          i += 1
          value = value_to_array(i.to_s(@base).rjust(length, "0"))
        end

        options
      end

      def value_to_array(value)
        value.each_char.map { |c| @operators[c.to_i] }
      end
    end

    class Equation
      attr_reader :test_result, :coeficients

      def initialize(test_result, coeficients)
        @test_result = test_result
        @coeficients = coeficients
      end

      def operate(operators)
        Calculator.calculate(coeficients, operators)
      end

      def correct?(operators)
        operate(operators) == test_result
      end

      def possibly_true?(options)
        options.any? { |op| correct?(op) }
      end
    end

    attr_reader :equations

    def initialize(operators=[])
      @combinator = Combinations.new(operators)
      @equations = []
    end

    def self.from_file(name, operators)
      rep = BridgeRepair.new(operators)
      Advent2024.read_data(name, / /) do |line|
        rep.add_line(line)
      end

      rep
    end

    def add_line(line)
      @equations << Equation.new(line[0].split(/:/)[0].to_i, line[1..-1].map { |c| c.to_i })
    end

    def total_calibration
      ok = @equations.select do |eq|
        options = @combinator.call(eq.coeficients.size-1)

        eq.possibly_true?(options)
      end
      
      ok.sum(&:test_result)
    end
  end

  class Day07
    def self.run(argv)
      rep = BridgeRepair.from_file(argv[0], [:+, :*])
      puts "Part 1: #{rep.total_calibration}"

      extra_rep = BridgeRepair.from_file(argv[0], [:+, :*, :l])
      puts "Part 2: #{extra_rep.total_calibration}"
    end
  end
end
