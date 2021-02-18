# This gives access to anonymous users to answer the quiz
class Api::V1::Admins::UsersController < ApplicationController

  def index
    if current_user_is_admin?
      users = User.includes(:user_answers).all

      # TODO: this should be inside a serializer but leaving it like this for time constraints
      users_with_user_answers = {
        users: users,
        user_answers: users.map(&:user_answers)
      }
      render json: users_with_user_answers, status: 200
    else
      render json: { errors: "Not enough access rights" }, status: 401
    end
  end

  private

  #TODO: this should be using proper authentication, like devise
  def current_user_is_admin?
    @current_user = User.find_by(uid: cookies[:user_anon])
    return @current_user && @current_user.is_admin?
  end

end

