module SessionsHelper
 # 渡されたユーザーでログインする
 def log_in(user)
   session[:user_id] = user.id
 end
  
 # 現在ログイン中のユーザーを返す (いる場合)
 def current_user
  #もしsessionメソッドに:user_idが返されれば、＠current_userに代入される
   if session[:user_id]
     @current_user ||= User.find_by(id: session[:user_id])
  #そもそもuser_idがなければ処理は行われない
   end
 end

 def logged_in?
  #もしcurrent_userメソッドがnilでなければtrueを返す
   !current_user.nil?
 end
 
 # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
