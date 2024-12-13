# frozen_string_literal: true

module Advent2024
  class GardenGroups
    DELTAS = [
      Coord.new(0, -1).freeze, # W
      Coord.new(-1, 0).freeze, # N
      Coord.new(0, 1).freeze,  # S
      Coord.new(1, 0).freeze   # E
    ].freeze
 
    attr_reader :map, :regions_map

    def initialize(map)
      @map = map
    end

    def self.from_file(name)
      GardenGroups.new(Map.from_file(name))
    end

    def find_regions
      return @regions_map unless @regions_map.nil?

      @regions_map = Advent2024::Map.blank(@map.height, @map.width, 0)
      current_region = 0
      @regions = {}
      
      map.scan do |coord, plant|
        next true if @regions_map.value(coord) > 0

        current_region += 1
        @regions[current_region] = plant
        find_region_for(coord, plant, current_region)
        true
      end

      analyze_regions
    end

    def find_region_for(coord, plant, region_id)
      # Iterative DFS
      stack = []
      stack.push(coord)
      until stack.empty? do
        v = stack.pop

        @regions_map.set(v, region_id)

        options = adjacent(@map, v).select do |c|
          @map.value(c) == plant && @regions_map.value(c) == 0
        end
        options.each { |option| stack.push(option) }
      end
    end

    def analyze_regions
      @region_areas = Hash.new(0)
      @region_perimeters = {}
      @regions_map.scan do |coord, id|
        @region_areas[id] += 1
        @region_perimeters[id] ||= []
        adjacent(@regions_map, coord).each do |c|
          if @regions_map.value(c) != id #&& !@region_perimeters[id].include?(c)
            @region_perimeters[id] << c
          end
        end
        true
      end
    end

    def price_with_perimeters
      find_regions
      total = 0
      @region_areas.each do |region, area|
        perimeter = @region_perimeters[region].size
        #puts "#{region} #{@regions[region]} price = #{area}x#{perimeter}=#{area*perimeter}"
        total += area*perimeter
      end

      total
    end

    private

    def adjacent(map, coord)
      DELTAS.map { |delta| coord + delta }
    end
  end

  class Day12
    def self.run(argv)
      garden = GardenGroups.from_file(argv[0])
      garden.find_regions
      puts "Part 1: #{garden.price_with_perimeters}"

      #puts "Part 2: #{prob.method2}"
    end
  end
end
