module Advent2024
  class WordSearcher

    def initialize
      @canvas = []
    end

    def add_line(line)
      @canvas << (line.is_a?(Array) ? line : line.split(//))
    end

    def self.from_file(name)
      problem = WordSearcher.new
      Advent2024.read_data(name, //) do |line|
        problem.add_line(line)
      end

      problem
    end

    def count_all_directions(str)
      total = 0
      (0..@canvas.size).each do |row|
        (0..@canvas[0].size).each do |col|
          all_directions_from(row, col, str.size).each do |word|
            total += 1 if word == str
          end
        end
      end

      total
    end

    def count_crosses(str)
      raise Advent2024::Error if str.size % 2 == 0

      total = 0
      (0..@canvas.size-(str.size-1)).each do |row|
        (0..@canvas[0].size-(str.size-1)).each do |col|
          a = word(row, col, 1, 1, str.size)
          b = word(row + str.size - 1, col, -1, 1, str.size)

          total += 1 if (a == str || a.reverse == str) && (b == str || b.reverse == str)
        end
      end

      total
    end

    def to_s
      @canvas.map do |line|
        line.join
      end.join("\n")
    end

    private

    def all_directions_from(row, col, length)
      words = [
        word(row, col, 0, 1, length),  # E
        word(row, col, 0, -1, length), # W
        word(row, col, 1, 0, length),  # S
        word(row, col, -1, 0, length), # N
        word(row, col, 1, 1, length),  # SE
        word(row, col, -1, -1,4 ),     # NO
        word(row, col, 1, -1, length), # SW
        word(row, col, -1, 1, length)  # NE
      ]
    end

    def word(row, col, drow, dcol, length)
      data = []
      (0..length-1).each do |i|
        r = row+(drow*i)
        c = col+(dcol*i)
        break if r < 0 || c < 0 || r >= @canvas.size || c >= @canvas[0].size

        data << @canvas[r][c]
      end

      return data.join
    end
  end

  class Day04
    def self.run(argv)
      searcher = WordSearcher.from_file(argv[0])
      puts "Part 1: #{searcher.count_all_directions("XMAS")}"
      puts "Part 2: #{searcher.count_crosses("MAS")}"
    end
  end
end

