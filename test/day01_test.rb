# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class ListOfLocationsTest < Minitest::Test

    def setup
      @loc = ListOfLocations.new

      @loc.add_a_and_b(3, 4)
      @loc.add_a_and_b(4, 3)
      @loc.add_a_and_b(2, 5)
      @loc.add_a_and_b(1, 3)
      @loc.add_a_and_b(3, 9)
      @loc.add_a_and_b(3, 3)
    end

    def test_increase
      loc = ListOfLocations.new
      loc.add_a_and_b(3, 4)

      assert_equal 1, loc.locations
    end

    def test_decrease
      loc = ListOfLocations.new
      loc.add_a_and_b(5, 4)

      assert_equal 1, loc.locations
    end

    def test_sample_locations
      assert_equal 11, @loc.locations
    end
    
    def test_sample_locations

      assert_equal 31, @loc.similarity_score
    end

  end
end


