# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class PatrollingLabTest < Minitest::Test
    def sample
      str = <<~EOS
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
      EOS
    end

    # TODO: Add tests!!!!!!!
    def test_read_map
      m = Map.from_string(sample)
      lab = PatrollingLab.new(m)

      assert_equal 10, lab.room.height
      assert_equal 10, lab.room.width
      assert_equal PatrollingLab::Location.new(Advent2024::Coord.new(6,4), "^"), lab.current

      lab.patrol
      puts lab.steps.size

      puts lab.find_loops
    end
  end
end
