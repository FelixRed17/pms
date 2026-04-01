lara = User.find_or_initialize_by(email: "lara@glucode.com")
lara.update!(
  name: "Lara",
  role: "hr"
)

people_attributes = [
  { first_name: "Ada", last_name: "Lovelace", email: "ada@glucode.com", job_title: "Software Engineer" },
  { first_name: "Grace", last_name: "Hopper", email: "grace@glucode.com", job_title: "Engineering Manager" },
  { first_name: "Linus", last_name: "Torvalds", email: "linus@glucode.com", job_title: "Principal Engineer" },
  { first_name: "Katherine", last_name: "Johnson", email: "katherine@glucode.com", job_title: "Data Analyst" },
  { first_name: "Margaret", last_name: "Hamilton", email: "margaret@glucode.com", job_title: "Staff Engineer" },
  { first_name: "Donald", last_name: "Knuth", email: "donald@glucode.com", job_title: "Architect" },
  { first_name: "Barbara", last_name: "Liskov", email: "barbara@glucode.com", job_title: "Head of Engineering" },
  { first_name: "Edsger", last_name: "Dijkstra", email: "edsger@glucode.com", job_title: "Engineering Director" }
]

people_attributes.each do |attributes|
  person = Person.find_or_initialize_by(email: attributes[:email])
  person.update!(attributes)
end

question_attributes = [
  {
    question_text: "What are %{subject_possessive} strongest contributions?",
    question_type: "text",
    audience: "all",
    position: 1,
    active: true
  },
  {
    question_text: "How consistently does %{subject_name} deliver on commitments?",
    question_type: "rating",
    audience: "all",
    position: 2,
    active: true
  },
  {
    question_text: "Would you want to work with %{subject_object} again on a critical project?",
    question_type: "boolean",
    audience: "all",
    position: 3,
    active: true
  },
  {
    question_text: "What are your most important growth goals for the next review cycle?",
    question_type: "text",
    audience: "self",
    position: 4,
    active: true
  },
  {
    question_text: "Where do you believe you need the most support to be more effective?",
    question_type: "text",
    audience: "self",
    position: 5,
    active: true
  },
  {
    question_text: "How effectively does %{subject_name} collaborate with peers across the team?",
    question_type: "rating",
    audience: "peer",
    position: 6,
    active: true
  },
  {
    question_text: "What peer-facing behavior from %{subject_name} should be strengthened or improved?",
    question_type: "text",
    audience: "peer",
    position: 7,
    active: true
  },
  {
    question_text: "How well does %{subject_name} demonstrate leadership, ownership, and sound judgement?",
    question_type: "rating",
    audience: "manager",
    position: 8,
    active: true
  },
  {
    question_text: "What manager recommendations would help %{subject_name} grow in the next cycle?",
    question_type: "text",
    audience: "manager",
    position: 9,
    active: true
  }
]

question_attributes.each do |attributes|
  question = Question.find_or_initialize_by(question_text: attributes[:question_text])
  question.update!(attributes)
end
