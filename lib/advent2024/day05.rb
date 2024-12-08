# frozen_string_literal: true

module Advent2024
  class PrintingQueue

    class Update
      attr_reader :pages

      def initialize(pages = [])
        @pages = pages
      end

      def to_order_rules
        return @rules unless @rules.nil?

        @rules = []
        pages.each_with_index do |page, i|
          pages[(i+1)..].each do |other|
            @rules << Rule.new(page, other)
          end
        end

        @rules
      end

      def middle_page
        pages[pages.size/2]
      end

      def swap(a, b)
        pos_a = pages.index(a)
        pos_b = pages.index(b)

        return if pos_a == -1 || pos_b == -1
        @rules = nil

        @pages[pos_a] = b
        @pages[pos_b] = a
      end

      def to_s
        pages.to_s
      end
    end

    class Rule
      attr_reader :before, :after

      def initialize(before, after)
        @before = before
        @after = after
      end

      def compatible?(rule)
        return false if after == rule.before && before == rule.after 

        true
      end

      def to_s
        "#{before}|#{after}"
      end
    end

    attr_reader :rules, :updates

    def initialize(rules = [], updates = [])
      @rules = rules
      @updates = updates
    end

    def add_line(line)
      return if line.nil?

      return add_rule(line) if line.include?("|")

      add_update(line)
    end

    def add_rule(line)
      a, b = line.split(/\|/)

      @rules << Rule.new(a.to_i, b.to_i) unless a.nil? || b.nil?
    end

    def add_update(line)
      return if line.empty? || line.nil?

      @updates << Update.new(line.split(/,/).map(&:to_i))
    end

    def self.from_file(name)
      problem = PrintingQueue.new
      Advent2024.read_data(name) do |line|
        problem.add_line(line[0])
      end

      problem
    end

    def right_order?(pos)
      update_rules = updates[pos].to_order_rules

      update_rules.all? do |r|
        rules.all? do |rule|
          rule.compatible?(r)
        end
      end
    end

    def updates_right_order
      (0..updates.size-1).map { |i| right_order?(i) }
    end

    def sum
      sum = 0
      updates.each do |update|
        sum += update.middle_page 
      end

      sum
    end

    def fix_update(pos)
      loop do
        incompatible = find_incompatible_rules(updates[pos])
        break if incompatible.empty?

        incompatible.each do |rule|
          updates[pos].swap(rule.before, rule.after)
        end
      end
    end

    def fix_all_updates
      (0..updates.size-1).each { |pos| fix_update(pos) }
    end

    private

    def find_incompatible_rules(update)
      update_rules = update.to_order_rules

      incompatible = []
      update_rules.each do |r|
        rules.each do |rule|
          incompatible << r if !rule.compatible?(r)
        end
      end

      incompatible
    end
  end

  # Very suboptimal
  #  Either compact the rules with ordering graphs
  #  or use a hash to make the rules access faster. Encapsulate under a RuleSet
  class Day05
    def self.run(argv)
      printing = PrintingQueue.from_file(argv[0])

      right_order = printing.updates_right_order

      right_updates = []
      wrong_updates = []
      right_order.each_with_index do |right, i|
        if right
          right_updates << printing.updates[i] 
        else
          wrong_updates << printing.updates[i] 
        end
      end

      printing_right = PrintingQueue.new(printing.rules, right_updates)
      puts "Part 1: #{printing_right.sum}"

      printing_wrong = PrintingQueue.new(printing.rules, wrong_updates)
      printing_wrong.fix_all_updates
      puts "Part 2: #{printing_wrong.sum}"
    end
  end
end
