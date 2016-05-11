class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string   "name"
      t.string   "email"
      t.text     "password_digest"
      t.string   "state"
      t.string   "country",                limit: 75
      t.string   "gender",                 limit: 6
      t.string   "mobile_number",          limit: 16
      t.string   "access_token",           limit: 50
      t.string   "platform"
      t.string   "phone_type"
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.string   "provider"

      t.timestamps
    end
  end
end
