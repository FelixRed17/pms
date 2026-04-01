require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "root renders the launch cycle workspace" do
    get root_url
    assert_response :success
    assert_select "h3", text: "Review cycle list"
  end

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
