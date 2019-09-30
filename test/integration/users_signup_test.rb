require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  #ユーザー登録失敗した時の挙動テスト
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'input.form-control'
    assert_select 'form[action="/signup"]'
  end
  #ユーザー登録成功した時の挙動テスト
  test "valid signup information" do
    get signup_path
    
    #成功したらUser.countが一増える
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!#下のassert_template 'users/show'に飛ばす
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
