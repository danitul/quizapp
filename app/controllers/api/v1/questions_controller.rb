# This gives access to anonymous users to answer the quiz
class Api::V1::QuestionsController < ApplicationController
  before_action :check_user

  def index
    question = @current_user.next_question

    if question
      render json: question, status: 200
    else
      render json: {}, status: :no_content
    end
  end

  def update
    if @current_user.answer_question(params[:question_id], params[:answer_id])
      render json: @current_user, status: 201
    else
      message = "Question with id #{params[:question_id]} and/or Answer with id #{params[:answer_id]} don't match or were not found"
      render json: { errors: message }, status: 404
    end
  end

  private

  def check_user
    if cookies[:user_anon].nil?
      @current_user = User.create_anon
      cookies[:user_anon] = @current_user.uid
    else
      @current_user = User.find_by(uid: cookies[:user_anon])
    end
  end

end

