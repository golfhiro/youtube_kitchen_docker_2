class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user == login_from(provider)
      # redirect_to root_path, notice: "#{provider.titleize}でログインしました"
      redirect_back_or_to menus_path(date: Date.today), notice: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        # redirect_to root_path, notice: "#{provider.titleize}でログインしました"
        redirect_back_or_to menus_path(date: Date.today), notice: "#{provider.titleize}でログインしました"
      rescue StandardError
        redirect_to login_path, alert: "#{provider.titleize}でのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end

  # Rails7で追加されたOpen Redirect protectionを無効化するためSorceryのメソッドをオーバーライド
  def login_at(provider_name, args = {})
    redirect_to sorcery_login_url(provider_name, args), allow_other_host: true
  end
end
