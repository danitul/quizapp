class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validates_uniqueness_of :user, scope: [:question]

  validate :answer_origin

  def answer_origin
    if self.question != self.answer.question
      errors.add(:user_answer, "A user's answer cannot be from a different question")
    end
  end
end
