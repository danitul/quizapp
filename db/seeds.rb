# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..5).each do |question_index|
  answers = []
  rand(2..5).times do |answer_index|
    answers << Answer.new(name: "Answer #{answer_index}")
  end
  Question.create(name: "Question #{question_index}", answers: answers)
end