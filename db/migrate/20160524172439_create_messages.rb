class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :message
      t.references :user, foreign_key: true
      t.references :chatroom, foreign_key: true
    end
  end
end
