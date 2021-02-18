require "test_helper"

describe Answer do
  let (:question) { build(:question) }

  it 'should create minimum number of allowed answers per question correctly' do
    assert_equal 0, Answer.count
    answers = create_list(:answer, Question::MIN_ANSWERS, question: question)

    create(:answer, question: answers.first.question)
    assert_equal Question::MIN_ANSWERS + 1, Answer.count
  end

  describe 'validations' do
    it "does not create an answer with no name given" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:answer, name: nil)
      end
    end
  end
end
