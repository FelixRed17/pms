require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get dashboard_home_url
    assert_response :success
  end

  test "should get cycles" do
    get dashboard_cycles_url
    assert_response :success
  end

  test "should get employees" do
    get dashboard_employees_url
    assert_response :success
  end

  test "should get reports" do
    get dashboard_reports_url
    assert_response :success
  end
end
