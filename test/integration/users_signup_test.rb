require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                          email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" }}
      end
      assert_template 'users/new' #checks if failed submission rerenders 'new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
      assert_select 'form[action="/signup"]'
    end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "example user",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" }}
      end
      follow_redirect!
      assert_template 'users/show' #Assert template Asserts that the request was rendered with the appropriate template file or partials.
      assert_not flash.nil?
    end
  
end

#By wrapping the post in the assert_no_difference 
#method with the string argument 'User.count', 
#we arrange for a comparison between User.count before and after 
#the contents inside the assert_no_difference block.

#Same as:
# before_count = User.count
# post users_path, ...
# after_count  = User.count
# assert_equal before_count, after_count