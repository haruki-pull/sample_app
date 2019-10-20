require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "unsucceful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {user: {name:"",
                                          email:"foo@invalid",
                                          password:"foo",
                                          password_confirmation:"bar"}}
    assert_template 'users/edit'
    assert_select "div.alert","The form contains 4 errors.", count: 1
  end
  
  test "settingの成功" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "foo"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {name: name,
                                                 email: email,
                                                 password:"",
                                                 password_digest:""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
   test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  test "successful redirect_back_or" do
    #未ログイン状態でeditリクエストを送る
    get edit_user_path(@user)
    #@userの:forwaeding_urlと現在のurlが同じか確かめる
    assert_equal session[:forwarding_url], edit_user_url(@user)
    #ログインする
    log_in_as(@user)
    #:forwarding_urlが破棄されているか
    assert_nil session[:forwarding_url]
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user),params: {user: {name: name,
                                              email: email,
                                              password: "password",
                                              password_confirmation: "password"}}
    
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name , @user.name
    assert_equal email, @user.email
  end
end