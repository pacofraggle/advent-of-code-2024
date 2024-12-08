# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class PrintingQueueTest < Minitest::Test
    def sample
      str = <<~EOS
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
      EOS
    end

    def test_update_creation
      assert_equal [3, 4, 5], PrintingQueue::Update.new([3, 4, 5]).pages
    end

    def test_update_to_order_rules
      rules = PrintingQueue::Update.new([3, 4, 5]).to_order_rules

      assert_equal 3, rules.size
      assert_equal "3|4", rules[0].to_s
      assert_equal "3|5", rules[1].to_s
      assert_equal "4|5", rules[2].to_s
    end

    def test_update_middle_page
      assert_equal 4, PrintingQueue::Update.new([3, 4, 5]).middle_page
    end


    def test_rules_compatibility
      base = PrintingQueue::Rule.new(1, 2)

      refute base.compatible?(PrintingQueue::Rule.new(2, 1))
      assert base.compatible?(PrintingQueue::Rule.new(1, 3))
      assert base.compatible?(PrintingQueue::Rule.new(54, 3))
    end

    def test_update_swap
      update = PrintingQueue::Update.new([75,97,47,61,53])

      update.swap(97, 75)
      assert_equal [97, 75, 47, 61, 53], update.pages
    end

    def test_create_sample
      printing = build_printing

      assert_equal 6, printing.updates.size
      assert_equal 21, printing.rules.size
    end

    def test_sample_right_order
      printing = build_printing

      assert printing.right_order?(0)
      assert printing.right_order?(1)
      assert printing.right_order?(2)
      refute printing.right_order?(3)
      refute printing.right_order?(4)
      refute printing.right_order?(5)

      right_updates = printing.updates[0..2]
      printing_right = PrintingQueue.new(printing.rules, right_updates)

      assert_equal 143, printing_right.sum
    end

    def test_updates_order
      printing = build_printing

      assert_equal [true, true, true, false, false, false], printing.updates_right_order
    end

    def test_fix_update
      printing = build_printing

      printing.fix_update(3)
      assert_equal [97, 75, 47, 61, 53], printing.updates[3].pages
      printing.fix_update(4)
      assert_equal [61, 29, 13], printing.updates[4].pages
      printing.fix_update(5)
      assert_equal [97, 75, 47, 29, 13], printing.updates[5].pages
    end

    def build_printing
      printing = PrintingQueue.new

      Advent2024.array_from_string_lines(sample).each do |line|
        printing.add_line(line)
      end

      printing
    end
  end
end
