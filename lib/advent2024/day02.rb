module Advent2024
  class ReportSafety

    def initialize
      @reports = []
    end

    def add(report)
      @reports << report
    end

    def self.from_file(name)
      problem = ReportSafety.new
      Advent2024.read_data(name) do |words|
        levels = words.map { |x| x.to_i }
        problem.add(Report.new(levels))
      end

      problem
    end

    def safe_reports
      (@reports.find_all { |r| r.safe? }).size
    end

    def extra_safe_reports
      (@reports.find_all { |r| r.dampener_safe? }).size
    end

    class Report
      attr_reader :levels

      def initialize(levels = [])
        @levels = levels

        @diffs = []
        levels[0..-2].each_with_index do |v, i|
          @diffs << levels[i+1] - v
        end
      end

      def safe?
        return false unless increasing? || decreasing?

        @diffs.all? { |v| v.abs >= 1 && v.abs <= 3 }
      end

      def dampener_safe?
        return true if safe?

        (0..levels.size-1).any? { |pos| dampener(pos).safe? }
      end

      def dampener(pos)
        Report.new(levels.reject.with_index { |v, i| i == pos })
      end

      def increasing?
        @diffs.all? do |v|
          v > 0
        end
      end

      def decreasing?
        @diffs.all? do |v|
          v < 0
        end
      end

      def to_s
        levels.to_s
      end
    end
  end

  class Day02
    def self.run(argv)
      rs = ReportSafety.from_file(argv[0])
      puts "Part 1: #{rs.safe_reports}"
      puts "Part 2: #{rs.extra_safe_reports}"
    end
  end
end
