# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class GardenGroupsTest < Minitest::Test
    def test_basic_sample
      str = <<~EOS
AAAA
BBCD
BBCC
EEEC
      EOS
       str2 = <<~EOS
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
      EOS

       str3 = <<~EOS
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
      EOS

      garden = build_from_sample(str3)
      garden.map.draw
      garden.find_regions
      puts
      garden.regions_map.draw
      puts garden.price_with_perimeters
    end

    def build_from_sample(sample)
      map = Map.from_string(sample)
      GardenGroups.new(map)
    end
  end
end
