# frozen_string_literal: true

module Advent2024
  class DiskFragmenter
    attr_reader :dense, :blocks

    def self.from_file(name)
      Advent2024.read_data(name, nil) do |line|
        return DiskFragmenter.new(line)
      end
    end

    def initialize(sectors)
      @dense = sectors
      dense_to_blocks
      @first_empty = 0
      @last_file = @blocks.size-1
      reset_indexes
    end

    def to_s
      @blocks.map { |b| b.nil? ? "." : b.to_s }.join
    end

    def move
      return false if @last_file < @first_empty

      transfer(@last_file, @first_empty)
      reset_indexes

      true
    end

    def unfragment
      moved = true
      while moved
        moved = move
      end
    end

    def checksum
      total = 0
      @blocks.each_with_index do |value, i|
        total += i*(value.nil? ? 0 : value)
      end

      total
    end

    def transfer(from, to)
      @blocks[to] = @blocks[from]
      @blocks[from] = nil
    end
 
    def dense_to_blocks
      chars = @dense.split(//).map(&:to_i)
      blocks = Array.new(chars.sum, nil)
      pos = 0
      id = 0
      file = true
      chars.each do |char|
        value = char.to_i
        if file
          pos.upto(pos+value-1).each { |i| blocks[i] = id }
          file = false
          id += 1
        else
          file = true
        end
        pos = pos+value
      end

      @blocks = blocks
    end

    private

    def reset_indexes
      @first_empty = @first_empty.upto(@blocks.size-1).find do |i|
        @blocks[i].nil?
      end

      prev = @last_file
      @last_file = @last_file.downto(9).find do |i|
        !@blocks[i].nil?
      end
      @last_file = prev + 1 if @last_file.nil?
    end
  end

  class DiskFragmenterFiles < DiskFragmenter
    def self.from_file(name)
      Advent2024.read_data(name, nil) do |line|
        return DiskFragmenterFiles.new(line)
      end
    end

    def initialize(sectors)
      @file_index_to_move = -1
      super
    end

    def move
      id = @movable_file
      
      return false if id.nil?

      valid_void_pos = find_first_void_for(id)

      transfer_file(id, valid_void_pos) unless valid_void_pos.nil?

      reset_indexes

      true
    end

    def unfragment
      loop do 
        movables = move

        break unless movables
      end
    end

    def dense_to_blocks
      @file_sizes = {}
      @voids = {}
      @files = {}
      chars = @dense.split(//).map(&:to_i)
      blocks = Array.new(chars.sum, nil)
      pos = 0
      id = 0
      file = true
      chars.each do |char|
        value = char.to_i
        if file
          @file_sizes[id] = value
          @files[id] = pos
          pos.upto(pos+value-1).each { |i| blocks[i] = id }
          file = false
          id += 1
        else
          @voids[pos] = value if value > 0
          file = true
        end
        pos = pos+value
      end

      @files_order = @files.keys.reverse
      @file_index_to_move = -1

      @blocks = blocks
    end
    
    private

    def transfer_file(id, pos)
      file_pos = @files[id]
      file_size = @file_sizes[id]
      void_size = @voids[pos]

      (0..file_size-1).each do |p|
        transfer(file_pos+p, pos+p)
      end

      @voids.delete(pos)
      if void_size > file_size
       @voids[pos+file_size] = void_size-file_size
      end
    end

    def find_first_void_for(id)
      # The void has to be big enough and appear before the file
      min = @file_sizes[id]
      file_pos = @files[id]
      @voids.keys.sort.each do |pos|
        return pos if pos < file_pos && @voids[pos] >= min
        break if pos >= file_pos
      end

      nil
    end

    def reset_indexes
      @files_index_to_move ||= -1

      @files_index_to_move += 1
      @movable_file = @files_index_to_move == @files.keys.size ? nil : @files_order[@files_index_to_move]
    end
  end

  class Day09
    def self.run(argv)
      df = DiskFragmenter.from_file(argv[0])
      df.unfragment
      puts "Part 1: #{df.checksum}"

      # TODO:
      # PArt 2 works but it leaves the voids in an incorrect state
      # I'm also not happy about how inheritance worked here
      # from_file should not be duplicated
      dff = DiskFragmenterFiles.from_file(argv[0])
      dff.unfragment
      puts "Part 2: #{dff.checksum}"
    end
  end
end
