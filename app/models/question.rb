class Question < ApplicationRecord
  MIN_ANSWERS = 2
  MAX_ANSWERS = 5

  has_many :answers
  accepts_nested_attributes_for :answers

  validates :name, presence: true
  validate :answer_count

  def answer_count
    if self.answers.size < MIN_ANSWERS || self.answers.size > MAX_ANSWERS
      errors.add(:answers, "A question must have between #{MIN_ANSWERS} and #{MAX_ANSWERS} answers only")
    end
  end
end
