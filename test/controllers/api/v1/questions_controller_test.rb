require 'test_helper'

class Api::V1::QuestionsControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::QuestionsController' do
    let (:url) { "/api/v1/questions" }

    let (:user) { create(:user, uid: SecureRandom.uuid) }

    let (:answers_q1) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question1) { create(:question, answers: answers_q1) }
    let (:answers_q2) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question2) { create(:question, answers: answers_q2) }

    describe 'index' do
      before do
        question1; question2
      end

      it 'should return the next question' do
        user.answer_question(question1, answers_q1.first)

        get "#{url}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal question2.id, json['id']
        assert_equal question2.name, json['name']
      end

      it 'should create new anonymous user and return the first question if cookie is empty' do
        initial_user_count = User.count

        get "#{url}"

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal question1.id, json['id']
        assert_equal question1.name, json['name']

        assert_equal initial_user_count + 1, User.count
      end
      
      it 'should return a success message if there are no more questions to answer' do
        user.answer_question(question1, answers_q1.first)
        user.answer_question(question2, answers_q2.first)

        get "#{url}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        assert_response :no_content
      end
    end

  end
end
