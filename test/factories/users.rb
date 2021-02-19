FactoryBot.define do
  factory :user do
    sequence(:uid) { SecureRandom.uuid }
  end
end
