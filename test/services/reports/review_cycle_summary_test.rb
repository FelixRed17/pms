require "test_helper"

module Reports
  class ReviewCycleSummaryTest < ActiveSupport::TestCase
    test "aggregates peer averages, self scores, anonymous peer comments, and manager feedback" do
      summary = ReviewCycleSummary.new(review_cycles(:engineering_q2)).call

      assert_equal 5, summary[:key_behaviours].size
      collaboration = summary[:key_behaviours].find { |row| row[:category] == "Collaboration and Teamwork" }

      assert_equal 4.0, collaboration[:peer_average_score]
      assert_equal 3, collaboration[:self_score]
      assert_includes summary[:peer_comments]["Collaboration and Teamwork"], "Supports team delivery and keeps communication clear."
      assert_equal "Strong ownership across the quarter.", summary[:manager_feedback][:comment]
    end
  end
end
