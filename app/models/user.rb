class User < ApplicationRecord
  has_many :user_answers

  validates :uid, presence: true

  def answer_question(question, answer)
    UserAnswer.create(user: self, question: question, answer: answer)
  end
end
