class User < ActiveRecord::Base
	has_many :videos
	has_many :messages :through => :videos
end
