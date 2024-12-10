# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class HoofItTest < Minitest::Test
    def test_read_map
      str = <<~EOS
0123
1234
8765
9876
      EOS
      str2 = <<~EOS
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
      EOS

      hoof = build_from(str2)

      hoof.map.draw

      trails = hoof.all_trails
      total = 0

      trails.each do |h, ts|
        score = hoof.score(ts)
        puts "#{h}: #{ts.size} / #{score}"
        total += score
      end
      puts "Total: #{total}"
      puts "Heads: #{hoof.trailheads.size}"
    end

    def build_from(sample)
      m = Advent2024.array_from_string_lines(sample, //).map do |line|
        line.map { |l| l.to_i }
      end

      HoofIt.new(m)
    end
  end
end
