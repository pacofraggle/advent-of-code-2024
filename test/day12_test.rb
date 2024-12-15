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

      puts
      garden = build_from_sample(str)
      garden.map.draw
      garden.find_regions
      puts
      garden.regions_map.draw

      assert_equal 140, garden.price_using_perimeters

      assert_equal 5, garden.regions.size

      assert_equal 4, garden.region_areas[1]
      assert_equal 4, garden.region_areas[2]
      assert_equal 4, garden.region_areas[3]
      assert_equal 1, garden.region_areas[4]
      assert_equal 3, garden.region_areas[5]

      assert_equal 10, garden.region_perimeters[1].size
      assert_equal 8, garden.region_perimeters[2].size
      assert_equal 10, garden.region_perimeters[3].size
      assert_equal 4, garden.region_perimeters[4].size
      assert_equal 8, garden.region_perimeters[5].size

      assert_equal 80, garden.price_using_sides
      assert_equal 4, garden.region_sides(1)
      assert_equal 4, garden.region_sides(2)
      assert_equal 8, garden.region_sides(3)
      assert_equal 4, garden.region_sides(4)
      assert_equal 4, garden.region_sides(5)
    end

    def test_inner_regions
      str = <<~EOS
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
      EOS

      puts
      garden = build_from_sample(str)
      garden.map.draw
      garden.find_regions
      puts
      garden.regions_map.draw

      assert_equal 772, garden.price_using_perimeters
      assert_equal 436, garden.price_using_sides
    end

    def test_larger_example
      str = <<~EOS
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

      puts
      garden = build_from_sample(str)
      garden.map.draw
      garden.find_regions
      puts

      assert_equal 1930, garden.price_using_perimeters
      assert_equal 1206, garden.price_using_sides
    end

    def test_eshaped_example
      str = <<~EOS
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
      EOS

      puts
      garden = build_from_sample(str)
      garden.map.draw
      garden.find_regions
      puts
      garden.regions_map.draw

      assert_equal 236, garden.price_using_sides
    end

    def test_mobius_fencing_example
      str = <<~EOS
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
      EOS

      puts
      garden = build_from_sample(str)
      garden.map.draw
      garden.find_regions
      puts
      garden.regions_map.draw

      assert_equal 368, garden.price_using_sides
    end

    def build_from_sample(sample)
      map = Map.from_string(sample)
      GardenGroups.new(map)
    end
  end
end
