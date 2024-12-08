# frozen_string_literal: true

module Advent2024
  class ResonantCollinearity
    attr_reader :city, :antennas

    def initialize(map)
      @city = Advent2024::Map.new(map.grid)

      find_antennas
      @antinodes = {}
    end

    def self.from_file(name)
      map = Advent2024::Map.from_file(name)

      ResonantCollinearity.new(map)
    end

    def unique_antinode_locations
      @antinodes.map { |k, nodes| nodes }.flatten.compact.uniq 
    end

    def calculate_all_antinodes
      @antinodes = {}
      @antennas.keys.each do |key|
        @antinodes[key] ||= []
        @antinodes[key] = antinodes_for(key)
      end
    end

    def calculate_all_antinodes_with_harmonics
      @antinodes = {}
      @antennas.keys.each do |key|
        @antinodes[key] ||= []
        @antinodes[key] = antinodes_with_harmonics_for(key)
      end
    end

    def antinodes_for(key)
      antis = []
      @antennas[key].each do |a|
        @antennas[key].each do |other|
          next if other.equal?(a)
          diff = other - a
          col = other + diff
          antis << col unless @city.out_of_bounds?(col)
        end
      end

      antis.uniq
    end

    def antinodes_with_harmonics_for(key)
      antis = []
      @antennas[key].each do |a|
        @antennas[key].each do |other|
          next if other.equal?(a)
          diff = other - a
          current = a + diff
          until @city.out_of_bounds?(current) do
            antis << current
            current += diff
          end
        end
      end

      antis.uniq
    end


    private

    def find_antennas
      @antennas = {}
      @city.scan do |pos, cell|
        if cell =~ /[A-Za-z0-9]/
          @antennas[cell] ||= []
          @antennas[cell] << pos
        end
        true
      end
    end
  end

  class Day08
    def self.run(argv)
      res = ResonantCollinearity.from_file(argv[0])
      res.calculate_all_antinodes
      puts "Part 1: #{res.unique_antinode_locations.size}"

      res.calculate_all_antinodes_with_harmonics
      puts "Part 2: #{res.unique_antinode_locations.size}"
    end
  end
end
