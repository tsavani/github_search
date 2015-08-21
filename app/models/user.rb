
  # create_table "users", force: :cascade do |t|
  #   t.string   "user",       limit: 255
  #   t.datetime "created_at",             null: false
  #   t.datetime "updated_at",             null: false
  # end

class User < ActiveRecord::Base
	validates :user, presence: true
end
