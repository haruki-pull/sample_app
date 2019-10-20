class SessionsController < ApplicationController

  def new
  end
  
  def create
    #ユーザーのパスワード承認
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #sessionキーにユーザー情報の保存
      log_in user
      #remember_user
      #model内のrememberメソッドを使いtokenを生成、ユーザーオブジェクトに紐づけ、dbに保存
      #ユーザーオブジェクトのidとtokenカラムをcoookieに保存
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #user_idが残っていたらのif
    log_out if logged_in?
    redirect_to root_url
  end
end