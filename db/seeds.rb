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

QuestionnaireTemplate.seed_system_templates!
