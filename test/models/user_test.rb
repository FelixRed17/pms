require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with an email and supported role" do
    user = User.new(name: "HR User", email: "new-hr@example.com", role: "hr")

    assert user.valid?
  end

  test "requires a name" do
    user = User.new(email: "hr@example.com", role: "hr")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires an email" do
    user = User.new(name: "HR User", role: "hr")

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "normalizes email before validation" do
    user = User.create!(name: "Existing User", email: "existing@example.com", role: "hr")
    duplicate_user = User.new(name: "Duplicate User", email: " EXISTING@example.com ", role: "employee")

    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
    assert_equal "existing@example.com", user.reload.email
  end

  test "requires a supported role" do
    user = User.new(name: "Example User", email: "user@example.com", role: "invalid")

    assert_not user.valid?
    assert_includes user.errors[:role], "is not included in the list"
  end
end
