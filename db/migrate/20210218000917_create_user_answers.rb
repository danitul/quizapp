class CreateUserAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_answers do |t|
      t.belongs_to :user
      t.belongs_to :question
      t.belongs_to :answer

      t.timestamps
    end

    add_index :user_answers, [:user_id, :question_id], unique: true
  end
end
