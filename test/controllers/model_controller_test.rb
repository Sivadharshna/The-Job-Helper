require "test_helper"

class ModelControllerTest < ActionDispatch::IntegrationTest
  test "should get name:string" do
    get model_name:string_url
    assert_response :success
  end

  test "should get college:references" do
    get model_college:references_url
    assert_response :success
  end
end
