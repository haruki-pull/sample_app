require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #とりあえずインスタンス変数宣言
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password:"foobar",password_confirmation: "foobar")
  end
  
  #上で宣言したインスタンス変数が有効か（上とワンセット）
  test "should be valid" do
    assert @user.valid?
  end
  
  #@userのnameが空っぽだったら有効ではない
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  #@userのemailが空っぽだったら有効ではない
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "user name shoud not too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "user email shoud not too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  #emailのvalidation.初めなので正しいものを通せるかの検証
  test "email validation should accept valid addresses" do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
   #emailのvalidation..(ドット)と,(コンマ)の間違いがないか
    test "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert_not @user.valid?, "#{invalid_address.inspect} should be valid" 
      end
    end
    
    test "email should be unique" do
      dupuser = @user.dup
      dupuser.email = @user.email.upcase
      @user.save
      assert_not dupuser.valid?
    end
    
    test "email addresses should be saved as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      assert_equal mixed_case_email.downcase, @user.reload.email
    end
    
    test "password should be presant(no blank)" do
      @user.password = @user.password_confirmation = " "*6
      assert_not @user.valid?
    end
    
    test "password have a minimum length" do
      @user.password = @user.password_confirmation = "a"*5
      assert_not @user.valid?
    end
    
    test "authenticated? should return false for a user with nil digest" do
      assert_not @user.authenticated?(:remember, '')
  end
end