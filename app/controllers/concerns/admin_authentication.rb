module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :check_permission
  end

  private

  #TODO: this should be using proper authentication, like devise
  def current_user_is_admin?
    @current_user = User.find_by(uid: cookies[:user_anon])
    return @current_user && @current_user.is_admin?
  end

  def check_permission
    unless current_user_is_admin?
      render json: { errors: "Not enough access rights" }, status: 401
    end
  end
end