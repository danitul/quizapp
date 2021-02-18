require 'test_helper'

class Api::V1::Admins::UsersControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Admins::UsersController' do
    let (:url) { "/api/v1/admins/users" }

    let (:user1) { create(:user, uid: SecureRandom.uuid) }
    let (:user2) { create(:user, uid: SecureRandom.uuid) }
    let (:admin) { create(:user, uid: SecureRandom.uuid, is_admin: true)}

    let (:answers_q1) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question1) { create(:question, answers: answers_q1) }
    let (:answers_q2) { build_list(:answer, Question::MIN_ANSWERS) }
    let (:question2) { create(:question, answers: answers_q2) }

    describe 'index' do
      before do
        user1; user2
        question1; question2
      end

      it 'should return all users with their answers if called by an admin' do
        user1.answer_question(question1.id, answers_q1.first.id)

        get "#{url}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal User.count, json['users'].size
        assert_equal user1.user_answers.first.answer_id, json['user_answers'][0].first['answer_id']
      end

      it 'should return a not authorized error if user is not an admin' do
        get "#{url}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user1.uid};"}

        json = JSON.parse(@response.body)
        assert_response 401

        expected_response = "Not enough access rights"
        assert_equal expected_response, json['errors']
      end
    end

  end
end
