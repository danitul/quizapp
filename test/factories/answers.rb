FactoryBot.define do
  factory :answer do
    sequence(:name) { |n| "Answer #{n}" }
  end
end
