class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to boards_path, success: t('.success', item: provider.titleize)
      return
    end
    create_user_from(provider) unless (@user = login_from(provider))
    redirect_to foods_path, success: t('.success', item: provider.titleize)
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def create_user_from(provider)
    @user = create_from(provider)
    # twitterのプロフィール画像が設定されているならそれをavatarとして使用する
    twitter_profile_image(@user_hash[:user_info]['profile_image_url_https']) if @user_hash[:user_info]['profile_image_url_https'].present?
    reset_session
    auto_login(@user)
  end

  # twitterのプロフィール画像は個別で保存
  def twitter_profile_image(profile_image)
    @user.remote_avatar_url = profile_image.gsub(/_normal/, '')
    @user.save!
  end
end
