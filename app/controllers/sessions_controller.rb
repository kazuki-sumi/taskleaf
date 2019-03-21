class SessionsController < ApplicationController
  skip_before_action :login_required
  
  def new
  end
  
  def create
    user = User.find_by(email: session_params[:email])
    # nilかもしれないオブジェクトに対して安全にメソッドを呼び出したい場合は「&.演算子」(ぼっち演算子)を使ってメソッドを呼び出す。
    # オブジェクトがnilでない場合はその結果を、nilだった場合はnilを返す。よってエラーにはならない。
    # authenticateメソッドは認証のためのメソッド。
    # 引数で受け取ったパスワードをハッシュ化し、その結果がUserオブジェクト内部に保存されているdigestと一致しているかを調べる。
    # 一致していたらUserオブジェクトを、一致いていなかったらfalseを返す
    # メールアドレスがない場合、userはnilになるのでauthenticateメソッドを呼び出す部分ではぼっち演算子を使っている。
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました・'
    else
      render :new
    end
  end
  
  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end
  
  private
  
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
