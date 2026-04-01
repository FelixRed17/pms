module Reports
  class ReviewCycleSummary
    def initialize(review_cycle)
      @review_cycle = review_cycle
    end

    def call
      {
        key_behaviours: key_behaviour_rows,
        peer_comments: peer_comments,
        manager_feedback: manager_feedback
      }
    end

    private

    attr_reader :review_cycle

    def key_behaviour_rows
      categories.map do |category|
        peer_scores = peer_answers_by_category.fetch(category, []).map(&:score).compact
        self_answer = self_answers_by_category[category]

        {
          category:,
          peer_average_score: average(peer_scores),
          self_score: self_answer&.score
        }
      end
    end

    def peer_comments
      categories.index_with do |category|
        peer_answers_by_category.fetch(category, []).map(&:comment).reject(&:blank?)
      end
    end

    def manager_feedback
      answer = manager_answers.first
      { score: answer&.score, comment: answer&.comment }
    end

    def categories
      QuestionnaireCatalog.rendered_titles_for("peer_review")
    end

    def peer_answers_by_category
      @peer_answers_by_category ||= peer_answers.group_by { |answer| answer.question_template.category || answer.question_template.title }
    end

    def self_answers_by_category
      @self_answers_by_category ||= self_answers.index_by { |answer| answer.question_template.category || answer.question_template.title }
    end

    def peer_answers
      @peer_answers ||= answers_for_role("peer")
    end

    def self_answers
      @self_answers ||= answers_for_role("reviewee")
    end

    def manager_answers
      @manager_answers ||= answers_for_role("manager")
    end

    def answers_for_role(role)
      review_cycle.review_submissions.submitted
        .where(reviewer_role: role)
        .includes(review_answers: :question_template)
        .flat_map(&:review_answers)
    end

    def average(scores)
      return nil if scores.empty?

      (scores.sum.to_f / scores.length).round(2)
    end
  end
end
