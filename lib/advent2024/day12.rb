# frozen_string_literal: true

require_relative "map"

module Advent2024
  class GardenGroups
    # The order is important for the solution of region sides
    DELTAS = [
      Coord.new(0, -1).freeze, # W
      Coord.new(-1, 0).freeze, # N
      Coord.new(0, 1).freeze,  # E
      Coord.new(1, 0).freeze   # S
    ].freeze

    attr_reader :map, :regions_map, :region_areas, :region_perimeters, :region_sides, :regions

    def initialize(map)
      @map = map
      @regions_map = nil

      @region_areas = Hash.new(0)
      @region_perimeters = {}
      @region_sides = {}
      @regions = {}
    end

    def self.from_file(name)
      GardenGroups.new(Map.from_file(name))
    end

    def find_regions
      return @regions_map unless @regions_map.nil?

      @regions_map = Advent2024::Map.blank(@map.height, @map.width, 0)

      current_region = 0
      map.scan do |coord, plant|
        next true if @regions_map.value(coord) > 0

        current_region += 1
        @regions[current_region] = plant
        find_region_for(coord, plant, current_region)
        true
      end
    end

    def find_region_for(coord, plant, region_id)
      # Iterative DFS
      stack = []
      stack.push(coord)
      until stack.empty? do
        v = stack.pop

        @regions_map.set(v, region_id)

        options = adjacent_coords(@map, v).select do |c|
          @map.value(c) == plant && @regions_map.value(c) == 0
        end
        options.each { |option| stack.push(option) }
      end
    end

    def price_using_perimeters
      find_regions
      analyze_figures

      total = 0
      @region_areas.each do |region, area|
        perimeter = @region_perimeters[region].size
        #puts "#{region} #{@regions[region]} price = #{area}x#{perimeter}=#{area*perimeter}"
        total += area*perimeter
      end

      total
    end

    def price_using_sides
      find_regions
      analyze_figures

      @regions.each do |id, plant|
        find_sides_of(id)
      end


      total = 0
      @region_sides.each do |id, dir_lines|
        area = @region_areas[id]
        #puts "#{@regions[id]}:"
        #dir_lines.each_with_index { |line, i| puts "#{@regions[id]} -  #{i}: #{line.map {|p| p.map(&:to_s) }}" }
        #puts
        sides_for_id = dir_lines.map { |dir| dir.size }.sum
        total += area*sides_for_id
      end

      total
    end

    def region_sides(id)
      @region_sides[id].map { |dir| dir.size }.sum
    end

    private

    def adjacent_coords(map, coord)
      DELTAS.map { |delta| coord + delta }
    end

    def analyze_figures
      return unless @region_areas.empty?

      @regions_map.scan do |coord, id|
        @region_areas[id] += 1
        @region_perimeters[id] ||= []
        adjacent_coords(@regions_map, coord).each do |c|
          @region_perimeters[id] << c if @regions_map.value(c) != id #&& !@region_perimeters[id].include?(c)
        end

        true
      end
    end

    def find_sides_of(region_id)
      return unless @region_sides[region_id].nil?

      analyze_figures
      @region_sides[region_id] = []
      lines_per_dir = [[], [], [], []]
      perimeter = @region_perimeters[region_id].uniq

      perimeter.each do |border|
        all_touches = adjacent_coords(@regions_map, border) # Not filtering here because I need the positions for the directions
        all_touches.each_with_index do |adj, dir|
          # skip if adjacent is not inner or if it has already been included in that direction
          next if @regions_map.value(adj) != region_id || lines_per_dir[dir].any? { |line| line.include?(border) }

          lines_per_dir[dir] << perimeter_line_for(border, region_id, dir, perimeter)
        end
      end

      @region_sides[region_id] = lines_per_dir
    end

    def perimeter_line_for(coord, region_id, dir, perimeter)
      line = [coord]
      rest = perimeter - line
      # Order of deltas: W, N, E, S
      if dir == 1 || dir == 3 # North of south borders require checking line neighbours laterally
        delta1 = DELTAS[0]
        delta2 = DELTAS[2]
      else # East or West borders require checking line neighbours vertically
        delta1 = DELTAS[1]
        delta2 = DELTAS[3]
      end
      inside_delta = DELTAS[dir]

      restart = true
      while restart do
        restart = false
        rest.each do |another|
          next unless @regions_map.value(another+inside_delta) == region_id

          if line.any? { |p| p == another+delta1 || p == another+delta2 }
            line << another
            rest = rest - [another]
            restart = true # Recheck all missing values with the new line
            break
          end
        end
      end

      line
    end
  end

  # This day I lost track of the day-by-day pace as I didn't know how to approach Part 2
  # Possibly I should have used a Filling Areas algorighm, but DFS seemed just right
  # And I also feel that the perimeter and area calculation can be done in the same step
  # as the region
  #
  # The attributes and some public methods may return empty if not called in order
  # There´s space for a lot of design improvement
  # Also, the map using coord could be optimized accessing the raw map. However the current
  # solution was complex enough to not make it even more complex
  class Day12
    def self.run(argv)
      garden = GardenGroups.from_file(argv[0])
      garden.find_regions

      puts "Part 1: #{garden.price_using_perimeters}"
      puts "Part 2: #{garden.price_using_sides}"
    end
  end
end
