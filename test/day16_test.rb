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

    def test_map1
      maze = build_from(sample)

      maze.draw

      maze.calculate_all_min_dists

      path = maze.dijkstra.path_from_prev(maze.end)

      maze.draw(path)
      score = maze.dijkstra.score(maze.end)
      assert_equal 7036, score

      min_paths_cells = maze.all_in_min_path(path, score)
      maze.draw(min_paths_cells)

      assert_equal 45, min_paths_cells.size
    end

    def test_map2
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

      maze.calculate_all_min_dists

      path = maze.dijkstra.path_from_prev(maze.end)

      maze.draw(path)
      score = maze.dijkstra.score(maze.end)
      assert_equal 11048, score

      min_paths_cells = maze.all_in_min_path(path, score)
      maze.draw(min_paths_cells)

      assert_equal 64, min_paths_cells.size
    end

    def build_from(sample)
      ReindeerMaze.new(Advent2024.array_from_string_lines(sample, //))
    end
  end
end
