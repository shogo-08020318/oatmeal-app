class ApplicationController < ActionController::Base
  add_flash_types :success, :warning, :danger

  before_action :require_login

  private

  def not_authenticated
    redirect_to main_app.login_path, warning: t('defaults.require_login')
  end
end
