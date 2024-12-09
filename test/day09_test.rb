# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class DiskFragmenterTest < Minitest::Test

    def test_read_disk
      unfrg = DiskFragmenter.new("12345")
      assert_equal "0..111....22222", unfrg.to_s

      unfrg = DiskFragmenter.new("2333133121414131402")
      assert_equal "00...111...2...333.44.5555.6666.777.888899", unfrg.to_s
    end

    def test_move
      unfrg = DiskFragmenter.new("12345")
      
      unfrg.move
      assert_equal "02.111....2222.", unfrg.to_s
      unfrg.move
      assert_equal "022111....222..", unfrg.to_s
      unfrg.move
      assert_equal "0221112...22...", unfrg.to_s
      unfrg.move
      assert_equal "02211122..2....", unfrg.to_s
      unfrg.move
      assert_equal "022111222......", unfrg.to_s

      unfrg.move
      assert_equal "022111222......", unfrg.to_s
    end

    def test_unfragment
      unfrg = DiskFragmenter.new("2333133121414131402")
      unfrg.unfragment

      assert_equal "0099811188827773336446555566..............", unfrg.to_s
      assert_equal 1928, unfrg.checksum
    end

    def test_file_moves
      unfrg = DiskFragmenterFiles.new("2333133121414131402")

      assert_equal "00...111...2...333.44.5555.6666.777.888899", unfrg.to_s
      # moving 9
      unfrg.move
      assert_equal "0099.111...2...333.44.5555.6666.777.8888..", unfrg.to_s
      # moving 8 doesn't fit anywhere so it stays the same
      unfrg.move
      assert_equal "0099.111...2...333.44.5555.6666.777.8888..", unfrg.to_s
      # moving 7
      unfrg.move
      assert_equal "0099.1117772...333.44.5555.6666.....8888..", unfrg.to_s
      # Moving 6 doesn't fit so it stays the same
      unfrg.move
      assert_equal "0099.1117772...333.44.5555.6666.....8888..", unfrg.to_s
      # Moving 5 doesn't fit so it stays the same
      unfrg.move
      assert_equal "0099.1117772...333.44.5555.6666.....8888..", unfrg.to_s
      # Moving 4
      unfrg.move
      assert_equal "0099.111777244.333....5555.6666.....8888..", unfrg.to_s
      # Moving 3 doesn't fit stays the same
      unfrg.move
      assert_equal "0099.111777244.333....5555.6666.....8888..", unfrg.to_s
      # Moving 2
      unfrg.move
      assert_equal "00992111777.44.333....5555.6666.....8888..", unfrg.to_s
      # Moving ! stays the same
      unfrg.move
      assert_equal "00992111777.44.333....5555.6666.....8888..", unfrg.to_s
      # Moving 0 stays the same
      unfrg.move
      assert_equal "00992111777.44.333....5555.6666.....8888..", unfrg.to_s

    end

    def test_files_unfragment
      unfrg = DiskFragmenterFiles.new("2333133121414131402")

      unfrg.unfragment

      assert_equal 2858, unfrg.checksum
    end
  end
end
















