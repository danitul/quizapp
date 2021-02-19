require 'test_helper'

class Api::V1::Admins::QuestionsControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Admins::QuestionsController' do
    let (:url) { "/api/v1/admins/questions" }

    let (:user) { create(:user) }
    let (:admin) { create(:user, is_admin: true)}

    describe 'create new question with answers' do
      before do
        @params = {
          name: 'What is your question ? ',
          answers: [
            { name: 'That is the question' },
            { name: 'There is no question' }
          ]
        }
      end

      it 'should create a new question with answers successfully' do
        initial_question_count = Question.count
        initial_answer_count = Answer.count

        post url, params: { question: @params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        assert_response 201
        assert_equal initial_question_count + 1, Question.count
        assert_equal initial_answer_count + 2, Answer.count

        json = JSON.parse(@response.body)

        question = Question.last
        assert_equal question.id, json['question']['id']
        assert_equal @params[:name], json['question']['name']
        assert_equal 2, json['answers'].size
        assert_equal @params[:answers].first[:name], json['answers'].first['name']
        assert_equal @params[:answers].last[:name], json['answers'].last['name']
      end

      it 'should return error if user is not an admin' do
        post "#{url}", params: { question: @params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        json = JSON.parse(@response.body)
        assert_response 401

        expected_response = "Not enough access rights"
        assert_equal expected_response, json['errors']
      end

      it 'should return errors if question params are not given correctly' do
        params = {
          name: 'Is this question invalid? ',
          answers: [
            { name: 'Only one answer' }
          ]
        }
        post url, params: { question: params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        json = JSON.parse(@response.body)

        assert_response 422
        #expected_response = "Question '#{params[:name]}' could not be created without the required amount of answers"
        #assert_equal expected_response, json['errors']

        expected_response = "A question must have between #{Question::MIN_ANSWERS} and #{Question::MAX_ANSWERS} answers only"
        assert_equal expected_response, json['errors']['answers'][0]
      end

      it 'should return errors if question params are missing' do
        params = {
          answers: [
            { name: 'Only one answer' }
          ]
        }
        post url, params: { question: params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        json = JSON.parse(@response.body)

        assert_response 422
        expected_response = "Question and/or answers were not provided"
        assert_equal expected_response, json['errors']
      end
    end

    describe 'update existing workout' do
      let (:answers) { build_list(:answer, Question::MIN_ANSWERS) }
      let (:question) { create(:question, answers: answers) }

      before do
        @params = {
          name: 'What is your question again? ',
          answers: [
            { name: 'That is the question' },
            { name: 'There is no question' },
            { name: 'A new answer'}
          ]
        }
      end

      it 'should update an existing question with answers successfully' do
        put "#{url}/#{question.id}", params: { question: @params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        assert_response 200
        json = JSON.parse(@response.body)

        question.reload
        assert_equal question.id, json['question']['id']
        assert_equal @params[:name], json['question']['name']
        assert_equal 3, json['answers'].size
        assert_equal @params[:answers].first[:name], json['answers'].first['name']
        assert_equal @params[:answers][1][:name], json['answers'][1]['name']
        assert_equal @params[:answers].last[:name], json['answers'].last['name']
      end

      it 'should return error if user is not an admin' do
        put "#{url}/#{question.id}", params: { question: @params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{user.uid};"}

        json = JSON.parse(@response.body)
        assert_response 401

        expected_response = "Not enough access rights"
        assert_equal expected_response, json['errors']
      end

      it 'should return errors if question params are not given correctly' do
        params = {
          name: 'Is this question invalid? ',
          answers: [
            { name: 'Only one answer' }
          ]
        }
        put "#{url}/#{question.id}", params: { question: params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        json = JSON.parse(@response.body)

        assert_response 422
        expected_response = "A question must have between #{Question::MIN_ANSWERS} and #{Question::MAX_ANSWERS} answers only"
        assert_equal expected_response, json['errors']['answers'][0]
      end

      it 'should return errors if question is not found' do
        put "#{url}/-1", params: { question: @params }, headers: {"HTTP_COOKIE" => "legal_accepted=yes; user_anon=#{admin.uid};"}

        json = JSON.parse(@response.body)

        assert_response 404
        expected_response = "Question with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

  end
end
