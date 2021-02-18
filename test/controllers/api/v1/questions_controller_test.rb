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
        user.answer_question(question1.id, answers_q1.first.id)

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
        user.answer_question(question1.id, answers_q1.first.id)
        user.answer_question(question2.id, answers_q2.first.id)

        get "#{url}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        assert_response :no_content
      end
    end

    describe 'user answer' do
      let (:question_url) { "#{url}/#{question1.id}/answer" }

      before do
        question1; question2
      end

      it 'should answer the desired question if question and answer match' do
        initial_user_answers = user.user_answers.size

        put "#{question_url}/#{answers_q1.first.id}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        assert_response 201
        json = JSON.parse(@response.body)
        
        assert_equal user.id, json['id']
        user.reload
        assert_equal initial_user_answers + 1, user.user_answers.size
      end

      it 'should return an error if answer does not match question' do
        put "#{question_url}/#{answers_q2.first.id}", headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Question with id #{question1.id} and/or Answer with id #{answers_q2.first.id} don't match or were not found"
        assert_equal expected_response, json['errors']
      end
    end
=begin
    describe 'update existing workout' do

      it 'should update an existing workout successfully' do
        put "#{trainer_url}/#{@workout.id}", params: { workout: @params }

        assert_response 200
        json = JSON.parse(@response.body)

        workout = Workout.find(@workout.id)
        assert_equal json['id'], workout.id
        assert_equal @params[:name], workout.name
        assert_equal trainer.full_name, workout.creator
        assert_equal workout.duration, json['duration']
        assert_equal workout.state, json['state']
        assert_equal trainer.id, json['trainer_id']
        assert_nil json['trainee_id']
        assert_equal 1, workout.exercises.count
        assert_equal @params[:exercises].first[:name], workout.exercises.first[:name]
        assert_equal @params[:exercises].first[:duration], workout.exercises.first[:duration]
      end

      it 'should return errors if workout params were not correct' do
        @params[:name] = ""
        put "#{trainer_url}/#{@workout.id}", params: { workout: @params }

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = {"name" => ["can't be blank"]}
        assert_equal expected_response, json['errors']
      end

      it 'should return errors if workout does not exist' do
        put "#{trainer_url}/-1", params: { workout: @params }

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Workout with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end
=end
  end
end
