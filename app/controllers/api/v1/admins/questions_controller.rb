# This gives access to admin users to add or edit the quiz
class Api::V1::Admins::QuestionsController < ApplicationController
  include AdminAuthentication

  def create
    if question_params[:name] && question_params[:answers]
      question = Question.new(name: question_params[:name])
      question.answers = question_params[:answers].map do |answer|
        Answer.new(name: answer[:name])
      end
      if question.save
        render json: {
          question: question,
          answers: question.answers
        }, status: 201
      else
        render json: { errors: question.errors }, status: 422
      end
    else
      render json: { errors: "Question and/or answers were not provided"}, status: 422
    end
  end

  def update
    question = Question.find_by(id: params[:id])
    if question
      question.update_with_answers(question_params)
      if question.save
        render json: {
          question: question,
          answers: question.answers
        }, status: 200
      else
        render json: { errors: question.errors }, status: 422
      end
    else
      render json: { errors: "Question with id #{params[:id]} was not found"}, status: 404
    end
  end

  def question_params
    params.require(:question).permit(:name, answers: [:name]).to_h
  end

end

