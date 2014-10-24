class Message < ActiveRecord::Base
  belongs_to :video
  has_one :user, :through => :videos
end
