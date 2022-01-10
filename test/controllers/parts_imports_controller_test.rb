require "test_helper"

class PartsImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get parts_imports_new_url
    assert_response :success
  end

  test "should get create" do
    get parts_imports_create_url
    assert_response :success
  end
end
