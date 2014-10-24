class Video < ActiveRecord::Base
  belongs_to :user
  has_one :message
end
