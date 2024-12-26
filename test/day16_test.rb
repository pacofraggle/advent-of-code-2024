# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class ReindeerMazeTest < Minitest::Test
    def sample
      str = <<~EOS
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
      EOS
    end

    def test_build_map
      maze = build_from(sample)

      assert_equal Coord.new(1, 13), maze.end
      assert_equal Coord.new(13, 1), maze.start
    end

    def test_dijsktra
      maze = build_from(sample)

      maze.draw

      path = maze.dijsktra

      maze.draw(path)
      puts maze.score(path)
      puts path.size
    end

    def test_dijsktra2
      str = <<~EOS
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
      EOS

      maze = build_from(str)

      maze.draw

      path = maze.dijsktra

      maze.draw(path)
      puts maze.score(path)
      puts path.size
    end

    def test_minimaze
      str = <<~EOS
#####
#..E#
#.#.#
#.#.#
#S..#
#####
      EOS

      maze = build_from(str)

      maze.draw

      path = maze.dijsktra

      maze.draw(path)
      puts maze.score(path)
    end

    def build_from(sample)
      ReindeerMaze.new(Advent2024.array_from_string_lines(sample, //))
    end
  end
end
