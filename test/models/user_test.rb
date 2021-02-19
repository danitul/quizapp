require "test_helper"

describe User do
  it 'should create a user correctly' do
    assert_equal 0, User.count
    create(:user)
    assert_equal 1, User.count
  end

  describe 'validations' do
    it "does not create a user with no uid given" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:user, uid: nil)
      end
    end
  end

  describe 'next question' do
    let (:user) { create(:user) }

    let (:answers_q1) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question1) { create(:question, answers: answers_q1) }
    let (:answers_q2) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question2) { create(:question, answers: answers_q2) }

    before do
      user; question1; question2
    end

    it 'should return the first available question if none answered yet' do
      assert_equal question1.id, user.next_question.id
    end

    it 'should return the next available question correctly' do
      user.answer_question(question1.id, answers_q1.first.id)
      assert_equal question2.id, user.next_question.id
    end

    it 'should be idempotent, as in it should return the same question even if called multiple times' do
      user.answer_question(question1.id, answers_q1.first.id)
      assert_equal question2.id, user.next_question.id
      assert_equal question2.id, user.next_question.id
    end

    it 'should return no question when there are no more questions to answer' do
      user.answer_question(question1.id, answers_q1.first.id)
      user.answer_question(question2.id, answers_q2.first.id)
      assert_nil user.next_question
    end
  end
end
