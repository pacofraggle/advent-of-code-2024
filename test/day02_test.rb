# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class ReportSafetyTest < Minitest::Test
    def setup
      @reports = [
        ReportSafety::Report.new([7, 6, 4, 2, 1]),
        ReportSafety::Report.new([1, 2, 7, 8, 9]),
        ReportSafety::Report.new([9, 7, 6, 2, 1]),
        ReportSafety::Report.new([1, 3, 2, 4, 5]),
        ReportSafety::Report.new([8, 6, 4, 4, 1]),
        ReportSafety::Report.new([1, 3, 6, 7, 9])
      ]

      @safety = ReportSafety.new
      @reports.each { |rep| @safety.add(rep) }
    end

    def test_increasing
      report = ReportSafety::Report.new([1, 2, 10])

      assert report.increasing?
    end

    def test_decreasing
      report = ReportSafety::Report.new([5, 4, 2])

      assert report.decreasing?
    end

    def test_not_increasing_or_decreasing
      report = ReportSafety::Report.new([5, 4, 8, 2])

      refute report.decreasing?
      refute report.increasing?
    end

    def test_dampener
      report = ReportSafety::Report.new([5, 4, 8, 2])

      assert [5, 4, 2], report.dampener(2).levels
    end

    def test_safe_sample
      assert @reports[0].safe?
      refute @reports[1].safe?
      refute @reports[2].safe?
      refute @reports[3].safe?
      refute @reports[4].safe?
      assert @reports[5].safe?
    end

    def test_safe_reports
      assert 2, @safety.safe_reports
    end

    def test_dampener_safe_sample
      assert @reports[0].dampener_safe?
      refute @reports[1].dampener_safe?
      refute @reports[2].dampener_safe?
      assert @reports[3].dampener_safe?
      assert @reports[4].dampener_safe?
      assert @reports[5].dampener_safe?
    end

    def test_extra_safe_reports
      assert_equal 4, @safety.extra_safe_reports
    end
  end
end
