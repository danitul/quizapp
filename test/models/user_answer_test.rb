require "test_helper"

describe UserAnswer do
  let (:user) { create(:user) }
  let (:answers) { build_list(:answer, Question::MIN_ANSWERS) }
  let (:question) { create(:question, answers: answers) }

  it 'should create a user answer correctly' do
    assert_equal 0, UserAnswer.count
    create(:user_answer, user: user, question: question, answer: answers.first)
    assert_equal 1, UserAnswer.count
  end

  it 'should not be able to create two answers for the same user and question' do
    create(:user_answer, user: user, question: question, answer: answers.first)
    assert_raises ActiveRecord::RecordInvalid do
      create(:user_answer, user: user, question: question, answer: answers.second)
    end
  end

  it 'should not be able to create a user answer that does not match the question' do
    other_answers = build_list(:answer, Question::MIN_ANSWERS)
    other_question = create(:question, answers: other_answers)
    assert_raises ActiveRecord::RecordInvalid do
      create(:user_answer, user: user, question: question, answer: other_answers.first)
    end
  end
end
