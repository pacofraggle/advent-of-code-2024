# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class WarehouseWoesTest < Minitest::Test
    def small_sample
      str = <<~EOS
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
      EOS
    end


    def sample
      str = <<~EOS
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
      EOS
    end

    def test_read_file
      woes = build_from(small_sample)

      assert_equal 8, woes.map.width
      assert_equal 8, woes.map.height
      assert_equal Coord.new(2, 2), woes.robot
      assert_equal "<^^>>>vv<v>>v<<", woes.sequence.join
    end

    def test_move
      woes = build_from(sample)

      woes.run_sequence
      puts
      woes.map.draw
      puts woes.sum_boxes_gps
    end

    def test_read_file_wide
      woes = build_wide_from(sample)

      puts
      woes.map.draw
      woes.run_sequence
      puts
      woes.map.draw
      puts woes.sum_boxes_gps
    end

    def build_from(str)
      grid, seq = extract_data_from(str)
      WarehouseWoes.new(grid, seq)
    end

    def build_wide_from(str)
      grid, seq = extract_data_from(str)
      WarehouseWoesWide.new(grid, seq)
    end

    def extract_data_from(str)
      WarehouseWoes.extract_data_from_strings_array(Advent2024.array_from_string_lines(str))
    end
  end
end
