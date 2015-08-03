class User < ActiveRecord::Base
	validates :user, presence: true
end
