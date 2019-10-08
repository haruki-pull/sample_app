require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  #login失敗時にエラーメッセージが一度だけ表示されるかテスト
test "login with invalid information" do
  #loginページにgetアクションを送る
    get login_path
    
  # sessions/newのviewファイルが表示されていることを確認
    assert_template 'sessions/new'
    
  #  loginページにparams以下のハッシュがpostされているか（この時は空を送る）
    post login_path, params: { session: { email: "", password: "" } }
   
  #login失敗なのでrender 'newが行われているか'
    assert_template 'sessions/new'
   
  #flashが空っぽでないときtrueを返す
    assert_not flash.empty?
    
  #ホームviewを出力
    get root_path

  #flashが空っぽだとtrueを返す
    assert flash.empty?
  end
  
  #login成功用test
    test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
