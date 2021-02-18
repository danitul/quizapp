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
end
