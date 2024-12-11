# frozen_string_literal: true

module Advent2024
  class PlutonianPeebles
    attr_reader :stones

    def initialize(stones = [])
      @stones = stones
      @cache = {}
    end

    def self.from_file(name)
      Advent2024.read_data(name, / /) do |line|
        return PlutonianPeebles.new(line.map(&:to_i))
      end

      nil
    end

    def blink(n=1)
      n.times do |i|
        printf "%d: ", i
        transform
        puts info
      end
    end

    def size
      stones.size
    end

    def to_s
      @stones.map(&:to_s).join(" ")
    end

    def info
      size
    end

    protected

    def transform
      stones.each_with_index do |value, i|
        @stones[i] = choice_for(value)
      end

      @stones.flatten!
    end

    def choice_for(value)
      return [1] if value == 0

      cached = @cache[value]
      return cached unless cached.nil?

      add = halves(value)
      add = [value*2024] if add.nil?
      @cache[value] = add

      add
    end

    def halves(value)
      str = value.to_s
      size = str.size
      return unless size.even?

      half = size / 2

      return [Integer(str[0..half-1], 10), Integer(str[half..], 10)]
    end
  end

  class UnorderedPlutonianPeebles < PlutonianPeebles
    def self.from_file(name)
      Advent2024.read_data(name, / /) do |line|
        return UnorderedPlutonianPeebles.new(line.map(&:to_i))
      end

      nil
    end

    def initialize(stones = [])
      super

      @stones_count = {}
      @stones.each do |value|
        @stones_count[value] ||= 0
        @stones_count[value] = @stones_count[value] + 1
      end
    end

    def size
      @stones_count.values.sum
    end

    def to_s
      @stones_count.to_s
    end

    def info
      "#{@stones_count.size} vs #{size}"
    end

    protected

    def transform
      new_count = {}
      @stones_count.each do |value, count|
        transformations = choice_for(value)
        transformations.each do |new_value|
          new_count[new_value] ||= 0
          new_count[new_value] = new_count[new_value] + count
        end
      end
    
      @stones_count = new_count
    end
  end

  # Part2 totally failed with the original approach )have a real array which I could print and check)
  # I optimized it with caches but it was pointless: the results size made it impossible to keep in memory
  #
  # I tried to cache halves generation. It was faster but not enough over 30 blinks
  # I read about the ordering from people who had encountered a similar situation in 2021
  # This sentence "Other times, a stone might split in two, causing all the other stones to shift over a bit" and
  # my need to TDD the problem descriptions made miss the faact. Leason learnt. I hope.
  class Day11
    def self.run(argv)
      line = PlutonianPeebles.from_file(argv[0])
      line.blink(25)
      puts "Part 1: #{line.size}"

      fast_line = UnorderedPlutonianPeebles.from_file(argv[0])
      fast_line.blink(25)
      puts "Part 1: #{fast_line.size}"
      fast_line.blink(50)
      puts "Part 2: #{fast_line.size}"
    end
  end
end
