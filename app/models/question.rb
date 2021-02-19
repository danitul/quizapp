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

  # we reset all answers before adding all the current ones again.
  # of course, this would require to change if we would like to be able to update answers and keep the old ids for the user answers
  def update_with_answers(params)
    self.answers = []
    self.assign_attributes(name: params[:name], answers_attributes: params[:answers])
  end
end
