require "test_helper"

class ReviewcyclesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get reviewcycles_new_url
    assert_response :success
  end
end
