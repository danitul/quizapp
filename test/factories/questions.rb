FactoryBot.define do
  factory :question do
    sequence(:name) { |n| "Question number #{n} ?" }

    answers do
      Array.new() { a.association(:answer) }
    end
  end
end
