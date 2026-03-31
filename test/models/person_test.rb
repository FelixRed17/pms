require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "is valid with a first name, last name, and email" do
    person = Person.new(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "new-person@example.com"
    )

    assert person.valid?
  end

  test "requires a first name" do
    person = Person.new(last_name: "Lovelace", email: "missing-first-name@example.com")

    assert_not person.valid?
    assert_includes person.errors[:first_name], "can't be blank"
  end

  test "requires a last name" do
    person = Person.new(first_name: "Ada", email: "missing-last-name@example.com")

    assert_not person.valid?
    assert_includes person.errors[:last_name], "can't be blank"
  end

  test "requires an email" do
    person = Person.new(first_name: "Ada", last_name: "Lovelace")

    assert_not person.valid?
    assert_includes person.errors[:email], "can't be blank"
  end

  test "normalizes email before validation" do
    person = Person.create!(
      first_name: "Existing",
      last_name: "Person",
      email: "person@example.com"
    )
    duplicate_person = Person.new(
      first_name: "Ada",
      last_name: "Lovelace",
      email: " PERSON@example.com "
    )

    assert_not duplicate_person.valid?
    assert_includes duplicate_person.errors[:email], "has already been taken"
    assert_equal "person@example.com", person.reload.email
  end

  test "can belong to a user" do
    user = User.create!(name: "Employee User", email: "employee@example.com", role: "employee")
    person = Person.new(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada-person@example.com",
      user: user
    )

    assert person.valid?
  end
end
