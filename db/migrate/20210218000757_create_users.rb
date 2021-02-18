class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uid, index: { unique: true }
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
