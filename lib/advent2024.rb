# frozen_string_literal: true

require_relative "advent2024/version"
require "pry"

dir=File.expand_path(File.dirname(__FILE__))
Dir.glob("#{dir}/advent2024/day*.rb").each { |file| require file }

module Advent2024
  class Error < StandardError; end

  def self.read_data(name, separator = / /)
    File.readlines(name, chomp: true).each do |line|
      words = separator.nil? ? line : line.split(separator)
      yield words
    end
  end

  def self.chars_map_from(name)
    lines = []
    read_data(name, //).each do |cells|
      lines << cells
    end

    Map.new(lines)
  end

  def self.array_from_string_lines(str, separator = nil)
    array = []
    str.each_line do |line|
      l = line.chomp
      array << (separator.nil? ? l : l.split(separator))
    end

    array
  end

  class Launcher
    def self.execute(day, args = [])
      days = day.nil? ? (1..25).to_a.map { |i| i.to_s.rjust(2, "0") } : [day]
      days.each do |day|
        klass = Module.const_get("Advent2024::Day#{day}")
        puts "Day #{day} ---------------------------------"

        opts = args.nil? || args.size == 0 ? ["data/input-day#{day}"] : ARGV[1..-1]

        klass.run(opts)
      #rescue NameError => e
      #  puts e.message
      end
    end
  end
end

