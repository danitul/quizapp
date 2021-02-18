class User < ApplicationRecord
  has_many :user_answers

  validates :uid, presence: true

  def self.create_anon
    User.create(uid: SecureRandom.uuid)
  end

  def answer_question(question, answer)
    UserAnswer.create(user: self, question: question, answer: answer)
  end

  # returns the next unanswered question,
  # or no question if all have been answered by the user
  def next_question
    all_questions_indexed = Question.all.index_by(&:id)

    user_answered_questions = self.user_answers.pluck(:question_id)
    questions_left_to_answer = all_questions_indexed.keys - user_answered_questions
    all_questions_indexed[questions_left_to_answer.first]
  end
end
