module QuestionnaireCatalog
  MAX_RENDERED_SECTIONS = 5

  SCORE_SCALE = [
    { value: 0, label: "Not Applicable", definition: "Have not worked with person to score this area" },
    { value: 1, label: "Does Not Meet Expectations", definition: "Behaviour is rarely demonstrated; requires significant improvement" },
    { value: 2, label: "Partially Meets Expectations", definition: "Behaviour is sometimes demonstrated but inconsistent" },
    { value: 3, label: "Meets Expectations", definition: "Behaviour is consistently demonstrated at the expected level" },
    { value: 4, label: "Exceeds Expectations", definition: "Behaviour is often demonstrated above expectations" },
    { value: 5, label: "Role Model / Outstanding", definition: "Behaviour is consistently exemplary and influences others" }
  ].freeze

  RENDERED_SECTION_TITLES = {
    "self_review" => [
      "Functional and Technical Knowledge",
      "Values Alignment",
      "Collaboration and Teamwork",
      "Adaptability and Continuous Learning",
      "Time Management and Reliability"
    ],
    "peer_review" => [
      "Functional and Technical Knowledge",
      "Values Alignment",
      "Collaboration and Teamwork",
      "Adaptability and Continuous Learning",
      "Time Management and Reliability"
    ],
    "manager_review" => [
      "Overall performance of Employee"
    ]
  }.freeze

  DEFINITIONS = [
    {
      name: "Self Review Questionnaire",
      audience_type: "self_review",
      questions: [
        { title: "Job Satisfaction", description: "I feel a strong sense of achievement and satisfaction in my role at Glucode.", question_type: "score_with_comment", position: 1, required: true },
        { title: "Skills & Abilities", description: "My skills, strengths, and talents are effectively utilised in my current role.", question_type: "score_with_comment", position: 2, required: true },
        { title: "Role Clarity", description: "I have a clear understanding of what is expected of me in my role.", question_type: "score_with_comment", position: 3, required: true },
        { title: "Tools and Equipment", description: "I have the tools and equipment I need to perform my role effectively.", question_type: "score_with_comment", position: 4, required: true },
        { title: "Growth and Development", description: "I feel supported by Glucode in my learning and professional development.", question_type: "score_with_comment", position: 5, required: true },
        { title: "Feedback & Recognition", description: "I receive meaningful feedback and recognition that helps me grow.", question_type: "score_with_comment", position: 6, required: true },
        { title: "Teaming", description: "I actively participate in company-arranged activities at Glucode where possible.", question_type: "score_with_comment", position: 7, required: true },
        {
          title: "Functional and Technical Knowledge",
          description: <<~TEXT.strip,
            - Role Knowledge: Demonstrate a strong understanding of the functional and technical requirements of the role.
            - Technical Competence: Apply relevant tools, technologies, frameworks, and best practices effectively in day-to-day work.
            - Quality of Work: Produce accurate, reliable, and well-considered outputs that meet agreed standards.
            - Problem Solving: Identify issues, analyse root causes, and apply appropriate technical or functional solutions.
          TEXT
          question_type: "score_with_comment",
          position: 8,
          required: true,
          category: "Functional and Technical Knowledge"
        },
        {
          title: "Values Alignment",
          description: <<~TEXT.strip,
            - Company Values: Demonstrate our company’s values in all professional interactions.
            - Cultural Sensitivity: Respect and value diverse perspectives and backgrounds.
            - Engagement: Actively engage with and commit to our mission and culture.
          TEXT
          question_type: "score_with_comment",
          position: 9,
          required: true,
          category: "Values Alignment"
        },
        {
          title: "Collaboration and Teamwork",
          description: <<~TEXT.strip,
            - Participation: Engage actively in team meetings and activities, sharing ideas and offering support.
            - Collaboration: Work cohesively with others to meet common objectives.
            - Building Relationships: Cultivate positive relationships with colleagues.
            - Receiving Feedback: Welcome and constructively respond to feedback from both leaders and peers.
          TEXT
          question_type: "score_with_comment",
          position: 10,
          required: true,
          category: "Collaboration and Teamwork"
        },
        {
          title: "Adaptability and Continuous Learning",
          description: <<~TEXT.strip,
            - Flexibility: Adapt to varied roles and challenges enthusiastically.
            - Openness to Change: Welcome new processes and technologies.
            - Resilience: Perform well under pressure and recover swiftly from setbacks.
            - Learning Agility: Pursue continuous learning to enhance skills and knowledge.
            - Adaptability in Structure: Adjust effectively to changes in organisational structure and responsibilities.
          TEXT
          question_type: "score_with_comment",
          position: 11,
          required: true,
          category: "Adaptability and Continuous Learning"
        },
        {
          title: "Time Management and Reliability",
          description: <<~TEXT.strip,
            - Prioritisation: Focus on tasks that have the highest priority.
            - Reliability and Dependability: Consistently deliver high-quality work punctually.
            - Efficiency: Utilise time and resources optimally.
            - Punctuality: Manage time efficiently, ensuring punctuality.
          TEXT
          question_type: "score_with_comment",
          position: 12,
          required: true,
          category: "Time Management and Reliability"
        },
        {
          title: "Professional Conduct and Integrity",
          description: <<~TEXT.strip,
            - Appearance and Conduct: Maintain a professional appearance and demeanor at all times.
            - Respect for Others: Treat all colleagues, partners, and clients with respect.
            - Confidentiality: Keep sensitive information secure.
            - Respect for Leadership Decisions: Support and understand the implications of leadership decisions.
          TEXT
          question_type: "score_with_comment",
          position: 13,
          required: true,
          category: "Professional Conduct and Integrity"
        },
        {
          title: "Leadership and Proactivity",
          description: <<~TEXT.strip,
            - Influence: Motivate and positively influence peers.
            - Initiative: Act proactively, taking initiative without needing direction.
            - Responsibility: Lead by example, taking ownership of tasks.
            - Fearless Feedback: Appropriately raise concerns or risks when necessary.
          TEXT
          question_type: "score_with_comment",
          position: 14,
          required: true,
          category: "Leadership and Proactivity"
        },
        {
          title: "Work Ethic and Accountability",
          description: <<~TEXT.strip,
            - Honesty: Maintain honesty and transparency in all interactions.
            - Accountability: Own your actions and their outcomes.
            - Commitment to Quality: Consistently strive for excellence in your work.
            - Attention to Detail: Pay close attention to accuracy and thoroughness.
            - Compliance with Policies: Adhere strictly to company policies and guidelines.
          TEXT
          question_type: "score_with_comment",
          position: 15,
          required: true,
          category: "Work Ethic and Accountability"
        }
      ]
    },
    {
      name: "Peer Feedback Questionnaire",
      audience_type: "peer_review",
      questions: [
        { title: "Functional and Technical Knowledge", description: "Evaluate role knowledge, technical competence, quality of work, and problem solving.", question_type: "score_with_comment", position: 1, required: true, category: "Functional and Technical Knowledge" },
        { title: "Values Alignment", description: "Evaluate company values, cultural sensitivity, and engagement.", question_type: "score_with_comment", position: 2, required: true, category: "Values Alignment" },
        { title: "Collaboration and Teamwork", description: "Evaluate participation, collaboration, relationship building, and receiving feedback.", question_type: "score_with_comment", position: 3, required: true, category: "Collaboration and Teamwork" },
        { title: "Adaptability and Continuous Learning", description: "Evaluate flexibility, openness to change, resilience, and learning agility.", question_type: "score_with_comment", position: 4, required: true, category: "Adaptability and Continuous Learning" },
        { title: "Time Management and Reliability", description: "Evaluate prioritisation, reliability, efficiency, and punctuality.", question_type: "score_with_comment", position: 5, required: true, category: "Time Management and Reliability" },
        { title: "Professional Conduct and Integrity", description: "Evaluate professionalism, respect, confidentiality, and support for leadership decisions.", question_type: "score_with_comment", position: 6, required: true, category: "Professional Conduct and Integrity" },
        { title: "Leadership and Proactivity", description: "Evaluate influence, initiative, ownership, and fearless feedback.", question_type: "score_with_comment", position: 7, required: true, category: "Leadership and Proactivity" },
        { title: "Work Ethic and Accountability", description: "Evaluate honesty, accountability, quality, attention to detail, and policy adherence.", question_type: "score_with_comment", position: 8, required: true, category: "Work Ethic and Accountability" }
      ]
    },
    {
      name: "Manager Feedback Questionnaire",
      audience_type: "manager_review",
      questions: [
        { title: "Overall performance of Employee", description: "Summarise overall performance, impact, and growth areas.", question_type: "score_with_comment", position: 1, required: true }
      ]
    }
  ].freeze

  module_function

  def rendered_titles_for(audience_type)
    RENDERED_SECTION_TITLES.fetch(audience_type.to_s)
  end
end
