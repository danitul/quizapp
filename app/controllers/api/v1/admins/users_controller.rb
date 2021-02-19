# This gives access to anonymous users to answer the quiz
class Api::V1::Admins::UsersController < ApplicationController
  include AdminAuthentication

  def index
    if current_user_is_admin?
      users = User.includes(:user_answers).all

      # TODO: this should be inside a serializer, but leaving it like this for time constraints
      users_with_user_answers = {
        users: users,
        user_answers: users.map(&:user_answers)
      }
      render json: users_with_user_answers, status: 200
    else
      render json: { errors: "Not enough access rights" }, status: 401
    end
  end

end

