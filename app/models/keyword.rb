 # create_table "keywords", force: :cascade do |t|
 #    t.string   "keyword",    limit: 255
 #    t.datetime "created_at",             null: false
 #    t.datetime "updated_at",             null: false
 #  end

class Keyword < ActiveRecord::Base
	validates :keyword , presence: true
end
