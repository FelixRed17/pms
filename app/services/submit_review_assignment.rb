class SubmitReviewAssignment
  Result = Struct.new(:success?, :assignment, :errors, keyword_init: true)

  INVALID_LINK_MESSAGE = "This link is invalid or expired.".freeze
  ALREADY_SUBMITTED_MESSAGE = "This review has already been submitted.".freeze
  NO_QUESTIONS_MESSAGE = "No questions are configured for this review.".freeze

  def self.call(magic_link:, responses_params:)
    new(magic_link:, responses_params:).call
  end

  def initialize(magic_link:, responses_params:)
    @magic_link = magic_link
    @assignment = magic_link.resource
    @responses_params = responses_params || {}
  end

  def call
    return failure(INVALID_LINK_MESSAGE) unless assignment.is_a?(ReviewAssignment)
    return failure(ALREADY_SUBMITTED_MESSAGE) if assignment.submitted?

    questions = Question.for_assignment_type(assignment.assignment_type).to_a
    return failure(NO_QUESTIONS_MESSAGE) if questions.empty?

    response_map = normalized_responses
    validation_errors = validate_responses(questions, response_map)
    return failure(*validation_errors) if validation_errors.any?

    answers = build_answers(questions, response_map)
    answer_errors = answers.flat_map { |answer| answer.valid? ? [] : answer.errors.full_messages }
    return failure(*answer_errors) if answer_errors.any?

    success = false

    ApplicationRecord.transaction do
      answers.each(&:save!)
      assignment.mark_submitted!

      unless magic_link.consume!
        raise ActiveRecord::Rollback
      end

      success = true
    end

    return success_result if success

    failure(INVALID_LINK_MESSAGE)
  rescue ActiveRecord::RecordInvalid => error
    failure(*error.record.errors.full_messages)
  end

  private

  attr_reader :assignment, :magic_link, :responses_params

  def normalized_responses
    responses_params.each_with_object({}) do |(question_id, value_hash), normalized|
      normalized[question_id.to_i] = (value_hash || {}).to_h.stringify_keys
    end
  end

  def validate_responses(questions, response_map)
    allowed_ids = questions.map(&:id)
    provided_ids = response_map.keys

    errors = []
    errors << "All review questions must be answered." if provided_ids.sort != allowed_ids.sort

    invalid_question_ids = provided_ids - allowed_ids
    if invalid_question_ids.any?
      errors << "The submission contains invalid questions."
    end

    errors
  end

  def build_answers(questions, response_map)
    questions.map do |question|
      ReviewAnswer.new(
        review_assignment: assignment,
        question: question,
        **typed_value_attributes(question, response_map.fetch(question.id))
      )
    end
  end

  def typed_value_attributes(question, response_values)
    case question.question_type
    when "text"
      { text_value: response_values["text_value"].to_s.strip.presence }
    when "rating"
      { rating_value: response_values["rating_value"].presence&.to_i }
    when "boolean"
      { boolean_value: ActiveModel::Type::Boolean.new.cast(response_values["boolean_value"]) }
    else
      {}
    end
  end

  def failure(*errors)
    Result.new(success?: false, assignment:, errors: errors.flatten.compact.uniq)
  end

  def success_result
    Result.new(success?: true, assignment:, errors: [])
  end
end
