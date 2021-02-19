require "test_helper"

describe Question do
  it 'should create a question correctly' do
    assert_equal 0, Question.count
    answers = build_list(:answer, Question::MIN_ANSWERS)
    create(:question, answers: answers)
    assert_equal 1, Question.count
  end

  describe 'validations' do
    it "does not create a question with no name given" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:question, name: nil)
      end
    end

    it 'does not create a question with less than minimum answers' do
      assert_raises ActiveRecord::RecordInvalid do
        answers = build_list(:answer, Question::MIN_ANSWERS - 1)
        question = create(:question, answers: answers)
        question.save!
      end
    end

    it 'does not create a question with more than maximum answers' do
      assert_raises ActiveRecord::RecordInvalid do
        answers = build_list(:answer, Question::MAX_ANSWERS + 1)
        question = create(:question, answers: answers)
        question.save!
      end
    end
  end
end
